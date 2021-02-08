//
//  ProcessesListViewController.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 05.02.2021.
//

import Cocoa

final class ProcessesListViewController: NSViewController {

    @IBOutlet private weak var outineView: NSOutlineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        outineView.dataSource = self
        outineView.delegate = self
        
        let center = NSWorkspace.shared.notificationCenter
        let runningApps = NSWorkspace.shared.runningApplications
        
        center.addObserver(self, selector: #selector(appLaunched(_:)), name: NSWorkspace.willLaunchApplicationNotification, object: nil)
        center.addObserver(self, selector: #selector(appTerminated(_:)), name: NSWorkspace.didTerminateApplicationNotification, object: nil)
    }
    
    @objc func appLaunched(_ n: Notification) {
        print(n)
        let runningApps = NSWorkspace.shared.runningApplications
        print(runningApps)
    }
    
    @objc func appTerminated(_ n: Notification) {
        print(n)
    }

}

extension ProcessesListViewController: NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
         return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        return nil
    }
}

extension ProcessesListViewController: NSOutlineViewDelegate {
    
}
