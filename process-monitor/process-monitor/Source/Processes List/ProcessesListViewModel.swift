//
//  ProcessesListViewModel.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 05.02.2021.
//

import Foundation

final class ProcessesListViewModel: EventHandlingViewModel {

    private let monitor: ProcessMonitor
    init(with monitor: ProcessMonitor) {
        self.monitor = monitor
    }
    
    private(set) var processes: [ProcessInfo] = []
    
    override func handle(_ event: ProcessMonitorEvent) {
        switch event {
        case .update:
            processes = Array(monitor.processes)
        case .failure(let error):
            fatalError("Bam \(error)")
        }
    }
}

