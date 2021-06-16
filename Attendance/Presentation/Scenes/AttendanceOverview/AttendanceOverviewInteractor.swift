//
//  AttendanceOverviewInteractor.swift
//  Attendance
//
//  Created by Mikael Weiss on 6/15/21.
//  Copyright © 2021 MikeStudios. All rights reserved.
//

import Foundation

protocol AttendanceOverviewInteracting {
    func fetchPeople()
    func togglePersonIsPresent(for id: UUID)
    func removePerson(with id: UUID)
    func addPerson(_ name: String)
    func copyToPasteboard()
}

extension AttendanceOverview {
    
    struct Interactor: AttendanceOverviewInteracting {
        let service: AttendanceOverviewService
        let presenter: AttendanceOverviewPresenting
        
        func fetchPeople() {
            let people = service.fetchPeople()
            presenter.present(people: people)
        }
        
        func togglePersonIsPresent(for id: UUID) {
            service.togglePersonIsPresent(with: id)
            updatePeople()
        }
        
        func removePerson(with id: UUID) {
            service.removePerson(with: id)
            updatePeople()
        }
        
        func addPerson(_ name: String) {
            service.addPerson(name)
            updatePeople()
        }
        
        private func updatePeople() {
            fetchPeople()
        }
        
        func copyToPasteboard() {
            service.copyToPasteboard {
                presenter.presentCopiedToPasteBoard()
            }
        }
    }
}
