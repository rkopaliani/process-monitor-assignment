//
//  ProcessMonitor.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 08.02.2021.
//

import Foundation

@objc protocol ProcessMonitorDelegate {
}

final class ProcessMonitor {
    
    private(set) var processes:[Process] = []
    private(set) var delegates = NSHashTable<ProcessMonitorDelegate>(options: NSHashTableWeakMemory)
    
    func addDelegate(_ delegate: ProcessMonitorDelegate) {
        delegates.add(delegate)
    }
    
    func removeDelegate(_ delegate: ProcessMonitorDelegate) {
        delegates.remove(delegate)
    }
}
