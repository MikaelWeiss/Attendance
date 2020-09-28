//
//  PersonOverview.swift
//  Attendance
//
//  Created by Mikael Weiss on 6/13/20.
//  Copyright © 2020 MikeStudios. All rights reserved.
//

import SwiftUI

class MonthData: ObservableObject {
    @Published var currentMonth = Date()
    
}

struct PersonOverview: View {
    @ObservedObject var data = MonthData()
    @Binding var name: String
    
    var body: some View {
        ScrollView {
            MonthNavBar(data: data)
            GridStack(rows: 5, columns: 7) { row, col in
                Button(action: {
                    
                }) {
                    Image(systemName: "circle")
                        .font(.system(size: 27, weight: .semibold))
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color("MyGreen"))}
            }
        }
    }
}

struct PersonOverview_Previews: PreviewProvider {
    static var previews: some View {
        PersonOverview(name: .constant("Mikael")).previewLayout(.sizeThatFits)
    }
}

struct MonthNavBar: View {
    @ObservedObject var data: MonthData
    
    var body: some View {
        HStack {
            Button(action: {
                
            }) {
                Image(systemName: "chevron.left.circle.fill")
                    .resizable()
                    .foregroundColor(Color("MyGreen"))
                    .frame(width: 25, height: 25)
            }
            .frame(maxWidth: .infinity)
            
            Text("Month")
                .font(.system(.title, design: .rounded))
            
            Button(action: {
                
            }) {
                Image(systemName: "chevron.right.circle.fill")
                    .resizable()
                    .foregroundColor(Color("MyGreen"))
                    .frame(width: 25, height: 25)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
//
//struct GridView: View {
//    @Binding var numbers: [Int]
//    
//    VStack {
//        ForEach(0...5, id: \.self) { row in
//            HStack {
//                ForEach(0...7, id: \.self) { column in
//                    
//                }
//            }
//        }
//    }
//}

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    
    var body: some View {
        VStack {
            ForEach(0 ..< rows) { row in
                HStack {
                    ForEach(0 ..< self.columns) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }
}

extension Date {
    func getStartDateOfMonthAndNumberOfDaysInMonth() -> (Date, Int) {
        let calendar = Calendar.current
        
        let interval = calendar.dateInterval(of: .month, for: self)!
        
        let startOfMonth = interval.start
        let range = calendar.range(of: .day, in: .month, for: self)!
        let numOfDays = range.count + 1
        
        return (startOfMonth, numOfDays)
        
    }
}
