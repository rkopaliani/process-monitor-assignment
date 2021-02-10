//
//  ProcessesListViewController.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 05.02.2021.
//

import Cocoa

final class ProcessesListViewController: NSViewController, StoryboardInstantiatable {

    @IBOutlet private weak var tableView: NSTableView!
        
    var viewModel: ProcessesListViewModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
}

extension ProcessesListViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        viewModel?.sortedProcesses.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView,
                   viewFor tableColumn: NSTableColumn?,
                   row: Int) -> NSView? {
        guard let columnId = tableColumn?.identifier else { return nil }
        guard let process = viewModel?.sortedProcesses[row] else { return nil }
    
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
            cell.textField?.stringValue = "\(process.path)"
            return cell
        default:
            fatalError("Unexpected columnId \(columnId.rawValue)")
        }
    }
}

extension ProcessesListViewController: NSTableViewDelegate {
    
}
