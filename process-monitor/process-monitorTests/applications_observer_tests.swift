//
//  applications_observer_tests.swift
//  process-monitorTests
//
//  Created by Roman Kopaliani on 08.02.2021.
//

import XCTest
@testable import process_monitor

class MockWorkspace: NSWorkspace {
    var mockUpdate: Bool = false
    
    private var _runingApps = [NSRunningApplication()]
    func triggerUpdate() {
        self.willChangeValue(forKey: "runningApplications")
        if mockUpdate {
            _runingApps = [NSRunningApplication(), NSRunningApplication()]
        } else {
            _runingApps = [NSRunningApplication(), NSRunningApplication(), NSRunningApplication()]
        }
        
        self.didChangeValue(forKey: "runningApplications")
    }
    
    override var runningApplications: [NSRunningApplication] {
        return _runingApps
    }
}

class applications_observer_tests: XCTestCase {

    var sut: Observer<MockWorkspace>!
    var mockWorkspace: MockWorkspace!
    
    override func setUpWithError() throws {
        mockWorkspace = MockWorkspace()
        sut = Observer(mockWorkspace)
    }
    
    func testThatApplicationObserverFiresDelegateCallbackOnUpdate() {
        let expectation = XCTestExpectation(description: "Callback on change is called")
        sut.subscribe(\.runningApplications) { value in
            expectation.fulfill()
        }
        mockWorkspace.triggerUpdate()
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testThatApplicationObserverForwardsUpdate() {
        let initialValueExpectation = XCTestExpectation(description: "Return 1 app on subsribe")
        let updatedValueExpectation = XCTestExpectation(description: "Return 3 app on first update")
        var didUpdate = false
        sut.subscribe(\.runningApplications) { value in
            if didUpdate {
                XCTAssertEqual(value.count, 3)
                updatedValueExpectation.fulfill()
            } else {
                XCTAssertEqual(value.count, 1)
                initialValueExpectation.fulfill()
            }
        }
        
        didUpdate = true
        mockWorkspace.triggerUpdate()
        wait(for: [initialValueExpectation, updatedValueExpectation], timeout: 0.2)
    }
}
