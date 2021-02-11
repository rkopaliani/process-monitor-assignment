//
//  WindowController.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 05.02.2021.
//

import Cocoa

final class WindowController: NSWindowController {
    
    private let workspaceObserver = Observer(NSWorkspace.shared)

    override func windowDidLoad() {
        let dispatcher = EventDispatcher<MonitorEventObserver>()
        let processMonitor = ProcessMonitor(workspaceObserver, callback: dispatcher.dispatch)
        let viewModel = WindowViewModel(monitor: processMonitor, dispatcher: dispatcher)
        let windowViewController = WindowViewController.instaniate { $0.viewModel = viewModel }
        contentViewController = windowViewController
    }
}
