//
//  SplitViewController.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 05.02.2021.
//

import Cocoa


final class SplitViewController: NSSplitViewController, StoryboardInstantiatable {

    var eventsDispatcher: EventDispatcher<EventHandlingViewModel>!
    var processMonitor: ProcessMonitor!
    var observer: Observer<NSWorkspace>!
    
    var listViewController: ProcessesListViewController?
    var detailsViewController: ProcessDetailsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        observer = Observer(NSWorkspace.shared)
        eventsDispatcher = EventDispatcher<EventHandlingViewModel>()
        processMonitor = ProcessMonitor(observer, callback: eventsDispatcher.dispatch)
        
        let listViewModel = ProcessesListViewModel(with: processMonitor.processes)
        eventsDispatcher.add(listViewModel)

        let listViewController = ProcessesListViewController.instaniate { $0.viewModel = listViewModel }
        listViewController.delegate = self
        addSplitViewItem(NSSplitViewItem(contentListWithViewController: listViewController))
        self.listViewController = listViewController
        
        let detailsViewModel = ProcessDetailsViewModel()
        let detailsViewController = ProcessDetailsViewController.instaniate { $0.viewModel = detailsViewModel }
        addSplitViewItem(NSSplitViewItem(contentListWithViewController: detailsViewController))
        self.detailsViewController = detailsViewController
    }
}

extension SplitViewController: ProcessesListViewControllerDelegate {
    func processList(_ sender: ProcessesListViewController, didSelect process: ProcessData) {
        detailsViewController?.viewModel.process = process
    }
}
