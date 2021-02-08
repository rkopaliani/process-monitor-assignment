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


class EventDispatcher {
    
}
