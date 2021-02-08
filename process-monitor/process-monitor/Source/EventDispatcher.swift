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
    //ToDo: replace array with set, it should not be a bottleneck, but set makes sense much more here
    private var handlers: WeakArray<Handler> = WeakArray([])
    
    func add(_ handler: Handler) {
        guard !handlers.contains(where: { $0 == handler }) else { return }
        handlers.append(handler)
    }
    
    func delete(_ handler: Handler) {
        guard let index = handlers.firstIndex(of: handler) else { return }
        handlers.remove(at: index)
    }
    
    func dispatch(_ event: Handler.Event) {
        handlers.forEach { $0?.handle(event) }
    }
}
