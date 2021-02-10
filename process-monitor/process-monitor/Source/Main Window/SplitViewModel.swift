//
//  SplitViewModel.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 10.02.2021.
//

import Cocoa

final class SplitViewModel {
    let dispatcher: EventDispatcher<EventHandlingViewModel>
    let processMonitor: ProcessMonitor
    
    init(monitor: ProcessMonitor,
         dispatcher: EventDispatcher<EventHandlingViewModel>) {
        self.dispatcher = dispatcher
        self.processMonitor = monitor
    }
}
