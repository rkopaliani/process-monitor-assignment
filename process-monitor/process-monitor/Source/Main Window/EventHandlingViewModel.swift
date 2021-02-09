//
//  EventHandlingViewModel.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 09.02.2021.
//

import Foundation

open class EventHandlingViewModel: EventHandler {
    typealias Event = ProcessMonitorEvent
    func handle(_ event: ProcessMonitorEvent) {}
}

extension EventHandlingViewModel: Equatable {
    public static func ==(lhs: EventHandlingViewModel, rhs: EventHandlingViewModel) -> Bool {
        return lhs === rhs
    }
}
