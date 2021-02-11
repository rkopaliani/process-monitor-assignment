//
//  EventHandlingViewModel.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 09.02.2021.
//

import Foundation

final class EventObserver<EventType>: EventHandlerType {
    typealias Event = EventType
    
    var onReceivedEvent: ((EventType) -> ())?
    
    func handle(_ event: EventType) {
        onReceivedEvent?(event)
    }
}

extension EventObserver: Equatable {
    public static func ==(lhs: EventObserver, rhs: EventObserver) -> Bool {
        return lhs === rhs
    }
}

typealias MonitorEventObserver = EventObserver<ProcessMonitorEvent>
typealias DisplayEventObserver = EventObserver<ProcessDisplayEvent>
