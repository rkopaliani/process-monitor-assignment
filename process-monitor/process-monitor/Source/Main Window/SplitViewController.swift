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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let observer = MonitorEventObserver()
        viewModel.monitorEventsDispatcher.add(observer)
        let listViewModel = ProcessesListViewModel(with: viewModel.processMonitor.processes,
                                                   monitorObserver: observer)

        let listViewController = ProcessesListViewController.instaniate { $0.viewModel = listViewModel }
        listViewController.delegate = self
        addSplitViewItem(NSSplitViewItem(contentListWithViewController: listViewController))
        self.listViewController = listViewController
        
        let displayObserver = DisplayEventObserver()
        let detailsViewModel = ProcessDetailsViewModel(observer: displayObserver)
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
