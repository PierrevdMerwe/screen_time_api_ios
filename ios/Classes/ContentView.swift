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
        NavigationView {
            FamilyActivityPicker(selection: $model.selectionToDiscourage)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Choose Activities")
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarRole(.navigationStack)
                .toolbarBackground(Color(UIColor.systemBackground), for: .navigationBar)
                .toolbar {
                    // Leading button (X)
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            print("Cancel tapped")  // Debug print
                            model.selectionToDiscourage = FamilyActivitySelection()
                            dismiss()
                        }) {
                            Text("X")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    // Trailing button (Done)
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            print("Done tapped")  // Debug print
                            model.saveSelection(selection: model.selectionToDiscourage)
                            dismiss()
                        }) {
                            Text("Done")
                                .foregroundColor(.blue)
                        }
                    }
                }
        }
        // Force dark mode
        .preferredColorScheme(.dark)
        // Prevent navigation bar from hiding
        .onAppear {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.rootViewController?.navigationController?.setNavigationBarHidden(false, animated: false)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}