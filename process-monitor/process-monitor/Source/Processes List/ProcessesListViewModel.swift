//
//  ProcessesListViewModel.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 05.02.2021.
//

import Foundation

final class ProcessesListViewModel {

    private let monitor: ProcessMonitor
    init(with monitor: ProcessMonitor) {
        self.monitor = monitor
    }
}
