import SwiftUI
import FamilyControls

struct ContentView: View {
    @StateObject var model = FamilyControlModel.shared
    let completion: (Bool) -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            FamilyActivityPicker(selection: $model.selectionToDiscourage)
                .onChange(of: model.selectionToDiscourage) { newSelection in
                    // Print selections as they happen
                    debugPrint("Current selection changed:")
                    debugPrint("- Apps selected: \(newSelection.applicationTokens.count)")
                    debugPrint("- Categories selected: \(newSelection.categoryTokens.count)")
                }
            
            HStack {
                Button(action: {
                    debugPrint("Cancel tapped")
                    model.selectionToDiscourage = FamilyActivitySelection()
                    // Verify reset
                    debugPrint("After cancel - Selection cleared:")
                    debugPrint("- Apps selected: \(model.selectionToDiscourage.applicationTokens.count)")
                    debugPrint("- Categories selected: \(model.selectionToDiscourage.categoryTokens.count)")
                    completion(false)
                }) {
                    Text("Cancel")
                        .foregroundColor(.blue)
                        .padding()
                }
                
                Spacer()
                
                Button(action: {
                    debugPrint("Done tapped with final selection:")
                    debugPrint("- Apps selected: \(model.selectionToDiscourage.applicationTokens.count)")
                    debugPrint("- Categories selected: \(model.selectionToDiscourage.categoryTokens.count)")
                    debugPrint("- Selected apps: \(model.selectionToDiscourage.applicationTokens)")
                    debugPrint("- Selected categories: \(model.selectionToDiscourage.categoryTokens)")
                    model.saveSelection(selection: model.selectionToDiscourage)
                    completion(true)
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