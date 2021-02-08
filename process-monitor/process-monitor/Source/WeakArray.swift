//
//  WeakArray.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 08.02.2021.
//

import Foundation

final fileprivate class WeakBox<T: AnyObject & Equatable> {
    weak var unbox: T?
    init(_ value: T?) {
        unbox = value
    }
}

extension WeakBox: Equatable {
    static func == (lhs: WeakBox<T>, rhs: WeakBox<T>) -> Bool {
        return lhs.unbox == rhs.unbox
    }
}

struct WeakArray<T: AnyObject & Equatable> {
    private var items: [WeakBox<T>] = []

    init(_ elements: [T]) {
        items = elements.map { WeakBox($0) }
    }

    init(_ elements: [T?]) {
        items = elements.map { WeakBox($0) }
    }

    mutating func append(_ obj:T?) {
        items.append(WeakBox(obj))
    }

    mutating func remove(at:Int) {
        items.remove(at: at)
    }
}

extension WeakArray: Collection {
    var startIndex: Int { return items.startIndex }
    var endIndex: Int { return items.endIndex }

    subscript(_ index: Int) -> T? {
        return items[index].unbox
    }

    func index(after idx: Int) -> Int {
        return items.index(after: idx)
    }
}

extension WeakArray {
    
}
