//
//  SortDescriptor.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 11.02.2021.
//

import Foundation

enum SortDescriptor<T> {
    
    case multiple([SortDescriptor<T>])
    case singular((T, T) -> ComparisonResult, Bool)
    
    func compare(_ lhs: T, _ rhs: T) -> ComparisonResult {
        switch self {
        case .multiple(let descriptors):
            for descriptor in descriptors {
                switch descriptor.compare(lhs, rhs) {
                case .orderedSame: continue
                case .orderedAscending: return .orderedAscending
                case .orderedDescending: return .orderedDescending
                }
            }
            
            return .orderedSame
        case .singular(let compare, let ascending):
            let result = compare(lhs, rhs)
            return ascending ? result : result.inverted()
        }
    }
    
    func orderedAscending(_ lhs: T, _ rhs: T) -> Bool {
        return compare(lhs, rhs) == .orderedAscending
    }
}

extension ComparisonResult {
    func inverted() -> ComparisonResult {
        switch self {
        case .orderedAscending: return .orderedDescending
        case .orderedDescending: return .orderedAscending
        default: return self
        }
    }
}

extension Comparable {
    func compare(to: Self) -> ComparisonResult {
        if self < to {
            return .orderedAscending
        } else if self == to {
            return .orderedSame
        } else {
            return .orderedDescending
        }
    }
}

extension SortDescriptor {
    static func sorted<K: Comparable>(by keyPath: KeyPath<T, K>, ascending: Bool = true) -> SortDescriptor<T> {
        return .singular({ $0[keyPath: keyPath].compare(to: $1[keyPath: keyPath]) }, ascending)
    }
}

//extension SortDescriptor {
//    static func descriptor(from sortDescriptor: NSSortDescriptor) -> SortDescriptor {
//        return .sorted(by:sortDescriptor.comparator, ascending: sortDescriptor.ascending)
//    }
//
//    static func descriptor(from sortDescriptors: [NSSortDescriptor]) -> SortDescriptor {
//        let mapped = sortDescriptors.map(SortDescriptor.descriptor)
//        return .multiple(mapped)
//    }
//}
