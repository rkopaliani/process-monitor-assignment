//
//  ProcessMonitor.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 08.02.2021.
//

import Foundation
import AppKit

enum ProcessMonitorEvent {
    case update(added: [ProcessData], removed:[ProcessData])
    case failure(error: Error)
}

typealias ProcessMonitorCallback = (ProcessMonitorEvent) -> Void

final class ProcessMonitor {
    private let callback: ProcessMonitorCallback
    private let observer: Observer<NSWorkspace>
    init(_ observer: Observer<NSWorkspace>, callback: @escaping ProcessMonitorCallback) {
        self.callback = callback
        self.observer = observer
        observer.subscribe(\.runningApplications) { [weak self] (added, removed) in
            guard let self = self else { return }
            self.process(added, removed: removed)
        }
    }
    
    func kill(_ process: ProcessData) {
        
    }
    
    private(set) var processes: Set<ProcessData> = []
}

extension ProcessMonitor {
    private func process(_ added: [NSRunningApplication]?, removed: [NSRunningApplication]?) {
        let addedSet = Set
            .compactSet(from: added, transform: ProcessData.init)
            .subtracting(processes)
        
        let removedSet = Set
            .compactSet(from: removed, transform: ProcessData.init)
            .intersection(processes)
        
        guard addedSet.count > 0 || removedSet.count > 0 else {  return }
        processes = processes.subtracting(removedSet).union(addedSet)
        callback(.update(added: Array(addedSet), removed: Array(removedSet)))
    }
}

extension Set {
    static func compactSet<Value: Hashable>(from arr: [Element]?,
                                            transform: (Element) -> Value?) -> Set<Value> {
        guard let array = arr else { return Set<Value>() }
        return Set<Value>(array.compactMap(transform))
    }
}
