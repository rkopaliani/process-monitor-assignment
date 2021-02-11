//
//  EventDispatcher.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 08.02.2021.
//

import Foundation

protocol EventHandlerType: AnyObject {
    associatedtype Event
    func handle(_ event: Event)
}

protocol EventDispatcherType: AnyObject {
    associatedtype Event
    func dispatch(_ event: Event)
}

protocol EventHandlerStoreType {
    associatedtype Handler = EquatableEventHandlerType
    func add(_ handler: Handler)
    func delete(_ handler: Handler)
}

typealias EquatableEventHandlerType = EventHandlerType & Equatable

final class EventDispatcher<Handler: EquatableEventHandlerType>: EventDispatcherType & EventHandlerStoreType {
    //ToDo: replace array with set, it should not be a bottleneck, but set makes sense much more here
    //ToDo: might be good idea to add sync queue for add/delete methods
    
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
