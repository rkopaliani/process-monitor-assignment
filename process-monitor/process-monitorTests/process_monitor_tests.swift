//
//  process_monitor_tests.swift
//  process-monitorTests
//
//  Created by Roman Kopaliani on 08.02.2021.
//

import XCTest
@testable import process_monitor


class process_monitor_tests: XCTestCase {
    
    var sut: ProcessMonitor!
    var mockWorkspace: MockWorkspace!
    var callback: ProcessMonitorCallback!
    var callbackCount: Int = 0
    
    override func setUpWithError() throws {
        mockWorkspace = MockWorkspace()
        callback = { value in
            self.callbackCount += 1
        }
        let observer = Observer<NSWorkspace>(mockWorkspace)
        sut = ProcessMonitor(observer, callback: callback)
    }

    override func tearDownWithError() throws {
        callbackCount = 0
    }

    func testThatInitialNumberOfProcessesIsCorrect() {
        XCTAssertEqual(sut.processes.count, 1)
    }
 
    func testProcessMonitorCallbackIsCalledWhenObserverUpdates() {
        let initialCount = callbackCount
        mockWorkspace.triggerUpdateWithDifferentApps()
        XCTAssertEqual(callbackCount, initialCount + 1)
        mockWorkspace.mockUpdate = true
        mockWorkspace.triggerUpdateWithDifferentApps()
        XCTAssertEqual(callbackCount, initialCount + 2)
    }
    
    func testThatProcessMonitorDoesNotTriggerUpdateWhenProcessesAreTheSame() {
        let initialCount = callbackCount
        mockWorkspace.triggerUpdateWithIdenticalApps()
        XCTAssertEqual(callbackCount, initialCount)
        mockWorkspace.triggerUpdateWithIdenticalApps()
        XCTAssertEqual(callbackCount, initialCount)
    }
    
    func testThatProcessMonitorUpdatesProcessSetWhenItShould() {
        mockWorkspace.triggerUpdateWithIdenticalApps()
        let input = sut.processes
        XCTAssertEqual(input, sut.processes)
        mockWorkspace.triggerUpdateWithIdenticalApps()
        XCTAssertEqual(input, sut.processes)
        mockWorkspace.triggerUpdateWithDifferentApps()
        XCTAssertNotEqual(input, sut.processes)
    }
}
