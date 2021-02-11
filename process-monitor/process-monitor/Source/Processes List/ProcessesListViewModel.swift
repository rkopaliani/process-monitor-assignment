//
//  ProcessesListViewModel.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 05.02.2021.
//

import Foundation

struct ListDiff {
    let addedIdx: IndexSet
    let removedIdx: IndexSet
}

typealias ListUpdateHandle = (ListDiff) -> ()

final class ProcessesListViewModel {
    
    var onProcessListUpdate: ListUpdateHandle?
    
    private let monitorObserver: EventObserver<ProcessMonitorEvent>
    private let displayEventHandler: DisplayEventHandler
    
    init(with processes: Set<ProcessData>,
         monitorObserver: MonitorEventObserver,
         displayDispatch: @escaping DisplayEventHandler) {
        self.processes = processes
        self.monitorObserver = monitorObserver
        self.displayEventHandler = displayDispatch
        
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
            let addedSet = Set(added).subtracting(processes)
            let removedSet = Set(removed).intersection(processes)
            let removedIdx = IndexSet(removedSet.map({ sortedProcesses.firstIndex(of: $0)! }))
            processes = processes.subtracting(removed).union(added)
            let addedIdx = IndexSet(addedSet.map({ sortedProcesses.firstIndex(of: $0)! }))
            guard removedIdx.count > 0 || addedIdx.count > 0 else { return }
            guard let update = onProcessListUpdate else { return }
            update(ListDiff(addedIdx: addedIdx, removedIdx: removedIdx))
        case .failure(let error):
            fatalError("Bam \(error)")
        }
    }
    
    private func resortProcesses(_ processes: Set<ProcessData>) {
        sortedProcesses = Array(processes).sorted(by: \.pid)
    }
    
    func didSelect(_ process: ProcessData) {
        displayEventHandler(.didSelect(process))
    }
}

extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }
}
