//
//  processes_list_view_model_tests.swift
//  process-monitorTests
//
//  Created by Roman Kopaliani on 05.02.2021.
//

import XCTest
@testable import process_monitor

class MockProcessesListViewModelDelegate: ProcessesListViewModelDelegate {
    var added: [ProcessData]?
    var removed: [ProcessData]?
    
    func viewModel(_ viewModel: ProcessesListViewModel,
                   willAdd added: [ProcessData],
                   willRemove removed: [ProcessData]) {
        self.added = added
        self.removed = removed
    }
}

class processes_list_view_model_tests: XCTestCase {

    var sut: ProcessesListViewModel!
    var observer: ProcessMonitorEventObserver!
    
    override func setUpWithError() throws {
        let foo = ProcessData(pid: 2, ppid: 1, uid:0 , path: URL(fileURLWithPath: "Library/foo/path"), bundleId: "foo.bundle")
        let bar = ProcessData(pid: 3, ppid: 1, uid:501 , path: URL(fileURLWithPath: "/Library/bar/path"), bundleId: "bar.bundle")

        observer = ProcessMonitorEventObserver()
        sut = ProcessesListViewModel(with: Set([bar, foo]), monitorObserver: observer)
    }

    func testThatViewModelInitialProcessesAreSorted() {
        XCTAssertEqual(sut.sortedProcesses.count, 2)
        XCTAssertEqual(sut.sortedProcesses.first!.pid, 2)
    }
    
    func testThatDelegateReceiveProperValuesFromViewModelOnUpdate() {
        let delegate = MockProcessesListViewModelDelegate()
        sut.delegate = delegate
        
        let added = ProcessData(pid: 4, ppid: 22, uid: 0, path: URL(fileURLWithPath:"/baz/path"), bundleId: "baz.bundle")
        let removed = ProcessData(pid: 3, ppid: 1, uid:501 , path: URL(fileURLWithPath:"/bar/path"), bundleId: "bar.bundle")
        observer.handle(.update(added: [added], removed: [removed]))
        
        XCTAssertEqual(sut.sortedProcesses.count, 3)
        XCTAssertEqual(delegate.added!, [added])
        XCTAssertEqual(delegate.removed!, [removed])
    }
}
