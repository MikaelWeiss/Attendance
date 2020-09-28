//
//  Date+MonthStringValue.swift
//  Attendance
//
//  Created by Mikael Weiss on 6/18/20.
//  Copyright © 2020 MikeStudios. All rights reserved.
//

import Foundation


extension Date {
    func getMonthStringValue() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: self)
    }
}
