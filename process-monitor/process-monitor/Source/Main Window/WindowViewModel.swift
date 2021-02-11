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
    init(monitor: ProcessMonitor,
         monitorDispatcher: EventDispatcher<MonitorEventObserver>,
         displayDispatcher: EventDispatcher<DisplayEventObserver>) {
        self.monitor = monitor
        self.monitoringEventsDispatcher = monitorDispatcher
        self.displayEventsDispatcher = displayDispatcher
    }
    
    var killButtonEnaled: Bool = true
    var totalProcessText: String {
        return ""
    }
}
