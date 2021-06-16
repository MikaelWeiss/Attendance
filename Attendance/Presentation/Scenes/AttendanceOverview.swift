//
//  ContentView.swift
//  Attendance
//
//  Created by Mikael Weiss on 6/3/20.
//  Copyright © 2020 MikeStudios. All rights reserved.
//

import SwiftUI

//MARK: - Attendance View


struct AttendanceView: View {
    //MARK: Variables
    @State private var people: [Person] = getPeople()
    @State private var addingPerson = ""
    @State private var showingPasteboardAlert = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(people) { person in
                    NavigationLink(destination: Text("Sup")) {
                        PersonCell(for: person)
                            .onTapGesture {
                                self.toggleAttendance(id: person.id)
                                setPeople(for: self.people)
                            }
                    }
                }
                .onDelete { index in
                    self.people.remove(atOffsets: index)
                    setPeople(for: self.people)
                }
                
                TextField("Add Name", text: $addingPerson, onCommit: {
                    if self.addingPerson != "" {
                        self.people.append(Person(self.addingPerson))
                        setPeople(for: self.people)
                        self.people = getPeople()
                    }
                    self.addingPerson = ""
                })
                    .autocapitalization(.words)
                    .padding(.vertical, 10)
            }
            .navigationBarTitle("Attendance")
            .navigationBarItems(leading:
                                    Button(action: {
                var names = [String]()
                for person in self.people {
                    if person.isPresent {
                        names.append(person.name)
                    }
                }
                
                let joinedAndFilteredNamesNames = names.filter({ $0 != ""}).joined(separator: ", ")
                let nameOfMonth = Date().getMonthStringValue()
                let dayOfMonth = self.getOrdinalNumber(Calendar.current.component(.day, from: Date()))
                let text = "\(nameOfMonth) \(String(dayOfMonth)):\n\(joinedAndFilteredNamesNames)."
                let pastboard = UIPasteboard.general
                pastboard.string = text
                self.showingPasteboardAlert = true
            }) {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 18, weight: .bold))
                    .imageScale(.medium)
                    .padding(.all, 10)
            },
                                
                                trailing:
                                    EditButton()
                                    .padding(.all, 2)
            )
            .alert(isPresented: $showingPasteboardAlert) {
                Alert(title: Text("Copied"), message: Text("List was copied to the clipboard"), dismissButton: .default(Text("OK")))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    //MARK: Functions
    
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
        AttendanceView().colorScheme(.dark)
    }
}

//MARK: - SubViews
struct PersonCell: View {
    var person: Person
    
    var body: some View {
        HStack (alignment: .center) {
            Image(systemName: person.isPresent ? "app.fill" : "app")
                .font(.system(size: 18, weight: .heavy))
                .foregroundColor(Color.appAccentColor)
            
            Text(person.name)
                .font(.system(size: 15, weight: .heavy))
                .foregroundColor(Color.appAccentColor)
        }
        .padding(.vertical, 10)
    }
    init(for person: Person) {
        self.person = person
    }
}

//MARK: - Functions

func setPeople(for people: [Person]) {
    print("Saving")
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(people) {
        let defaults = UserDefaults.standard
        defaults.set(encoded, forKey: "SavedPeople")
        print("Saved")
    }
}

func getPeople() -> [Person] {
    print("getting people")
    let defaults = UserDefaults.standard
    if let savedPeople = defaults.object(forKey: "SavedPeople") as? Data {
        print("Got Saved People")
        let decoder = JSONDecoder()
        if var loadedPeople = try? decoder.decode([Person].self, from: savedPeople) {
            print("Got loaded People")
            loadedPeople.sort { (lhs, rhs) -> Bool in
                return lhs.name < rhs.name
            }
            return loadedPeople
        }
    }
    return [Person("Johny Appleseed")]
}

//MARK: - Extentions

extension AttendanceView {
    func getOrdinalNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(from: NSNumber(value: number))!
    }
}
