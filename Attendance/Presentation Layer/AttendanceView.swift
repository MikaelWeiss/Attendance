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
//    @State private var isEditMode: EditMode = .inactive
//    I eventually can use this to change the list to a list of textfields that are editable.
    
    var body: some View {
        NavigationView {
            
//MARK: List
            
            List {
                ForEach(people) { person in
                    ZStack {
                        PersonCell(for: person)
                            .onTapGesture {
                                self.toggleAttendance(id: person.id)
                                setPeople(for: self.people)
                            }
                        HStack {
                            NavigationLink(destination: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Destination@*/Text("Destination")/*@END_MENU_TOKEN@*/) {
                                
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 18, weight: .heavy))
                                        .frame(width: 44, height: 44)
                            }
                        }
                    }
                    
                }
                .onDelete { index in
                    self.people.remove(atOffsets: index)
                    setPeople(for: self.people)
                }
                .onMove(perform: { (source, destination) in
                    self.people.move(fromOffsets: source, toOffset: destination)
                    setPeople(for: self.people)
                })
                .buttonStyle(PlainButtonStyle())
                
                TextField("Add Name", text: $addingPerson, onCommit: {
                    if self.addingPerson != "" {
                        self.people.append(Person(self.addingPerson))
                        setPeople(for: self.people)
                    }
                    self.addingPerson = ""
                })
                    .autocapitalization(.words)
                    .accentColor(Color("MyGreen"))
                    .padding(.vertical, 10)
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 600)
                    .foregroundColor(Color.white.opacity(0.0001))
                    .onTapGesture {
                        self.addingPerson = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
            }
//            .environment(\.editMode, self.$isEditMode)
                
//MARK: NavBar Set-Up
                
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
                }
                .foregroundColor(Color("MyGreen")),
                trailing:
                EditButton()
                    .foregroundColor(Color("MyGreen"))
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
        HStack {
            Image(systemName: person.isPresent ? "app.fill" : "app")
                .font(.system(size: 18, weight: .heavy))
                .foregroundColor(Color("MyGreen"))
            
            Text(person.name)
            Rectangle()
                .foregroundColor(Color.white.opacity(0.0001))
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
        if let loadedPeople = try? decoder.decode([Person].self, from: savedPeople) {
            print("Got loaded People")
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

//I have no idea what this is for, but I'm keeping it 'cause I think it was important...🤷‍♂️
//extension View {
//   func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
//        if conditional {
//            return AnyView(content(self))
//        } else {
//            return AnyView(self)
//        }
//    }
//}
