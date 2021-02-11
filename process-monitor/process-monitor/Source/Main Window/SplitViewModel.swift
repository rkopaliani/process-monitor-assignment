//
//  SplitViewModel.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 10.02.2021.
//

import Cocoa

typealias DisplayEventHandler = (ProcessDisplayEvent) -> ()

enum ProcessDisplayEvent {
    case didSelect(ProcessData)
}

final class SplitViewModel {
    let monitorEventsDispatcher: EventDispatcher<MonitorEventObserver>
    let displayDispatcher: EventDispatcher<DisplayEventObserver>
    let processMonitor: ProcessMonitor
    
    init(monitor: ProcessMonitor,
         monitorEventsDispatcher: EventDispatcher<MonitorEventObserver>,
         displayDispatcher: EventDispatcher<DisplayEventObserver>) {
        self.monitorEventsDispatcher = monitorEventsDispatcher
        self.processMonitor = monitor
        self.displayDispatcher = displayDispatcher
    }
}
