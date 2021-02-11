//
//  ProcessDetailsViewController.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 05.02.2021.
//

import Cocoa

final class ProcessDetailsViewController: NSViewController, StoryboardInstantiatable {

    var viewModel: ProcessDetailsViewModel! {
        didSet {
            viewModel.onModelUpdate = callWeak(self, ProcessDetailsViewController.applyViewModelChanges)
        }
    }
    
    @IBOutlet weak var processNameLabel: NSTextField!
    @IBOutlet weak var pidLabel: NSTextField!
    @IBOutlet weak var ppidLabel: NSTextField!
    @IBOutlet weak var pathLabel: NSTextField!
    @IBOutlet weak var teamCertLabel: NSTextField!
    @IBOutlet weak var bundleIdLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyViewModelChanges()
    }
    
    private func applyViewModelChanges() {
        processNameLabel.stringValue = viewModel.name
        pidLabel.stringValue = viewModel.pid
        ppidLabel.stringValue = viewModel.ppid
        pathLabel.stringValue = viewModel.path
        teamCertLabel.stringValue = viewModel.team
        bundleIdLabel.stringValue = viewModel.bundleId
    }
}
