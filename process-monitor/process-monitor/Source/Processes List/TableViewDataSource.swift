//
//  TableViewDataSource.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 10.02.2021.
//

import AppKit


protocol TableViewDataSourceDelegate {
    associatedtype Cell: NSTableCellView
    associatedtype Object
    
    func configure(_ cell: Cell, with columnId: String, for object: Object)
}

protocol DataProvider {
    associatedtype Object
        
    func object(at idx: Int) -> Object
    func numberOfObjects() -> Int
}

protocol DataProviderDelegate {
    func provider(_ provider: DataProvider, didChangeObject: Value)
}

final class TableViewDataSource<Delegate: TableViewDataSourceDelegate>: NSObject, NSTableViewDataSource {
    typealias Object = Delegate.Object
    typealias Cell = Delegate.Cell
    
//    required init(tableView: NSTableView, initialData: [Object], )
}
