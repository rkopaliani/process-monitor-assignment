//
//  WindowViewModel.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 10.02.2021.
//

import Cocoa

typealias ViewModelUpdate = () -> ()

final class WindowViewModel {

    var onUpdate: ViewModelUpdate?
    
    let monitor: ProcessMonitor
    let monitoringEventsDispatcher: EventDispatcher<MonitorEventObserver>
    let displayEventsDispatcher: EventDispatcher<DisplayEventObserver>
    
    let monitoringObserver: MonitorEventObserver
    let displayObserver: DisplayEventObserver
    
    private var selectedProcess: ProcessData?
    
    init(monitor: ProcessMonitor,
         monitorDispatcher: EventDispatcher<MonitorEventObserver>,
         displayDispatcher: EventDispatcher<DisplayEventObserver>) {
        self.monitor = monitor
        self.monitoringEventsDispatcher = monitorDispatcher
        self.displayEventsDispatcher = displayDispatcher
        
        monitoringObserver = MonitorEventObserver()
        displayObserver = DisplayEventObserver()

        monitorDispatcher.add(monitoringObserver)
        monitoringObserver.onReceivedEvent = callUnowned(self, WindowViewModel.handleMonitor)
        
        displayDispatcher.add(displayObserver)
        displayObserver.onReceivedEvent = callUnowned(self, WindowViewModel.handleDisplay)
    }
    
    var killButtonEnaled: Bool = true
    var processCount: Int { return monitor.processes.count }
    
    var totalProcessText: String {
        return "\(monitor.processes.count) processes are running"
    }
    
    func killProcess() {
        guard let process = selectedProcess else { return }
        monitor.kill(process)
    }
    
    private func handleMonitor(_ event: ProcessMonitorEvent) {
        onUpdate?()
    }
    
    private func handleDisplay(_ event: ProcessDisplayEvent) {
        switch event {
        case .didSelect(let process):
            self.selectedProcess = process
        }
    }
}
