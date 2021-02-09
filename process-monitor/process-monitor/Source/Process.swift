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
        var kinfo = kinfo_proc()
        var size  = MemoryLayout<kinfo_proc>.stride
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, app.processIdentifier]
        
        guard sysctl(&mib, u_int(mib.count), &kinfo, &size, nil, 0) == 0 else {
            fatalError("Something went wrong. Abort. Check this later")
            return nil
        }

        self.pid = app.processIdentifier
        self.ppid = kinfo.kp_eproc.e_ppid
        self.uid = kinfo.kp_eproc.e_ucred.cr_uid

        self.bundleId = app.bundleIdentifier
        self.path = app.bundleURL?.absoluteString ?? ""
        self.certificateTeamId = "cert"
    }
}
