//
//  CalendarView.swift
//  Attendance
//
//  Created by Mikael Weiss on 6/18/20.
//  Copyright © 2020 MikeStudios. All rights reserved.
//

import SwiftUI

struct CalendarView: View {
    @Environment(\.calendar) var calendar
    let week = Date().addingTimeInterval(-1209600)
    
    
    private var days: [Day] {
        var tempDays: [Day] = []
        
        guard
            let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week)
            else { return [] }
        let daysInterval = calendar.generateDates(
            inside: weekInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
        for day in daysInterval {
            tempDays.append(Day(date: day))
        }
        return tempDays
    }
    
    var body: some View {
        HStack {
            ForEach(days) { day in
                HStack {
                    if self.calendar.isDate(self.week, equalTo: day.date, toGranularity: .month) {
                        Button(action: {
                            day.isSelected.toggle()
                            print("Day: \(day.date) was toggled")
                        }) {
                            Image(systemName: day.isSelected ? "cirlcle.fill" : "circle")
                                .frame(width: 30, height: 30)
                                .font(.system(size: 30, weight: .semibold))
                                .foregroundColor(Color.appTintColor)
                                .overlay(
                                    Text("\(self.calendar.component(.day, from: day.date))")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(day.isSelected ? Color(.systemBackground) : Color.appTintColor)
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        Circle()
                            .frame(width: 30, height: 30)
                            .hidden()
                    }
                }
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}




class Day: ObservableObject, Identifiable {
    var id = UUID()
    var date: Date
    var isSelected = false {
        willSet {
            self.objectWillChange.send()
        }
    }
    
    init(date: Date) {
        self.date = date
    }
}

class Days: ObservableObject {
    @Published var days: [Day]
    
    init(days: [Day]) {
        self.days = days
    }
}
