//
//  applications_observer_tests.swift
//  process-monitorTests
//
//  Created by Roman Kopaliani on 08.02.2021.
//

import XCTest
@testable import process_monitor

class MockWorkspace: NSWorkspace {
    var simulateUpdate: Bool = false
    
    private var _runingApps: [NSRunningApplication] = [NSRunningApplication()]
    func triggerUpdateWithIdenticalApps() {
        self.willChangeValue(forKey: "runningApplications")
        if !simulateUpdate {
            _runingApps = [NSRunningApplication(), NSRunningApplication()]
        } else {
            _runingApps = [NSRunningApplication(), NSRunningApplication(), NSRunningApplication()]
        }
        
        self.didChangeValue(forKey: "runningApplications")
    }
    
    
    func triggerUpdateWithDifferentApps() {
        self.willChangeValue(forKey: "runningApplications")
        if !simulateUpdate {
            _runingApps = [NSWorkspace.shared.runningApplications.first!]
        } else {
            _runingApps = [NSWorkspace.shared.runningApplications.first!,
                           NSWorkspace.shared.runningApplications.last!]
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
        sut.subscribe(\.runningApplications) { added, removed in
            expectation.fulfill()
        }
        mockWorkspace.triggerUpdateWithIdenticalApps()
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testThatApplicationObserverForwardsUpdate() {
        let initialValueExpectation = XCTestExpectation(description: "Return 1 app on subsribe")
        let updatedValueExpectation = XCTestExpectation(description: "Return 2 app on first update")
        var didUpdate = false
        sut.subscribe(\.runningApplications) { added, removed  in
            
            if didUpdate {
                XCTAssertEqual(added!.count, 2)
                updatedValueExpectation.fulfill()
            } else {
                XCTAssertEqual(added!.count, 1)
                initialValueExpectation.fulfill()
            }
        }
        
        didUpdate = true
        mockWorkspace.triggerUpdateWithIdenticalApps()
        wait(for: [initialValueExpectation, updatedValueExpectation], timeout: 0.2)
    }
}
