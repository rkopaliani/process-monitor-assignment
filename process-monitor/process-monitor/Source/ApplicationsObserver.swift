//
//  ProcessObserver.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 08.02.2021.
//

import Foundation
import AppKit

protocol ApplicationsObserverDelegate: AnyObject {
    func applicationsObserver(_ observer: ApplicationsObserver,
                              didObserve update: [NSRunningApplication])
}

final class ApplicationsObserver {

    private(set) weak var delegate: ApplicationsObserverDelegate?
    init(with delegate: ApplicationsObserverDelegate) {
        self.delegate = delegate
    }
    
    private var observation: NSKeyValueObservation?
    
    func subscribe(_ workspace: NSWorkspace) {
        self.observation = workspace.observe(\.runningApplications, onChange: { [weak self] apps in
            guard let self = self else  { return }
            self.delegate?.applicationsObserver(self, didObserve: apps)
        })
    }
    
    func unsubscribe() {
        observation?.invalidate()
    }
    
    deinit {
        unsubscribe()
    }
}

final class Observer<Root: NSObject, Value> {
    
    let root: Root
    init(_ root: Root) {
        self.root = root
    }
    
    private var observation: NSKeyValueObservation?
    
    func subscribe<Value>(_ keypath: KeyPath<Root, Value>, onChange: @escaping (Value) -> ()) {
        observation = root.observe(keypath, onChange: onChange)
    }
    
    func unsubscribe() {
        observation?.invalidate()
    }
    
    deinit {
        unsubscribe()
    }
}
