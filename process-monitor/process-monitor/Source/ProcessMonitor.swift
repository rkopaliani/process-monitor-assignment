//
//  ProcessMonitor.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 08.02.2021.
//

import Foundation

@objc protocol ProcessMonitorDelegate {
    
}

final class ProcessMonitor {
    
    private(set) var processes:[Process] = []
    private(set) var delegates = NSHashTable<ProcessMonitorDelegate>(options: NSHashTableWeakMemory)
    
    func addDelegate(_ delegate: ProcessMonitorDelegate) {
        delegates.add(delegate)
    }
    
    func removeDelegate(_ delegate: ProcessMonitorDelegate) {
        delegates.remove(delegate)
    }
}


extension NSObjectProtocol where Self: NSObject {
    func observe<Value>(_ keyPath: KeyPath<Self, Value>, onChange: @escaping (Value) -> ()) -> NSKeyValueObservation {
        return observe(keyPath, options: [.initial, .new]) { _, change in
            // TODO: change.newValue should never be `nil`, but when observing an optional property that's set to `nil`, then change.newValue is `nil` instead of `Optional(nil)`. This is the bug report for this: https://bugs.swift.org/browse/SR-6066
            guard let newValue = change.newValue else { return }
            onChange(newValue)
        }
    }

    func bind<Value, Target>(_ sourceKeyPath: KeyPath<Self, Value>, to target: Target, at targetKeyPath: ReferenceWritableKeyPath<Target, Value>) -> NSKeyValueObservation {
        return observe(sourceKeyPath) { target[keyPath: targetKeyPath] = $0 }
    }
}
