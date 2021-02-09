//
//  processes_list_view_model_tests.swift
//  process-monitorTests
//
//  Created by Roman Kopaliani on 05.02.2021.
//

import XCTest
@testable import process_monitor

class processes_list_view_model_tests: XCTestCase {

    var sut: ProcessesListViewModel!

    override func setUpWithError() throws {
        let process = ProcessInfo(pid: 2, ppid: 1, uid:3 , path: "foo/path", bundleId: "foo.bundle", certificateTeamId: "foo.team")
        sut = ProcessesListViewModel(with: [process])
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
