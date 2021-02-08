//
//  ProcessMonitor.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 08.02.2021.
//

import Foundation

enum ProcessMonitorEvent {
    case update
    case failure(Error)
}

typealias DispatchMonitorEvent = (ProcessMonitorEvent) -> Void

final class ProcessMonitor {
    
    private let dispatch: DispatchMonitorEvent
    
    init(with dispatch: @escaping DispatchMonitorEvent) {
        self.dispatch = dispatch
    }
    
    private(set) var processes:[Process] = []
}
