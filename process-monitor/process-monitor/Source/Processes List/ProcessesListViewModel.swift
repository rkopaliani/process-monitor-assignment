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
    
    private var sortDescriptors: [SortDescriptor<ProcessData>] = [SortDescriptor.sorted(by: \.pid)]
    
    init(with processes: Set<ProcessData>,
         monitorObserver: MonitorEventObserver,
         displayDispatch: @escaping DisplayEventHandler) {
        self.processes = processes
        self.monitorObserver = monitorObserver
        self.displayEventHandler = displayDispatch
        
        //TODO: it's ugly, find a better way
        monitorObserver.onReceivedEvent = callUnowned(self, ProcessesListViewModel.handle)
        resort()
    }
    
    var sortedProcesses: [ProcessData] = []
    private var processes: Set<ProcessData> {
        didSet { resort() }
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
        
    func didSelect(_ process: ProcessData) {
        displayEventHandler(.didSelect(process))
    }
    
    func sort(by descriptors: [NSSortDescriptor]) {
        let sortDescriptors: [SortDescriptor<ProcessData>] = descriptors.compactMap { descriptor in
            guard let key = descriptor.key,
                  let identifier = ProcessListColumnId(rawValue: key)
            else { return nil }
            
            switch identifier {
            case .pid: return SortDescriptor.sorted(by: \.pid, ascending: descriptor.ascending)
            case .uid: return SortDescriptor.sorted(by: \.uid, ascending: descriptor.ascending)
            case .path: return SortDescriptor.sorted(by: \.displayPath, ascending: descriptor.ascending)
            }
        }
        sort(by: sortDescriptors)
    }
    
    private func sort(by sortDescriptors: [SortDescriptor<ProcessData>]) {
        let finalDescriptor = SortDescriptor.multiple(sortDescriptors)
        sortedProcesses = processes.sorted(by: finalDescriptor.orderedAscending)
        self.sortDescriptors = sortDescriptors
    }
    
    private func resort() {
        sort(by: sortDescriptors)
    }
}
