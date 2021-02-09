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
    func applicationsObserver(_ observer: ApplicationsObserver, didObserve update: [NSRunningApplication]) {
        didReceiveUpdate = true
        applications = update
    }
}

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
        XCTAssertTrue(mockDelegate.didReceiveUpdate)
    }
    
    func testThatApplicationObserverForwardsUpdate() {
        let initialValue = mockDelegate.applications
        XCTAssertEqual(initialValue.count, 1)
        
        mockWorkspace.triggerUpdate()
        let firstUpdate = mockDelegate.applications
        XCTAssertEqual(firstUpdate.count, 3)
        
        mockWorkspace.mockUpdate = true
        mockWorkspace.triggerUpdate()
        XCTAssertEqual(mockDelegate.applications.count, 2)
    }
}
