//
//  AttendanceOverviewScene.swift
//  Attendance
//
//  Created by Mikael Weiss on 6/15/21.
//  Copyright © 2021 MikeStudios. All rights reserved.
//

import SwiftUI

enum AttendanceOverview {
    
    // MARK: - Build scene
    
    struct Scene {
        
        func view(preview: Bool = false, isPresented: Binding<Bool>) -> some View {
            let service: AttendanceOverviewService = preview ? PreviewService() : Service()
            let presenter = Presenter(viewModel: ViewModel())
            let interactor = Interactor(service: service, presenter: presenter)
            interactor.fetchPeople()
            let view = ContentView(viewModel: presenter.viewModel, interactor: interactor)
            return view
        }
    }
}
