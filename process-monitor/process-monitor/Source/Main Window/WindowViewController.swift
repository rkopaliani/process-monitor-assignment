//
//  WindowViewController.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 05.02.2021.
//

import Cocoa

final class WindowViewController: NSViewController, StoryboardInstantiatable {

    var viewModel: WindowViewModel!
    
    @IBOutlet private weak var killButton: NSButton!
    @IBOutlet private weak var totalProcessLabel: NSTextField!
    @IBOutlet private weak var containerView: NSView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let splitViewModel = SplitViewModel(monitor: viewModel.monitor,
                                            monitorEventsDispatcher: viewModel.eventsDispatcher)
        let splitViewController = SplitViewController.instaniate { $0.viewModel = splitViewModel }
        embed(splitViewController, in: containerView)
        
        handleViewModelUpdate(viewModel)
    }
}

extension WindowViewController: WindowViewModelDelegate {
    func windowViewModelDidUpdate(_ viewModel: WindowViewModel) {
        handleViewModelUpdate(viewModel)
    }
    
    private func handleViewModelUpdate(_ viewModel: WindowViewModel) {
//        killButton.isEnabled = viewModel.killButtonEnaled
//        totalProcessLabel.stringValue = viewModel.totalProcessText
    }
}
