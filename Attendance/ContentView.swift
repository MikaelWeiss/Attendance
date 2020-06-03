//
//  ContentView.swift
//  Attendance
//
//  Created by Mikael Weiss on 6/3/20.
//  Copyright © 2020 MikeStudios. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var people: PeopleList
    @State private var addingPerson = "Person"
    
    var body: some View {
        NavigationView {
            List {
                ForEach(people.list.indices) { index in
                    PersonCell().environmentObject(self.people.list[index])
                }
                .onDelete { index in
                    self.people.list.remove(atOffsets: index)
                }
            }
            .navigationBarTitle("Attendance")
            .navigationBarItems(trailing:
                HStack {
                    Button(action: {
                        self.people.list.append(Person("Mikael"))
                    }) {
                        Image(systemName: "plus")
                    }
                    Button(action: {
                        var text = ""
                        for person in self.people.list {
                            text.append("\(person.name), ")
                        }
                        let pastboard = UIPasteboard.general
                        pastboard.string = text
                    }) {
                        Text("Save")
                    }
                    EditButton()
                }
                .foregroundColor(Color("MyGreen"))
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject((PeopleList([Person("Mikael"), Person("Collin")])))
    }
}

class PeopleList: ObservableObject {
    @Published var list: [Person]
    
    init(_ list: [Person]) {
        self.list = list
    }
}

class Person: Identifiable, ObservableObject {
    let id = UUID()
    var name: String = ""
    var isPresent: Bool = false
    
    init(_ name: String) {
        self.name = name
    }
}

struct PersonCell: View {
    @EnvironmentObject var person: Person
    
    var body: some View {
        HStack {
            Button(action: {
                self.person.isPresent.toggle()
            }) {
                ZStack {
                    Image(systemName: person.isPresent ? "app.fill" : "app")
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundColor(Color("MyGreen"))
                }
            }
            Text(person.name)
            Spacer()
        }
    }
}
