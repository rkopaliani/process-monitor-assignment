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
        window?.title = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        window?.minSize = NSMakeSize(600, 600)
        
        let monitoringDispatcher = EventDispatcher<MonitorEventObserver>()
        let displayEventDispatcher = EventDispatcher<DisplayEventObserver>()

        let processMonitor = ProcessMonitor(workspaceObserver, callback: monitoringDispatcher.dispatch)
        let viewModel = WindowViewModel(monitor: processMonitor,
                                        monitorDispatcher: monitoringDispatcher,
                                        displayDispatcher: displayEventDispatcher)
        let windowViewController = WindowViewController.instaniate { $0.viewModel = viewModel }
        contentViewController = windowViewController
    }
}
