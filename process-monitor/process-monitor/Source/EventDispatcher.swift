//
//  EventDispatcher.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 08.02.2021.
//

import Foundation

protocol EventHandler {
    associatedtype Event
    func handle(_ event: Event)
}


final class EventDispatcher<Handler: EventHandler & Equatable & AnyObject> {
    private var handlers: WeakArray<Handler> = WeakArray([])
    
    func add(_ handler: Handler) {
        guard !handlers.contains(where: { $0 == handler }) else { return }
        handlers.append(handler)
    }
    
    func dispatch(_ event: Handler.Event) {
        handlers.forEach { $0?.handle(event) }
    }
}
