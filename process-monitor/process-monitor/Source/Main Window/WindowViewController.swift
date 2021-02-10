//
//  WindowViewController.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 05.02.2021.
//

import Cocoa

final class WindowViewController: NSViewController, StoryboardInstantiatable {

    @IBOutlet private weak var killButton: NSButton!
    @IBOutlet private weak var containerView: NSView!

    private let workspaceObserver = Observer(NSWorkspace.shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let eventsDispatcher = EventDispatcher<EventHandlingViewModel>()
        let processMonitor = ProcessMonitor(workspaceObserver, callback: eventsDispatcher.dispatch)

        let splitViewModel = SplitViewModel(monitor: processMonitor, dispatcher: eventsDispatcher)
        let splitViewController = SplitViewController.instaniate { $0.viewModel = splitViewModel }
        embed(splitViewController, in: containerView)
    }
}
