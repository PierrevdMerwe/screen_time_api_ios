import SwiftUI
import FamilyControls

struct ContentView: View {
    @StateObject var model = FamilyControlModel.shared
    let completion: (Bool) -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            FamilyActivityPicker(selection: $model.selectionToDiscourage)
            
            HStack {
                Button(action: {
                    debugPrint("Cancel tapped")
                    model.selectionToDiscourage = FamilyActivitySelection()
                    completion(false)
                }) {
                    Text("X")
                        .foregroundColor(.blue)
                        .padding()
                }
                
                Spacer()
                
                Button(action: {
                    debugPrint("Done tapped")
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