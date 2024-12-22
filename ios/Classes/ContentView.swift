//
//  ContentView.swift
//  screen_time_api_ios
//

import SwiftUI
import FamilyControls

struct ActivityItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let isCategory: Bool
    let applicationToken: ApplicationToken?
    let categoryToken: CategoryToken?
    var isSelected: Bool
    
    // Initialize for an app
    init(application: ApplicationToken, isSelected: Bool = false) {
        self.id = UUID()
        self.name = application.localizedDisplayName ?? "Unknown App"
        self.icon = "📱"
        self.isCategory = false
        self.applicationToken = application
        self.categoryToken = nil
        self.isSelected = isSelected
    }
    
    // Initialize for a category
    init(category: CategoryToken, isSelected: Bool = false) {
        self.id = UUID()
        self.name = category.localizedDisplayName ?? "Unknown Category"
        self.icon = Self.categoryIcon(for: category.localizedDisplayName ?? "")
        self.isCategory = true
        self.applicationToken = nil
        self.categoryToken = category
        self.isSelected = isSelected
    }
    
    static func == (lhs: ActivityItem, rhs: ActivityItem) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    private static func categoryIcon(for category: String) -> String {
        switch category.lowercased() {
        case let name where name.contains("social"): return "💬"
        case let name where name.contains("game"): return "🎮"
        case let name where name.contains("entertainment"): return "🎬"
        case let name where name.contains("creativity"): return "🎨"
        case let name where name.contains("education"): return "📚"
        case let name where name.contains("fitness"): return "🏃"
        case let name where name.contains("reading"): return "📖"
        case let name where name.contains("productivity"): return "💼"
        case let name where name.contains("shopping"): return "🛍️"
        case let name where name.contains("travel"): return "✈️"
        default: return "📱"
        }
    }
}

struct ContentView: View {
    @StateObject var model = FamilyControlModel.shared
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @State private var activities: [ActivityItem] = []
    @State private var filteredActivities: [ActivityItem] = []
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .onChange(of: searchText) { newValue in
                        filterActivities()
                    }
                
                // Activity List
                List {
                    Section(header: Text("All Apps & Categories")) {
                        ForEach(filteredActivities) { activity in
                            HStack {
                                Text(activity.icon)
                                Text(activity.name)
                                Spacer()
                                if activity.isSelected {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                toggleSelection(for: activity)
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Choose Activities")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        model.saveAndDismiss(selectedActivities: activities.filter { $0.isSelected })
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
        }
        .onAppear {
            loadActivities()
        }
    }
    
    private func loadActivities() {
        // Load saved selection
        let savedSelection = model.savedSelection() ?? FamilyActivitySelection()
        
        var items: [ActivityItem] = []
        
        // Add applications
        for token in FamilyActivitySelection.availableApps {
            items.append(ActivityItem(
                application: token,
                isSelected: savedSelection.applicationTokens.contains(token)
            ))
        }
        
        // Add categories
        for token in FamilyActivitySelection.availableCategories {
            items.append(ActivityItem(
                category: token,
                isSelected: savedSelection.categoryTokens.contains(token)
            ))
        }
        
        activities = items.sorted { $0.name < $1.name }
        filteredActivities = activities
    }
    
    private func filterActivities() {
        if searchText.isEmpty {
            filteredActivities = activities
        } else {
            filteredActivities = activities.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    private func toggleSelection(for activity: ActivityItem) {
        if let index = activities.firstIndex(where: { $0.id == activity.id }) {
            activities[index].isSelected.toggle()
        }
        if let filteredIndex = filteredActivities.firstIndex(where: { $0.id == activity.id }) {
            filteredActivities[filteredIndex].isSelected.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}