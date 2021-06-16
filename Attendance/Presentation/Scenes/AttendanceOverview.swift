//
//  ContentView.swift
//  Attendance
//
//  Created by Mikael Weiss on 6/3/20.
//  Copyright © 2020 MikeStudios. All rights reserved.
//

import SwiftUI

enum AttendanceView {
    
    struct Interface {
        let viewModel = ViewModel()
        
        func fetchPeople() {
            let defaults = UserDefaults.standard
            if let savedPeople = defaults.object(forKey: "SavedPeople") as? Data {
                let decoder = JSONDecoder()
                if var loadedPeople = try? decoder.decode([Person].self, from: savedPeople) {
                    loadedPeople.sort { (lhs, rhs) -> Bool in
                        return lhs.name < rhs.name
                    }
                    viewModel.people = loadedPeople
                }
            }
            viewModel.people = [Person("Johny Appleseed")]
        }
        
        func togglePersonIsPresent(for id: UUID) {
            for index in viewModel.people.indices {
                if id == viewModel.people[index].id {
                    viewModel.people[index].isPresent.toggle()
                }
            }
            save()
        }
        
        func removePerson(atOffsets: IndexSet) {
            viewModel.people.remove(atOffsets: atOffsets)
            save()
        }
        
        func addPerson(_ name: String) {
            if name != "" {
                viewModel.people.append(Person(name))
                save()
            }
        }
        
        func copyToPasteboard() {
            var names = [String]()
            for person in viewModel.people {
                if person.isPresent {
                    names.append(person.name)
                }
            }
            
            let joinedAndFilteredNamesNames = names.filter({ $0 != ""}).joined(separator: ", ")
            let nameOfMonth = Date().getMonthStringValue()
            let dayOfMonth = getOrdinalNumber(Calendar.current.component(.day, from: Date()))
            let text = "\(nameOfMonth) \(String(dayOfMonth)):\n\(joinedAndFilteredNamesNames)."
            let pastboard = UIPasteboard.general
            pastboard.string = text
            viewModel.showingPasteboardAlert = true
        }
        
        // MARK: - Helpers
        
        private func getOrdinalNumber(_ number: Int) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .ordinal
            return formatter.string(from: NSNumber(value: number))!
        }
        
        private func save() {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(viewModel.people) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "SavedPeople")
            }
        }
    }
    
    struct ContentView: View {
        let interface = Interface()
        @ObservedObject var viewModel = ViewModel()
        @State private var addPersonTextFieldValue = ""
        
        var body: some View {
            NavigationView {
                List {
                    ForEach(viewModel.people) { person in
                        NavigationLink(destination: Text("Sup")) {
                            PersonCell(person: person)
                                .onTapGesture {
                                    interface.togglePersonIsPresent(for: person.id)
                                }
                        }
                    }
                    .onDelete { index in
                        interface.removePerson(atOffsets: index)
                    }
                    
                    TextField(Strings.addNamePlaceholder, text: $addPersonTextFieldValue, onCommit: {
                        interface.addPerson(addPersonTextFieldValue)
                    })
                        .autocapitalization(.words)
                        .accentColor(.appTintColor)
                        .padding(.vertical, 10)
                }
                .onAppear(perform: interface.fetchPeople)
                .navigationBarTitle(Strings.sceneTitle)
                .navigationBarItems(leading: leadingBarButtonItem, trailing: trailingBarButtonItem)
                .alert(isPresented: $viewModel.showingPasteboardAlert) {
                    Alert(title: Text("Copied"), message: Text("List was copied to the clipboard"), dismissButton: .default(Text("OK")))
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        
        var leadingBarButtonItem: some View {
            Button(action: {
                interface.copyToPasteboard()
            }, label: {
                Theme.copyAttendanceListImage
                    .font(.system(size: 18, weight: .bold))
                    .imageScale(.medium)
                    .padding(.all, 10)
            })
        }
        
        var trailingBarButtonItem: some View {
            EditButton()
                .padding(.all, 2)
        }
    }
    
    struct PersonCell: View {
        var person: Person
        
        var body: some View {
            HStack {
                Image(systemName: person.isPresent ? "app.fill" : "app")
                    .font(.system(size: 18, weight: .heavy))
                
                Text(person.name)
                    .font(.system(size: 15, weight: .heavy))
            }
            .padding(.vertical, 10)
        }
    }
}

//MARK: - Preview

struct AttendanceView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceView.ContentView()
            .colorScheme(.dark)
    }
}
