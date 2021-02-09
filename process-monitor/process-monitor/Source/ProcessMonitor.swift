//
//  ProcessMonitor.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 08.02.2021.
//

import Foundation
import AppKit

enum ProcessMonitorEvent {
    case update
    case failure(Error)
}

typealias DispatchMonitorEvent = (ProcessMonitorEvent) -> Void

final class ProcessMonitor {
    
    private let dispatch: DispatchMonitorEvent
    private let observer: Observer<NSWorkspace>
    private var processes: [Any] = []
    init(_ observer: Observer<NSWorkspace>, dispatch: @escaping DispatchMonitorEvent) {
        self.dispatch = dispatch
        self.observer = observer
    }
    
    
//    private let appObserver: ApplicationsObserverType
//
//    init(with appObserver: ApplicationsObserverType, dispatch: @escaping DispatchMonitorEvent) {
//        self.dispatch = dispatch
//        self.appObserver = appObserver
//    }
//
//    private(set) var processes: [Process] = []
}

