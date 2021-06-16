//
//  AttendanceOverviewView.swift
//  Attendance
//
//  Created by Mikael Weiss on 6/15/21.
//  Copyright © 2021 MikeStudios. All rights reserved.
//

import SwiftUI

extension AttendanceOverview {
    
    struct ContentView: View {
        typealias Theme = EditDataPoint.Theme
        @ObservedObject var viewModel: ViewModel
        let interactor: AttendanceOverviewInteracting
        
        var text: Binding<String> {
            Binding(get: { viewModel.text }, set: interactor.updateText)
        }
        
        var body: some View {
            ScrollView {
                TextField("Hallo", text: text)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(lineWidth: 2)
                            .fill(Theme.tintColor)
                    )
                    .padding()
            }
            .navigationTitle(Theme.sceneTitle)
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
            .navigationBarBackButtonHidden(true)
            .accentColor(Theme.tintColor)
            .errorSheet($viewModel.error)
        }
        
        var cancelButton: some View {
            Button(action: interactor.dismiss) {
                Text(Theme.backButtonTitle)
                    .accentColor(Theme.tintColor)
            }
        }
        
        var saveButton: some View {
            Button(action: interactor.save) {
                Text(Theme.saveButtonTitle)
                    .accentColor(Theme.tintColor)
            }.disabled(!viewModel.canSave)
        }
    }
}

// MARK: - Previews

struct AttendanceOverview_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AttendanceOverview.Scene().view(preview: true, isPresented: .constant(true))
        }
    }
}
