//
//  NSObjectProtocol+KVOExtensions.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 08.02.2021.
//

import Foundation

extension NSObjectProtocol where Self: NSObject {
    func observe<Value>(_ keyPath: KeyPath<Self, Value>, onChange: @escaping (Value?, Value?) -> ()) -> NSKeyValueObservation {
        return observe(keyPath, options: [.initial, .old, .new]) { _, change in
            var added: Value?
            var removed: Value?
            
            switch change.kind {
            case .setting:
                added = change.newValue
            case .insertion:
                added = change.newValue
            case .removal:
                removed = change.oldValue
            case .replacement:
                removed = change.oldValue
            @unknown default:
                fatalError()
            }
            
            onChange(added, removed)
        }
    }
}
