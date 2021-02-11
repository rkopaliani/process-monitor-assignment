//
//  WindowViewModel.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 10.02.2021.
//

import Cocoa

protocol WindowViewModelDelegate: AnyObject {
    func windowViewModelDidUpdate(_ viewModel: WindowViewModel)
}

final class WindowViewModel: EventHandlingViewModel {

    weak var delegate: WindowViewModelDelegate?
    
    let monitor: ProcessMonitor
    let eventsDispatcher: EventDispatcher<EventHandlingViewModel>
    init(monitor: ProcessMonitor, dispatcher: EventDispatcher<EventHandlingViewModel>) {
        self.monitor = monitor
        self.eventsDispatcher = dispatcher
        super.init()
        dispatcher.add(self)
    }
    
    var killButtonEnaled: Bool = true
    var totalProcessText: String {
        return ""
    }
    
    override func handle(_ event: ProcessMonitorEvent) {}
}
