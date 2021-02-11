//
//  ProcessesListViewModel.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 05.02.2021.
//

import Foundation

final class ProcessesListViewModel {
    
    private let monitorObserver: EventObserver<ProcessMonitorEvent>
    private let displayEventsDispatch: (ProcessDisplayEvent) -> ()
    
    init(with processes: Set<ProcessData>,
         monitorObserver: MonitorEventObserver,
         displayDispatch: @escaping (ProcessDisplayEvent) -> ()) {
        self.processes = processes
        self.monitorObserver = monitorObserver
        self.displayEventsDispatch = displayDispatch
        
        //TODO: it's ugly, find a better way
        monitorObserver.onReceivedEvent = callUnowned(self, ProcessesListViewModel.handle)
        resortProcesses(processes)
    }
    
    var sortedProcesses: [ProcessData] = []
    private var processes: Set<ProcessData> {
        didSet {
            resortProcesses(processes)
        }
    }
    
    func handle(_ event: ProcessMonitorEvent) {
        switch event {
        case .update(let added, let removed):
            processes = processes.subtracting(removed).union(added)
        case .failure(let error):
            fatalError("Bam \(error)")
        }
    }
    
    private func resortProcesses(_ processes: Set<ProcessData>) {
        sortedProcesses = Array(processes).sorted(by: \.pid)
    }
    
    func didSelect(_ process: ProcessData) {
        displayEventsDispatch(.didSelect(process))
    }
}

extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }
}
