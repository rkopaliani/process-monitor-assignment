//
//  ProcessDetailsViewModel.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 10.02.2021.
//

import Foundation

final class ProcessDetailsViewModel {
    
    var onModelUpdate: (() -> ())?
    let displayObserver: DisplayEventObserver!
    
    init(observer: DisplayEventObserver) {
        self.displayObserver = observer
        observer.onReceivedEvent = callUnowned(self, ProcessDetailsViewModel.handle)
    }
    
    private(set) var name: String = ""
    private(set) var pid: String = ""
    private(set) var ppid: String = ""
    private(set) var path: String = ""
    private(set) var team: String = ""
    private(set) var bundleId: String = ""
    
    private var process: ProcessData? {
        didSet {
            guard let process = process else { return }
            name = process.displayName
            pid = "PID: \(process.pid)"
            ppid = "PPID: \(process.ppid)"
            path = process.displayPath
            team = process.signingInfo?.teamIdentifier ?? ""
            bundleId = process.bundleId ?? ""
            onModelUpdate?()
        }
    }
    
    private func handle(_ event: ProcessDisplayEvent) {
        switch event {
        case .didSelect(let process):
            self.process = process
        }
    }
}
