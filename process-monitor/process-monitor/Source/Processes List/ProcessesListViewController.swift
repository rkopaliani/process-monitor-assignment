//
//  ProcessesListViewController.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 05.02.2021.
//

import Cocoa


enum ProcessListColumnId: String {
    case pid = "pid"
    case uid = "uid"
    case path = "path"
}

extension NSTableColumn {
    static func setTitle(_ title: String,
                         for columnId: ProcessListColumnId,
                         in table: NSTableView) {
        guard let column = table.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier(columnId.rawValue)) else {
            return
        }
        column.headerCell.title = title
    }
}

final class ProcessesListViewController: NSViewController, StoryboardInstantiatable {
    //TODO: Force unwrapping is unfortunate here. With Storyboard + < macOS 15.0 that's quickiest way, but it's dirty.
    var viewModel: ProcessesListViewModel! {
        didSet {
            viewModel.onProcessListUpdate = callUnowned(self, ProcessesListViewController.handle)
        }
    }
    
    @IBOutlet private weak var tableView: NSTableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        applyLocalization()
    }
    
    private func handle(_ update: ListDiff) {
        tableView.beginUpdates()
        tableView.removeRows(at: update.removedIdx, withAnimation: .effectFade)
        tableView.insertRows(at: update.addedIdx, withAnimation: .effectFade)
        tableView.endUpdates()
    }
    
    private func applyLocalization() {
        NSTableColumn.setTitle(NSLocalizedString("process-list.table.header.key.pid",
                                                 comment: "ProcessID Column Header"),
                               for: .pid,
                               in: tableView)
        
        NSTableColumn.setTitle(NSLocalizedString("process-list.table.header.key.uid",
                                                 comment: "UserID Column Header"),
                               for: .uid,
                               in: tableView)
        
        NSTableColumn.setTitle(NSLocalizedString("process-list.table.header.key.path",
                                                 comment: "Path Column Header"),
                               for: .path,
                               in: tableView)
    }
}

//TODO: Extract in a separate class and cover with tests, same goes for NSTableViewDelegate
extension ProcessesListViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        let count = viewModel.sortedProcesses.count
        print(count)
        return count
    }
    
    func tableView(_ tableView: NSTableView,
                   viewFor tableColumn: NSTableColumn?,
                   row: Int) -> NSView? {
        guard let columnId = tableColumn?.identifier else { return nil }
        guard row < viewModel.sortedProcesses.count else { return nil }
        guard let columndIdentifier = ProcessListColumnId(rawValue: columnId.rawValue) else {
            return nil
        }
        
        let process = viewModel.sortedProcesses[row]
        switch columndIdentifier {
        case .pid:
            let cell = tableView.makeView(withIdentifier: columnId, owner: self) as! NSTableCellView
            cell.textField?.stringValue = "\(process.pid)"
            return cell
        case .uid:
            let cell = tableView.makeView(withIdentifier: columnId, owner: self) as! NSTableCellView
            cell.textField?.stringValue = "\(process.uid)"
            return cell
        case .path:
            let cell = tableView.makeView(withIdentifier: columnId, owner: self) as! NSTableCellView
            cell.textField?.stringValue = process.displayPath
            return cell
        }
    }
}

extension ProcessesListViewController: NSTableViewDelegate {
    func tableViewSelectionDidChange(_ notification: Notification) {
        viewModel.didSelect(viewModel.sortedProcesses[tableView.selectedRow])
    }
}
