//
//  AttendanceOverviewModels.swift
//  Attendance
//
//  Created by Mikael Weiss on 6/15/21.
//  Copyright © 2021 MikeStudios. All rights reserved.
//

import SwiftUI

extension AttendanceOverview {
    
    class ViewModel: ObservableObject {
        @Published var people: [Person] = []
        @Published var pasteBoardAlertIsShowing = false
        @Published var error: ErrorSheet.ViewModel?
    }
    
    enum Strings {
        static let sceneTitle = "Attendance"
        static let addNamePlaceholder = "Add Name"
        
        static func displayError(for error: ServiceError) -> ErrorSheet.ViewModel {
            switch error {
            case .saveFailed:
                return .saveFailed
            }
        }
    }
    
    enum Theme {
        static let copyAttendanceListImage = Image(systemName: "square.and.pencil")
        static let sceneTitle = Strings.sceneTitle
    }
}
