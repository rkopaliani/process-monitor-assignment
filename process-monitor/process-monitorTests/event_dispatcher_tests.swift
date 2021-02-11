//
//  event_dispatcher_tests.swift
//  process-monitorTests
//
//  Created by Roman Kopaliani on 08.02.2021.
//

import XCTest
@testable import process_monitor

protocol MockEventHandlerType: EventHandlerType {}

class MockEventHandler: MockEventHandlerType {
    typealias Event = Int
    var event: Int = 0
    var count: Int = 0
    func handle(_ event: Int) {
        self.event = event
        self.count += 1
    }
}

extension MockEventHandler: Equatable {
    static func == (lhs: MockEventHandler, rhs: MockEventHandler) -> Bool {
        return lhs === rhs
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
    
    func testThatEventDispatcherAddsOnlyOneCopyOfTheSameHandler() {
        let mockHandler = MockEventHandler()
        sut.add(mockHandler)
        sut.add(mockHandler)
        let input = 2
        sut.dispatch(input)
        XCTAssertEqual(mockHandler.count, 1)
    }
    
    func testThatEventDispatcherDoesNotRemoveHandlerTwice() {
        let mockHandler = MockEventHandler()
        let anotherHandler = MockEventHandler()
        sut.add(mockHandler)
        sut.add(anotherHandler)

        sut.delete(mockHandler)
        sut.delete(mockHandler)
        
        let input = 1
        sut.dispatch(input)
        XCTAssertEqual(anotherHandler.event, input)
    }
}
