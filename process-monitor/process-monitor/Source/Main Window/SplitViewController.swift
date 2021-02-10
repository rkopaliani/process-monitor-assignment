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
        
    override func viewDidLoad() {
        super.viewDidLoad()

        observer = Observer(NSWorkspace.shared)
        eventsDispatcher = EventDispatcher<EventHandlingViewModel>()
        processMonitor = ProcessMonitor(observer, callback: eventsDispatcher.dispatch)
        
        let listViewModel = ProcessesListViewModel(with: processMonitor.processes)
        eventsDispatcher.add(listViewModel)

        let listViewController = ProcessesListViewController.instaniate { $0.viewModel = listViewModel }
        addSplitViewItem(NSSplitViewItem(contentListWithViewController: listViewController))
        
        let detailsViewController = ProcessDetailsViewController.instaniate { _ in }
        addSplitViewItem(NSSplitViewItem(contentListWithViewController: detailsViewController))
    }
}
