//
//  Process.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 03.02.2021.
//

import Foundation

struct ProcessInfo {
    let pid: pid_t
    let ppid: pid_t
    let uid: uid_t
    let path: String
    
    var bundleId: String?
    var certificateTeamId: String?
}


