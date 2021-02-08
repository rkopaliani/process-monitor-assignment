//
//  process_monitor_tests.swift
//  process-monitorTests
//
//  Created by Roman Kopaliani on 08.02.2021.
//

import XCTest
@testable import process_monitor

class MockDelegate: NSObject, ProcessMonitorDelegate {
    
}

class process_monitor_tests: XCTestCase {
    
    let sut: ProcessMonitor = ProcessMonitor()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testThatAddMonitorDoesNotAddTheSameDelegateTwice() {
        let delegate = MockDelegate()
        sut.addDelegate(delegate)
        sut.addDelegate(delegate)
        XCTAssertEqual(sut.delegates.count, 1)
    }
    
    func testThatRemoveMonitorDoesNotRemoveEveAnythingIfTheSameDelegateRemovedTwice() {
        let delegate = MockDelegate()
        sut.addDelegate(delegate)
        let delegate2 = MockDelegate()
        sut.addDelegate(delegate2)
        
        sut.removeDelegate(delegate)
        sut.removeDelegate(delegate)
        
        XCTAssertEqual(sut.delegates.count, 1)
    }
}
