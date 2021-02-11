//
//  SplitViewModel.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 10.02.2021.
//

import Cocoa

enum ProcessDisplayEvent {
    case didSelect(ProcessData)
}

final class SplitViewModel {
    let monitorEventsDispatcher: EventDispatcher<ProcessMonitorEventObserver>
    let processMonitor: ProcessMonitor
    
    init(monitor: ProcessMonitor,
         monitorEventsDispatcher: EventDispatcher<ProcessMonitorEventObserver>) {
        self.monitorEventsDispatcher = monitorEventsDispatcher
        self.processMonitor = monitor
    }
}
