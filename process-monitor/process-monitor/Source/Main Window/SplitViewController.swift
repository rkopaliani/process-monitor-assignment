//
//  SplitViewController.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 05.02.2021.
//

import Cocoa


final class SplitViewController: NSSplitViewController, StoryboardInstantiatable {

    var viewModel: SplitViewModel!
    var listViewController: ProcessesListViewController?
    var detailsViewController: ProcessDetailsViewController?
    let displayEventDispatcher: EventDispatcher<DisplayEventObserver> = EventDispatcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let observer = MonitorEventObserver()
        viewModel.monitorEventsDispatcher.add(observer)
        let listViewModel = ProcessesListViewModel(with: viewModel.processMonitor.processes,
                                                   monitorObserver: observer,
                                                   displayDispatcher: displayEventDispatcher)
        
        let listViewController = ProcessesListViewController.instaniate { $0.viewModel = listViewModel }

        addSplitViewItem(NSSplitViewItem(contentListWithViewController: listViewController))
        self.listViewController = listViewController
        
        let displayObserver = DisplayEventObserver()
        displayEventDispatcher.add(displayObserver)
        let detailsViewModel = ProcessDetailsViewModel(observer: displayObserver)
        let detailsViewController = ProcessDetailsViewController.instaniate { $0.viewModel = detailsViewModel }
        addSplitViewItem(NSSplitViewItem(contentListWithViewController: detailsViewController))
        self.detailsViewController = detailsViewController
    }
}
