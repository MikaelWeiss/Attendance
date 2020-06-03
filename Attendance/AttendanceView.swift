//
//  ContentView.swift
//  Attendance
//
//  Created by Mikael Weiss on 6/3/20.
//  Copyright © 2020 MikeStudios. All rights reserved.
//

import SwiftUI

struct AttendanceView: View {
    @State private var people: [Person] = [Person("Mikael"), Person("Collin")]
    @State private var addingPerson = "Person"
    
    var body: some View {
        NavigationView {
            List {
                ForEach(people) { person in
                    PersonCell(for: person)
                        .onTapGesture {
                            self.toggleAttendance(id: person.id)
                        }
                }
                .onDelete { index in
                    self.people.remove(atOffsets: index)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .navigationBarTitle("Attendance")
            .navigationBarItems(trailing:
                HStack {
                    Button(action: {
                        var text = ""
                        for person in self.people {
                            text.append("\(person.name), ")
                        }
                        let pastboard = UIPasteboard.general
                        pastboard.string = text
                    }) {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 18, weight: .bold))
                    }
                    Button(action: {
                        self.people.append(Person("Mikael"))
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .bold))
                    }
                }
                .foregroundColor(Color("MyGreen"))
            )
        }
    }
    
    func toggleAttendance(id: UUID) {
        for index in people.indices {
            if id == people[index].id {
                self.people[index].isPresent.toggle()
            }
        }
    }
}

struct AttendanceView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceView()
    }
}

struct Person: Identifiable {
    let id = UUID()
    var name: String = ""
    var isPresent: Bool = false
    
    init(_ name: String) {
        self.name = name
    }
}


struct PersonCell: View {
    var person: Person
    
    var body: some View {
        HStack {
            Image(systemName: person.isPresent ? "app.fill" : "app")
                .font(.system(size: 18, weight: .heavy))
                .foregroundColor(Color("MyGreen"))
            
            Text(person.name)
            Rectangle()
                .fill(Color.black.opacity(0.01))
        }
    }
    init(for person: Person) {
        self.person = person
    }
}
