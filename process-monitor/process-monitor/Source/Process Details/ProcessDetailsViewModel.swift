//
//  ProcessDetailsViewModel.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 10.02.2021.
//

import Foundation

protocol ProcessDetailsViewModelDelegate: AnyObject {
    func processDetailsViewModelDidUpdate(_ viewModel: ProcessDetailsViewModel)
}

final class ProcessDetailsViewModel: EventHandlingViewModel {
    
    weak var delegate: ProcessDetailsViewModelDelegate?
    
    private(set) var name: String = ""
    private(set) var pid: String = ""
    private(set) var ppid: String = ""
    private(set) var path: String = ""
    private(set) var team: String = ""
    private(set) var bundleId: String = ""
    
    var process: ProcessData? {
        didSet {
            guard let process = process else { return }
            name = process.displayName
            pid = "PID: \(process.pid)"
            ppid = "PPID: \(process.ppid)"
            path = process.displayPath
            team = process.certificateTeamId ?? ""
            bundleId = process.bundleId ?? ""
            delegate?.processDetailsViewModelDidUpdate(self)
        }
    }
    
    override func handle(_ event: ProcessMonitorEvent) {
        //TODO: nothing here yet, but implement when some update event for the exisiting process is added
    }
}
