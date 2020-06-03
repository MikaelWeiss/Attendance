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
    @State private var addingPerson = ""
    @State private var keyboardIsActive = false
    
    var body: some View {
        NavigationView {
//MARK: - List
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
                
                TextField("Add Name", text: self.$addingPerson, onCommit: {
                    if self.addingPerson != "" {
                        self.people.append(Person(self.addingPerson))
                    }
                    self.addingPerson = ""
                })
                    .autocapitalization(.words)
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 600)
                    .foregroundColor(Color.white.opacity(0.0001))
            }
//            .onTapGesture {
//                print(self.keyboardIsActive)
//                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                self.addingPerson = ""
//                self.keyboardIsActive = false
//            }
//MARK: - NavBar Set-Up
            .navigationBarTitle("Attendance")
            .navigationBarItems(trailing:
                Button(action: {
                    var text = ""
                    for person in self.people {
                        if person.isPresent {
                            text.append("\(person.name), ")
                        }
                    }
                    let pastboard = UIPasteboard.general
                    pastboard.string = text
                }) {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 18, weight: .bold))
                }
                .foregroundColor(Color("MyGreen"))
            )
        }
    }
//MARK: - Functions
    
    func toggleAttendance(id: UUID) {
        for index in people.indices {
            if id == people[index].id {
                self.people[index].isPresent.toggle()
            }
        }
    }
}
//MARK: - Preview

struct AttendanceView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceView()
    }
}

//MARK: - SubViews
struct PersonCell: View {
    var person: Person
    
    var body: some View {
        HStack {
            Image(systemName: person.isPresent ? "app.fill" : "app")
                .font(.system(size: 18, weight: .heavy))
                .foregroundColor(Color("MyGreen"))
            
            Text(person.name)
            Rectangle()
                .foregroundColor(Color.white.opacity(0.0001))
        }
    }
    init(for person: Person) {
        self.person = person
    }
}

//MARK: - Structures
struct Person: Identifiable, Codable {
    let id = UUID()
    var name: String = ""
    var isPresent: Bool = false
    
    init(_ name: String) {
        self.name = name
    }
}

struct People: Codable {
    var list: [Person]
}


//MARK: - Functions

func setPeople(people: [Person]) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(people) {
        let defaults = UserDefaults.standard
        defaults.set(encoded, forKey: "SavedPeople")
    }
}

func getPeople() -> [Person] {
    let defaults = UserDefaults.standard
    if let savedPeople = defaults.object(forKey: "SavedPeople") as? Data {
        let decoder = JSONDecoder()
        if let loadedPeople = try? decoder.decode(People.self, from: savedPeople) {
            var people: [Person] = []
            for person in loadedPeople.list {
                people.append(person)
            }
            return people
        }
    }
    return [Person("Johny Appleseed")]
}

//MARK: - Extentions

//extension View {
//   func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
//        if conditional {
//            return AnyView(content(self))
//        } else {
//            return AnyView(self)
//        }
//    }
//}
