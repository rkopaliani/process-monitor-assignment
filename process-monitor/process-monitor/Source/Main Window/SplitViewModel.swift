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
    let processMonitor: ProcessMonitor
    
    init(monitor: ProcessMonitor,
         monitorEventsDispatcher: EventDispatcher<MonitorEventObserver>) {
        self.monitorEventsDispatcher = monitorEventsDispatcher
        self.processMonitor = monitor
    }
}
