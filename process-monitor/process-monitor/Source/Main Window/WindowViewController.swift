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
        
        localize()
    }
    
    @IBAction func killButtonTapped(_ sender: NSButton) {
        viewModel.killProcess()
    }
    
    private func update() {
        killButton.isEnabled = viewModel.killButtonEnaled
        let processFormat = NSLocalizedString("window.bottom-container.label.processes",
                                              comment: "Window number of process label")
        totalProcessLabel.stringValue = String.localizedStringWithFormat(processFormat, viewModel.processCount)
    }

    private func localize() {
        killButton.title = NSLocalizedString("window.bottom-container.button.kill", comment: "Kill Button Title")
    }
}
