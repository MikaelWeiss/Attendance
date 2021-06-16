//
//  AttendanceOverviewService.swift
//  Attendance
//
//  Created by Mikael Weiss on 6/15/21.
//  Copyright © 2021 MikeStudios. All rights reserved.
//

import Foundation

protocol AttendanceOverviewService {
    func fetchPeople() throws -> [AttendanceOverview.Person]
    func togglePersonIsPresent(with id: UUID)
    func removePerson(with id: UUID)
    func addPerson(_ name: String)
    func copyToPasteboard(callback: () -> Void)
}

extension AttendanceOverview {
    
    enum ServiceError: Swift.Error {
        case saveFailed
        case fetchFailed
        case updateFailed
    }
    
    struct Person {
        let id: UUID
        let name: String
        let isPresent: Bool
    }
    
    class Service: AttendanceOverviewService {
        
        let personUpdater: PersonRepository
        
        init(personUpdater: MainPersonRepository) {
            self.personUpdater = personUpdater
        }
        
        func fetchPeople() throws -> [Person] {
            do {
                let people = try personUpdater.allPersons()
                return people.map { Person(id: $0.id, name: $0.name, isPresent: $0.isPresent) }
            } catch {
                throw ServiceError.fetchFailed
            }
        }
        
        func togglePersonIsPresent(with id: UUID) throws {
            guard var person = personUpdater.person(with: id) else { ServiceError.updateFailed }
            person.isPresent.toggle()
            try personUpdater.update(person: person, with: id)
        }
        
        func removePerson(with id: UUID) {
            
        }
        
        func addPerson(_ name: String) {
            
        }
        
        func copyToPasteboard(callback: () -> Void) {
            
        }
    }
    
    class PreviewService: AttendanceOverviewService {
        func fetchPeople() throws -> [Person] {
            [Person(id: UUID(), name: "Johny Appleseed", isPresent: false)]
        }
        
        func togglePersonIsPresent(with id: UUID) {
            
        }
        
        func removePerson(with id: UUID) {
            
        }
        
        func addPerson(_ name: String) {
            
        }
        
        func copyToPasteboard(callback: () -> Void) {
            
        }
    }
}
