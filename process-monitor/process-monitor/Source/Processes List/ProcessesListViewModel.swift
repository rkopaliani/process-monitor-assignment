//
//  ProcessesListViewModel.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 05.02.2021.
//

import Foundation

protocol ProcessesListViewModelDelegate: AnyObject {
    func viewModel(_ viewModel: ProcessesListViewModel,
                   willAdd added: [ProcessData],
                   willRemove removed:[ProcessData])
}

final class ProcessesListViewModel {

    weak var delegate: ProcessesListViewModelDelegate?
    
    let monitorObserver: EventObserver<ProcessMonitorEvent>
    init(with processes: Set<ProcessData>, monitorObserver: EventObserver<ProcessMonitorEvent>) {
        self.processes = processes
        self.monitorObserver = monitorObserver
        monitorObserver.onReceivedEvent = handle
        //TODO: it's ugly, find a better way
        resortProcesses(processes)
    }
    
    var sortedProcesses: [ProcessData] = []
    private var processes: Set<ProcessData> {
        didSet {
            resortProcesses(processes)
        }
    }
    
    private func handle(_ event: ProcessMonitorEvent) {
        switch event {
        case .update(let added, let removed):
            delegate?.viewModel(self, willAdd: added, willRemove: removed)
            processes = processes.subtracting(removed).union(added)
        case .failure(let error):
            fatalError("Bam \(error)")
        }
    }
    
    private func resortProcesses(_ processes: Set<ProcessData>) {
        sortedProcesses = Array(processes).sorted(by: \.pid)
    }
}

extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }
}
