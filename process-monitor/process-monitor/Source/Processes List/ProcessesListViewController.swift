//
//  ProcessesListViewController.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 05.02.2021.
//

import Cocoa

final class ProcessesListViewController: NSViewController, StoryboardInstantiatable {
    //TODO: Force unwrapping is unfortunate here. With Storyboard + < macOS 15.0 that's quickiest way, but it's dirty.
    var viewModel: ProcessesListViewModel! {
        didSet {
            viewModel.onProcessListUpdate = callUnowned(self, ProcessesListViewController.handle)
        }
    }
    
    @IBOutlet private weak var tableView: NSTableView!
    
    private func handle(_ update: ListDiff) {
        tableView.beginUpdates()
        tableView.removeRows(at: update.removedIdx, withAnimation: .effectFade)
        tableView.insertRows(at: update.addedIdx, withAnimation: .effectFade)
        tableView.endUpdates()
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
    
        let process = viewModel.sortedProcesses[row]
        
        switch columnId.rawValue {
        case "nameCell":
            let cell = tableView.makeView(withIdentifier: columnId, owner: self) as! NSTableCellView
            cell.textField?.stringValue = "\(process.pid)"
            return cell
        case "userCell":
            let cell = tableView.makeView(withIdentifier: columnId, owner: self) as! NSTableCellView
            cell.textField?.stringValue = "\(process.uid)"
            return cell
        case "pathCell":
            let cell = tableView.makeView(withIdentifier: columnId, owner: self) as! NSTableCellView
            cell.textField?.stringValue = process.displayPath
            return cell
        default:
            fatalError("Unexpected columnId \(columnId.rawValue)")
        }
    }
}

extension ProcessesListViewController: NSTableViewDelegate {
    func tableViewSelectionDidChange(_ notification: Notification) {
        viewModel.didSelect(viewModel.sortedProcesses[tableView.selectedRow])
    }
}
