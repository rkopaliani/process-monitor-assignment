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
    let path: String
    
    var bundleId: String?
    var certificateTeamId: String?
    
    var signingInfo: SigningInfo?
}

extension ProcessData: Hashable {}

extension ProcessData {
    init?(_ app: NSRunningApplication) {
        
        guard let ppid = fetchPid(for: app.processIdentifier),
              let uid = fetchUid(for: app.processIdentifier) else {
            print("bail")
            return nil
        }
        
        self.pid = app.processIdentifier
        self.ppid = ppid
        self.uid = uid
        self.bundleId = app.bundleIdentifier
        self.path = app.bundleURL?.absoluteString ?? ""
        self.certificateTeamId = "cert"
        self.signingInfo = extractCodeSigningInfo(for: self.pid)
        print("ProcessID \(pid), user \(self.uid) bunldeId \(String(describing: self.bundleId)), path\(self.path)")
    }
}


func fetchPid(for pid: pid_t) -> pid_t? {
    var kinfo = kinfo_proc()
    var size  = MemoryLayout<kinfo_proc>.stride
    var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, pid]
    
    guard sysctl(&mib, u_int(mib.count), &kinfo, &size, nil, 0) == 0 else {
        print("Something went wrong in sysctl on parentPid.")
        return nil
    }
    
    return kinfo.kp_eproc.e_ppid
}

func fetchUid(for pid: pid_t) -> uid_t? {
    var kinfo = kinfo_proc()
    var size  = MemoryLayout<kinfo_proc>.stride
    var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, pid]
    
    guard sysctl(&mib, u_int(mib.count), &kinfo, &size, nil, 0) == 0 else {
        print("Something went wrong in sysctl on uid.")
        return nil
    }
    
    return kinfo.kp_eproc.e_ucred.cr_uid
}

enum CodeSinger {
    case apple
    case appstore
    case developer
    case adHoc
}

struct SigningInfo: Hashable {
    let signingStatus: OSStatus
    let codeSigner: CodeSinger
}

func extractCodeSigningInfo(for pid: pid_t) -> SigningInfo? {
    var status: OSStatus = -1
    var dynamicCode: SecCode?
    status = SecCodeCopyGuestWithAttributes(nil,
                                            [kSecGuestAttributePid : pid] as CFDictionary,
                                            SecCSFlags([]),
                                            &dynamicCode)
    guard status == errSecSuccess else { return nil }
    guard let unwrappedDynamicCode = dynamicCode else { return nil }
    
    status = SecCodeCheckValidity(unwrappedDynamicCode, SecCSFlags([]), nil)
    guard status == errSecSuccess else { return nil }
    
    let codeSigner = extractCodeSigner(unwrappedDynamicCode, flags: SecCSFlags([]))
    
    var signingInfo: CFDictionary?
    var staticCode: SecStaticCode?
    status = SecCodeCopyStaticCode(unwrappedDynamicCode, SecCSFlags([]), &staticCode)
    guard status == errSecSuccess else { return nil }
    guard let unwrappedStaticCode = staticCode else { return nil }

    status = SecCodeCopySigningInformation(unwrappedStaticCode,
                                           SecCSFlags(rawValue: kSecCSSigningInformation),
                                           &signingInfo)
    guard status == errSecSuccess else { return nil }
    guard let castedSigningInfo = signingInfo as? Dictionary<AnyHashable, Any> else { return nil }
    
    if let teamIdentifier = castedSigningInfo[kSecCodeInfoTeamIdentifier] as? String {
        print(teamIdentifier)
    }

    if let dentifier = castedSigningInfo[kSecCodeInfoIdentifier] as? String {
        print(dentifier)
    }

    return SigningInfo(signingStatus: status, codeSigner: codeSigner)
}

func extractCodeSigner(_ code: SecCode, flags: SecCSFlags) -> CodeSinger {
    var isApple: SecRequirement?
    var isAppStore: SecRequirement?
    var isDeveloper: SecRequirement?
    
    _ = SecRequirementCreateWithString("anchor apple" as CFString,
                                       SecCSFlags(rawValue: 0),
                                       &isApple)
    _ = SecRequirementCreateWithString("anchor apple generic and certificate leaf [subject.CN] = \"Apple Mac OS Application Signing\"" as CFString,
                                       SecCSFlags(rawValue: 0),
                                       &isAppStore)
    _ = SecRequirementCreateWithString("anchor apple generic" as CFString,
                                       SecCSFlags(rawValue: 0),
                                       &isDeveloper)

    if SecCodeCheckValidity(code, flags, isApple) == errSecSuccess {
        return .apple
    } else if SecCodeCheckValidity(code, flags, isAppStore) == errSecSuccess {
        return .appstore
    } else if SecCodeCheckValidity(code, flags, isDeveloper) == errSecSuccess {
        return .developer
    }
    return .adHoc
}
