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
        ZStack(alignment: .top) {
            // Main FamilyActivityPicker
            FamilyActivityPicker(selection: $model.selectionToDiscourage)
            
            // Custom overlay for buttons
            HStack {
                Button(action: {
                    print("Cancel tapped")
                    model.selectionToDiscourage = FamilyActivitySelection()
                    dismiss()
                }) {
                    Text("X")
                        .foregroundColor(.blue)
                        .padding()
                }
                
                Spacer()
                
                Button(action: {
                    print("Done tapped")
                    model.saveSelection(selection: model.selectionToDiscourage)
                    dismiss()
                }) {
                    Text("Done")
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}