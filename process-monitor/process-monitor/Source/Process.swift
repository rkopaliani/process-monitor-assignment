//
//  Process.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 03.02.2021.
//

import Foundation
import AppKit
import Darwin

//TODO: Bad name, but ProcessInfo is already occupied, think about more if there is some time
struct ProcessData {
    let pid: pid_t
    let ppid: pid_t
    let uid: uid_t
    let path: URL
    
    var name: String?
    var bundleId: String?
    var certificateTeamId: String?
    
    var signingInfo: SigningInfo?
}

extension ProcessData {
    var displayName: String {
        if let name = name { return name }
        return FileManager.default.displayName(atPath: path.absoluteString)
    }
    
    var displayPath: String {
        return path.standardizedFileURL.path
    }
}

extension ProcessData: Hashable {}

extension ProcessData {
    init?(_ app: NSRunningApplication) {
        guard let ppid = ProcessDataFetcher.fetchPid(for: app.processIdentifier),
              let uid = ProcessDataFetcher.fetchUid(for: app.processIdentifier) else {
            return nil
        }
        
        self.pid = app.processIdentifier
        self.ppid = ppid
        self.uid = uid
        self.name = app.localizedName
        self.bundleId = app.bundleIdentifier
        self.path = app.executableURL!
        self.certificateTeamId = "cert"
        self.signingInfo = CodeSigningInfoExtractor.extract(for: self.pid)
    }
}

enum CodeSigner {
    case apple
    case appstore
    case developer
    case adHoc
}

struct SigningInfo: Hashable {
    let codeSigner: CodeSigner
    var teamIdentifier: String?
    var signingIdentifier: String?
}


fileprivate struct ProcessDataFetcher {
    //TODO: not the best idea to call sysctl two times for no reason at all. Return tuple with pid and uid.
    static func fetchPid(for pid: pid_t) -> pid_t? {
        var kinfo = kinfo_proc()
        var size  = MemoryLayout<kinfo_proc>.stride
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, pid]
        
        guard sysctl(&mib, u_int(mib.count), &kinfo, &size, nil, 0) == 0 else {
            print("Something went wrong in sysctl on parentPid.")
            return nil
        }
        
        return kinfo.kp_eproc.e_ppid
    }

    static func fetchUid(for pid: pid_t) -> uid_t? {
        var kinfo = kinfo_proc()
        var size  = MemoryLayout<kinfo_proc>.stride
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, pid]
        
        guard sysctl(&mib, u_int(mib.count), &kinfo, &size, nil, 0) == 0 else {
            print("Something went wrong in sysctl on uid.")
            return nil
        }
        
        return kinfo.kp_eproc.e_ucred.cr_uid
    }
}


fileprivate struct CodeSigningInfoExtractor {
    
    //TODO: it's not thread safe, though thread-safety better be ensured on a callers site
    static var appleSecRequirement: SecRequirement? = {
        var isApple: SecRequirement?
        SecRequirementCreateWithString("anchor apple" as CFString,
                                       SecCSFlags(rawValue: 0),
                                       &isApple)
        return isApple
    }()
    
    static var appStoreSecRequirement: SecRequirement? = {
        var requirement: SecRequirement?
        SecRequirementCreateWithString("anchor apple generic and certificate leaf [subject.CN] = \"Apple Mac OS Application Signing\"" as CFString,
                                       SecCSFlags(rawValue: 0),
                                       &requirement)
        return requirement
    }()

    static var developerSecRequirement: SecRequirement? = {
        var requirement: SecRequirement?
        SecRequirementCreateWithString("anchor apple generic" as CFString,
                                       SecCSFlags(rawValue: 0),
                                       &requirement)
        return requirement
    }()

    
    static func extract(for pid: pid_t) -> SigningInfo? {
        var status: OSStatus = -1
        var dynamicCode: SecCode?
        /*
            Get SecCode for a running process
         **/
        status = SecCodeCopyGuestWithAttributes(nil,
                                                [kSecGuestAttributePid : pid] as CFDictionary,
                                                SecCSFlags([]),
                                                &dynamicCode)
        guard status == errSecSuccess, let unwrappedDynamicCode = dynamicCode else { return nil }
        
        /*
            Perform dynamic validation of a SecCode
         **/
        status = SecCodeCheckValidity(unwrappedDynamicCode, SecCSFlags([]), nil)
        guard status == errSecSuccess else { return nil }
        
        /*
            Get code signer. It's not required, but we have to show something
            when for example there is no code signing info with adHoc
         **/
        let codeSigner = extractCodeSigner(unwrappedDynamicCode, flags: SecCSFlags([]))
        
        /*
            Cast dynamic code to static code
         **/
        var signingInfo: CFDictionary?
        var staticCode: SecStaticCode?
        status = SecCodeCopyStaticCode(unwrappedDynamicCode, SecCSFlags([]), &staticCode)
        guard status == errSecSuccess, let unwrappedStaticCode = staticCode else { return nil }

        /*
            Finally get signing dictionary
         **/
        status = SecCodeCopySigningInformation(unwrappedStaticCode,
                                               SecCSFlags(rawValue: kSecCSSigningInformation),
                                               &signingInfo)
        guard status == errSecSuccess,
              let castedSigningInfo = signingInfo as? Dictionary<AnyHashable, Any>
        else { return nil }

        return SigningInfo(codeSigner: codeSigner,
                           teamIdentifier: castedSigningInfo[kSecCodeInfoTeamIdentifier] as? String,
                           signingIdentifier: castedSigningInfo[kSecCodeInfoIdentifier] as? String)
    }
    
    static func extractCodeSigner(_ code: SecCode, flags: SecCSFlags) -> CodeSigner {
        if SecCodeCheckValidity(code, flags, appleSecRequirement) == errSecSuccess { return .apple }
        else if SecCodeCheckValidity(code, flags, appStoreSecRequirement) == errSecSuccess { return .appstore }
        else if SecCodeCheckValidity(code, flags, developerSecRequirement) == errSecSuccess { return .developer }
        return .adHoc
    }
}
