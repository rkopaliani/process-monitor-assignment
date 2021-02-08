//
//  event_dispatcher_tests.swift
//  process-monitorTests
//
//  Created by Roman Kopaliani on 08.02.2021.
//

import XCTest
@testable import process_monitor

protocol MockEventHandlerType: EventHandler {}

class MockEventHandler: MockEventHandlerType {
    typealias Event = Int
    var event: Int = 0
    func handle(_ event: Int) {
        self.event = event
    }
}

class event_dispatcher_tests: XCTestCase {

    var sut: EventDispatcher<MockEventHandler>!
    override func setUpWithError() throws {
        sut = EventDispatcher()
    }

    func testThatEventDispatcherDispatchEvent() {
        let mockHandler = MockEventHandler()
        let input = 2
        sut.add(mockHandler)
        sut.dispatch(input)
        XCTAssertEqual(mockHandler.event, input)
    }
}
