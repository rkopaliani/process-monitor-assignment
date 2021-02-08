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


final class EventDispatcher<Handler: AnyObject & EventHandler> {
    private var handlers: WeakArray<Handler> = WeakArray([])
    
    func dispatch(_ event: Handler.Event) {
        
    }
}
