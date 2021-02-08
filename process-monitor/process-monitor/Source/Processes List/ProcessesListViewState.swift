//
//  ProcessesListViewState.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 05.02.2021.
//

import Foundation

typealias ColumnLocalizedIdentifier = String

enum ColumnSortingOrder: Int, Codable {
    case ascending
    case descending
}

struct ProcessesListViewState: Codable {
    let columns: [ColumnLocalizedIdentifier]
    let sortedBy: ColumnLocalizedIdentifier
    let order: ColumnSortingOrder
}
