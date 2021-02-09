//
//  Process.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 03.02.2021.
//

import Foundation
import AppKit

struct ProcessInfo {
    let pid: pid_t
    let ppid: pid_t
    let uid: uid_t
    let path: String
    
    var bundleId: String?
    var certificateTeamId: String?
}

extension ProcessInfo: Hashable {}

extension ProcessInfo {
    init?(_ app: NSRunningApplication) {
        guard let ppid = fetchPid(for: app.processIdentifier),
              let uid = fetchUid(for: app.processIdentifier) else {
            return nil
        }
        self.pid = app.processIdentifier
        self.ppid = ppid
        self.uid = uid

        self.bundleId = app.bundleIdentifier
        self.path = app.bundleURL?.absoluteString ?? ""
        self.certificateTeamId = "cert"
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


