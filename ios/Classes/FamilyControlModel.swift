//
//  FamilyControlModel.swift
//  screen_time_api_ios
//

import Foundation
import FamilyControls
import DeviceActivity
import ManagedSettings

class FamilyControlModel: ObservableObject {
    static let shared = FamilyControlModel()
    
    private init() {
        selectionToDiscourage = savedSelection() ?? FamilyActivitySelection()
    }
    
    private let store = ManagedSettingsStore()
    private let userDefaultsKey = "ScreenTimeSelection"
    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()
    
    var selectionToDiscourage = FamilyActivitySelection() {
        willSet {
            print("got here \(newValue)")
            
            let applications = newValue.applicationTokens
            let categories = newValue.categoryTokens
            
            print("applications \(applications)")
            print("categories \(categories)")
            
            store.shield.applications = applications.isEmpty ? nil : applications
            store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories)
            store.shield.webDomainCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories)
            self.saveSelection(selection: newValue)
        }
    }
    
    func saveAndDismiss(selectedActivities: [ActivityItem]) {
        var selection = FamilyActivitySelection()
        
        // Add selected applications
        for activity in selectedActivities where !activity.isCategory {
            selection.applicationTokens.insert(activity.token)
        }
        
        // Add selected categories
        for activity in selectedActivities where activity.isCategory {
            selection.categoryTokens.insert(activity.token)
        }
        
        // Update selection
        selectionToDiscourage = selection
    }
    
    func authorize() async throws {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
    }
    
    func encourageAll() {
        store.shield.applications = []
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific([])
        store.shield.webDomainCategories = ShieldSettings.ActivityCategoryPolicy.specific([])
    }
    
    func saveSelection(selection: FamilyActivitySelection) {
        let defaults = UserDefaults.standard
        defaults.set(try? encoder.encode(selection), forKey: userDefaultsKey)
    }
    
    func savedSelection() -> FamilyActivitySelection? {
        let defaults = UserDefaults.standard
        guard let data = defaults.data(forKey: userDefaultsKey) else {
            return nil
        }
        return try? decoder.decode(FamilyActivitySelection.self, from: data)
    }
}