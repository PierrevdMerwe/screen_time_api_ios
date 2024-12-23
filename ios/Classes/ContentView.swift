//
//  ContentView.swift
//  screen_time_api_ios
//

import SwiftUI
import FamilyControls

struct ContentView: View {
    @StateObject var model = FamilyControlModel.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        FamilyActivityPicker(selection: $model.selectionToDiscourage)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        model.selectionToDiscourage = FamilyActivitySelection()
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // Explicitly save the current selection
                        model.saveSelection(selection: model.selectionToDiscourage)
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}