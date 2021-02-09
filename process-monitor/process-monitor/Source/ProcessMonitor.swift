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

typealias ProcessMonitorCallback = (ProcessMonitorEvent) -> Void

final class ProcessMonitor {
    private let callback: ProcessMonitorCallback
    private let observer: Observer<NSWorkspace>
    init(_ observer: Observer<NSWorkspace>, callback: @escaping ProcessMonitorCallback) {
        self.callback = callback
        self.observer = observer
        observer.subscribe(\.runningApplications) { [weak self] value in
            guard let self = self else { return }
            self.handle(value)
        }
    }
    
    private(set) var processes: Set<ProcessInfo> = []
}

extension ProcessMonitor {
    private func handle(_ update: [NSRunningApplication]) {
        let updateProcess = Set(update.compactMap(ProcessInfo.init))
        guard processes != updateProcess else { return }
        processes = updateProcess
        callback(.update)
    }
}
