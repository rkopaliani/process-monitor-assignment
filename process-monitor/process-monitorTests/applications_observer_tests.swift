//
//  applications_observer_tests.swift
//  process-monitorTests
//
//  Created by Roman Kopaliani on 08.02.2021.
//

import XCTest
@testable import process_monitor

class MockApplicationsObserverDelegate {
    var didReceiveUpdate: Bool = false
    var applications: [NSRunningApplication] = []
}

extension MockApplicationsObserverDelegate: ApplicationsObserverDelegate {
    func applicationsObserver(_ observer: ApplicationsObserver, didObserveUpdate update: [NSRunningApplication]) {
        didReceiveUpdate = true
        applications = update
    }
}

class MockWorkspace: NSWorkspace {
    var mockUpdate: Bool = false
    
    private var _runingApps = [NSRunningApplication()]
    func triggerUpdate() {
        self.willChangeValue(forKey: "runningApplications")
        _runingApps = [NSRunningApplication(), NSRunningApplication()]
        self.didChangeValue(forKey: "runningApplications")
    }
    
    override var runningApplications: [NSRunningApplication] {
        return _runingApps
    }
}

class applications_observer_tests: XCTestCase {

    var sut: ApplicationsObserver!
    var mockDelegate: MockApplicationsObserverDelegate!
    var mockWorkspace: MockWorkspace!
    
    override func setUpWithError() throws {
        mockDelegate = MockApplicationsObserverDelegate()
        mockWorkspace = MockWorkspace()
        sut = ApplicationsObserver(with: mockDelegate, workspace: mockWorkspace)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testThatApplicationObserverFiresDelegateCallbackOnUpdate() {
        mockWorkspace.triggerUpdate()
        let output = mockDelegate.applications
        XCTAssertNotEqual(output.count, 0)
        XCTAssertEqual(output.count, 2)
    }
    
}
