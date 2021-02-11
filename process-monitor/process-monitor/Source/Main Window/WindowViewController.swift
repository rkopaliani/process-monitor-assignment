//
//  WindowViewController.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 05.02.2021.
//

import Cocoa

final class WindowViewController: NSViewController, StoryboardInstantiatable {

    var viewModel: WindowViewModel! {
        didSet {
            viewModel.onUpdate = callWeak(self, WindowViewController.update)
        }
    }
    
    @IBOutlet private weak var killButton: NSButton!
    @IBOutlet private weak var totalProcessLabel: NSTextField!
    @IBOutlet private weak var containerView: NSView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let splitViewModel = SplitViewModel(monitor: viewModel.monitor,
                                            monitorEventsDispatcher: viewModel.monitoringEventsDispatcher, displayDispatcher: viewModel.displayEventsDispatcher)
        let splitViewController = SplitViewController.instaniate { $0.viewModel = splitViewModel }
        embed(splitViewController, in: containerView)
        update()
    }
    
    private func update() {
        killButton.isEnabled = viewModel.killButtonEnaled
        totalProcessLabel.stringValue = viewModel.totalProcessText
    }
}
