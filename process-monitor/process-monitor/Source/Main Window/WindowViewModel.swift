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

final class WindowViewModel {

    weak var delegate: WindowViewModelDelegate?
    
    let monitor: ProcessMonitor
    let eventsDispatcher: EventDispatcher<MonitorEventObserver>
    init(monitor: ProcessMonitor, dispatcher: EventDispatcher<MonitorEventObserver>) {
        self.monitor = monitor
        self.eventsDispatcher = dispatcher
    }
    
    var killButtonEnaled: Bool = true
    var totalProcessText: String {
        return ""
    }
}
