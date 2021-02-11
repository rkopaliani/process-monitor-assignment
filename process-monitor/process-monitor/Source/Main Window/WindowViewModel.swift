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
    let observer: MonitorEventObserver
    
    init(monitor: ProcessMonitor,
         monitorDispatcher: EventDispatcher<MonitorEventObserver>,
         displayDispatcher: EventDispatcher<DisplayEventObserver>) {
        self.monitor = monitor
        self.monitoringEventsDispatcher = monitorDispatcher
        self.displayEventsDispatcher = displayDispatcher
        
        observer = MonitorEventObserver()
        monitorDispatcher.add(observer)
        observer.onReceivedEvent = callUnowned(self, WindowViewModel.handleMonitor)
    }
    
    var killButtonEnaled: Bool = true
    var totalProcessText: String {
        return "\(monitor.processes.count) processes are running"
    }
    
    private func handleMonitor(_ event: ProcessMonitorEvent) {
        onUpdate?()
    }
}
