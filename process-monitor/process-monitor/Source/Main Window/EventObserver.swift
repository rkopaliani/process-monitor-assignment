//
//  EventHandlingViewModel.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 09.02.2021.
//

import Foundation


typealias MonitorEventObserver = EventObserver<ProcessMonitorEvent>
typealias DisplayEventObserver = EventObserver<ProcessDisplayEvent>

final class EventObserver<EventType>: EventHandlerType {
    weak var source: AnyObject?
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

func callUnowned<T: AnyObject, U, V>(_ instance: T, _ classFunction: @escaping (T) -> (U) -> V) -> (U) -> V {
    return { [unowned instance] args in
        let instanceFunction = classFunction(instance)
        return instanceFunction(args)
    }
}


func callUnowned<T: AnyObject>(_ instance: T, _ classFunction: @escaping (T) -> () -> ()) -> () -> () {
    return { [unowned instance]  in
        let instanceFunction = classFunction(instance)
        return instanceFunction()
    }
}

func callWeak<T: AnyObject>(_ instance: T, _ classFunction: @escaping (T) -> () -> ()) -> () -> () {
    return { [weak instance]  in
        guard let instance = instance else { return }
        let instanceFunction = classFunction(instance)
        return instanceFunction()
    }
}
