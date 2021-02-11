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

typealias EquatableEventHandlerType = EventHandlerType & Equatable

final class EventDispatcher<Handler: EquatableEventHandlerType>: EventDispatcherType {
    //TODO: replace array with set, it should not be a bottleneck, but set makes sense much more here
    //TODO: might be good idea to add sync queue for add/delete methods
    //TODO: this class doesn't make sence now after all the refactoring, need to rethink interface
    
    private let deliveryQueue: DispatchQueue
    private let syncQueue: DispatchQueue
    init(queue: DispatchQueue = .main) {
        self.deliveryQueue = queue
        self.syncQueue = DispatchQueue.init(label: "com.romankopaliani.assignment.dispatcher")
    }
    
    private var handlers: WeakArray<Handler> = WeakArray([])
    
    func add(_ handler: Handler) {
        self.syncQueue.sync {
            guard !handlers.contains(where: { $0 == handler }) else { return }
            handlers.append(handler)
        }
    }
    
    func delete(_ handler: Handler) {
        self.syncQueue.sync {
            guard let index = handlers.firstIndex(of: handler) else { return }
            handlers.remove(at: index)
        }
    }
    
    func dispatch(_ event: Handler.Event) {
        deliveryQueue.async { [weak self] in
            guard let self = self else { return }
            self.handlers.forEach { $0?.handle(event) }
        }
    }
}
