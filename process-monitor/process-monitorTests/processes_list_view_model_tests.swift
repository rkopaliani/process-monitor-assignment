//
//  processes_list_view_model_tests.swift
//  process-monitorTests
//
//  Created by Roman Kopaliani on 05.02.2021.
//

import XCTest
@testable import process_monitor

class MockDisplayEventDispatch {
    var selected: ProcessData?
    func dispatch(_ event: ProcessDisplayEvent) {
        switch event {
        case .didSelect(let process):
            selected = process
        }
    }
}

class processes_list_view_model_tests: XCTestCase {

    var sut: ProcessesListViewModel!
    var observer: MonitorEventObserver!
    var dispatcher: MockDisplayEventDispatch!
    
    override func setUpWithError() throws {
        let foo = ProcessData(pid: 2, ppid: 1, uid:0 , path: URL(fileURLWithPath: "Library/foo/path"), bundleId: "foo.bundle")
        let bar = ProcessData(pid: 3, ppid: 1, uid:501 , path: URL(fileURLWithPath: "/Library/bar/path"), bundleId: "bar.bundle")

        observer = MonitorEventObserver()
        dispatcher = MockDisplayEventDispatch()
        sut = ProcessesListViewModel(with: Set([bar, foo]),
                                     monitorObserver: observer,
                                     displayDispatch: dispatcher.dispatch)
    }

    func testThatViewModelInitialProcessesAreSorted() {
        XCTAssertEqual(sut.sortedProcesses.count, 2)
        XCTAssertEqual(sut.sortedProcesses.first!.pid, 2)
    }
    
    func testThatDispatcherPostEventOnDidSelect() {
        let process = sut.sortedProcesses.last!
        sut.didSelect(process)
        XCTAssertEqual(dispatcher.selected!, process)
    }
}
