//
//  WindowController.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 05.02.2021.
//

import Cocoa

final class WindowController: NSWindowController {
    
    override func windowDidLoad() {        
        let windowViewController = WindowViewController.instaniate { _ in }
        contentViewController = windowViewController
    }
}
