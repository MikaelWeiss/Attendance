//
//  AttendanceOverviewPresenter.swift
//  Attendance
//
//  Created by Mikael Weiss on 6/15/21.
//  Copyright © 2021 MikeStudios. All rights reserved.
//

import Foundation

protocol AttendanceOverviewPresenting {
    func present(people: [AttendanceOverview.Person])
    func presentCopiedToPasteBoard()
    func present(error: AttendanceOverview.ServiceError)
}

extension AttendanceOverview {
    
    struct Presenter: AttendanceOverviewPresenting {
        let viewModel: ViewModel
        
        func present(people: [AttendanceOverview.Person]) {
            viewModel.people = people
        }
        
        func presentCopiedToPasteBoard() {
            viewModel.pasteBoardAlertIsShowing = true
        }
        
        func present(error: ServiceError) {
            viewModel.error = Strings.displayError(for: error)
        }
    }
}
