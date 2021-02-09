//
//  ProcessesListViewModel.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 05.02.2021.
//

import Foundation

final class ProcessesListViewModel: EventHandlingViewModel {

    init(with processes: [ProcessInfo]) {
        self.processes = processes
    }
    
    private(set) var processes: [ProcessInfo]
    
    override func handle(_ event: ProcessMonitorEvent) {
        switch event {
        case .update(let added, let removed):
            processes = processes.filter({ removed.contains($0 )})
            processes.append(contentsOf: added)
        case .failure(let error):
            fatalError("Bam \(error)")
        }
    }
}

