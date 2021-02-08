//
//  ProcessesListViewModel.swift
//  process-monitor
//
//  Created by Roman Kopaliani on 05.02.2021.
//

import Foundation

final class ProcessesListViewModel {
    
    private(set) var processes:Set<Process>
    
    init() {
        self.processes = Set()
    }
}
