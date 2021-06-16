//
//  PersonRepository.swift
//  Attendance
//
//  Created by Mikael Weiss on 6/15/21.
//  Copyright © 2021 MikeStudios. All rights reserved.
//

import Foundation

protocol PersonRepository {
    func allPersons() throws -> [Person]
    func person(with id: UUID) -> Person?
    func add(person: Person) throws
    func removePerson(with id: UUID) throws
    func update(person: Person, with id: UUID) throws
}

class MainPersonRepository: PersonRepository {
    
    enum RepositoryError: Error {
        case fetchFailed
        case updateFailed
    }
    
    private lazy var currentPersons = try? allPersons()
    
    func allPersons() throws -> [Person] {
        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: "SavedPeople") as? Data {
            let decoder = JSONDecoder()
            if var loadedPeople = try? decoder.decode([Person].self, from: savedPeople) {
                loadedPeople.sort { (lhs, rhs) -> Bool in
                    return lhs.name < rhs.name
                }
                return loadedPeople
            }
        }
        throw RepositoryError.fetchFailed
    }
    
    func person(with id: UUID) -> Person? {
        currentPersons?.first(where:  { $0.id == id })
    }
    
    func add(person: Person) throws {
        currentPersons?.append(person)
        try save()
    }
    
    func removePerson(with id: UUID) throws {
        currentPersons?.removeAll(where: { $0.id == id })
        try save()
    }
    
    func update(person: Person, with id: UUID) throws {
        var personUpdated = false
        currentPersons?.enumerated().forEach { index, person in
            if person.id == id {
                currentPersons?[index] = person
                personUpdated = true
            }
        }
        if personUpdated {
            try save()
        } else {
            throw RepositoryError.updateFailed
        }
    }
    
    private func save() throws {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(currentPersons) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "SavedPeople")
        }
    }
}
