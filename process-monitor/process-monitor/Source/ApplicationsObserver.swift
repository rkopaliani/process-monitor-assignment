//
//  ProcessObserver.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 08.02.2021.
//

import Foundation
import AppKit

typealias ApplicationsUpdate = ([NSRunningApplication]) -> ()
protocol ObserverType: AnyObject {
    func start()
    func stop()
}

protocol ApplicationsObserverDelegate: AnyObject {
    func applicationsObserver(_ observer: ApplicationsObserver, didObserveUpdate update: [NSRunningApplication])
}

final class ApplicationsObserver {

    private weak var delegate: ApplicationsObserverDelegate?
    private var observation: NSKeyValueObservation?
    init(with delegate: ApplicationsObserverDelegate, workspace: NSWorkspace) {
        self.delegate = delegate
        self.observation = workspace.observe(\.runningApplications, onChange: { [weak self] apps in
            guard let self = self else  { return }
            self.delegate?.applicationsObserver(self, didObserveUpdate: apps)
        })
    }
    
//    let update: ApplicationsUpdate
//    init(_ update: @escaping ApplicationsUpdate) {
//        self.update = update
//    }
//
//    private var observation: NSKeyValueObservation?
//
//    deinit {
//        stop()
//    }
}

//extension ApplicationsObserver: ObserverType {
//    func start() {
//        observation = NSWorkspace.shared.observe(\.runningApplications, onChange: { [weak self] runningApplucations in
//            guard let self = self else  { return }
//            self.update(runningApplucations)
//        })
//    }
//
//    func stop() {
//        observation?.invalidate()
//    }
//}
