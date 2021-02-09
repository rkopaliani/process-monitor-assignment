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

extension ProcessInfo {
    init(_ runningApplication: NSRunningApplication) {
        self.pid = runningApplication.processIdentifier
        self.ppid = runningApplication.processIdentifier
        self.uid = 0
        self.path = runningApplication.bundleURL?.absoluteString ?? ""
        self.bundleId = runningApplication.bundleIdentifier
        self.certificateTeamId = "cert"
    }
}


