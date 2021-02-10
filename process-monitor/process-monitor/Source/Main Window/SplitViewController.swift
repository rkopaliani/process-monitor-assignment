//
//  SplitViewController.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 05.02.2021.
//

import Cocoa


final class SplitViewController: NSSplitViewController {

    var eventsDispatcher: EventDispatcher<EventHandlingViewModel>!
    var processMonitor: ProcessMonitor!
    var observer: Observer<NSWorkspace>!
    
    var listViewController: ProcessesListViewController {
        return self.splitViewItems.first?.viewController as! ProcessesListViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        processMonitor = ProcessMonitor(observer, callback: eventsDispatcher.dispatch)
        eventsDispatcher = EventDispatcher<EventHandlingViewModel>()
        observer = Observer(NSWorkspace.shared)
        
        let listViewModel = ProcessesListViewModel(with: processMonitor.processes)
        eventsDispatcher.add(listViewModel)

        let listViewController = ProcessesListViewController.instaniate { vc in
            vc.viewModel = listViewModel
        }
        
    }
}
