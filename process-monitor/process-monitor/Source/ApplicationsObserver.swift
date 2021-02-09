//
//  ProcessObserver.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 08.02.2021.
//

import Foundation
import AppKit

final class Observer<Root: NSObject> {
    
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
