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
    
    func authorize() async throws {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
    }
    
    func encourageAll() {
        store.shield.applications = []
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific([])
        store.shield.webDomainCategories = ShieldSettings.ActivityCategoryPolicy.specific([])
    }
    
    func saveSelection(selection: FamilyActivitySelection) {
    print("Starting to save selection")
    
    let applications = selection.applicationTokens
    let categories = selection.categoryTokens
    
    print("Applications to save: \(applications)")
    print("Categories to save: \(categories)")
    
    store.shield.applications = applications.isEmpty ? nil : applications
    store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories)
    store.shield.webDomainCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories)
    
    // Save to UserDefaults
    let defaults = UserDefaults.standard
    defaults.set(try? encoder.encode(selection), forKey: userDefaultsKey)
    
    print("Finished saving selection")
}
    
    func savedSelection() -> FamilyActivitySelection? {
        let defaults = UserDefaults.standard
        guard let data = defaults.data(forKey: userDefaultsKey) else {
            return nil
        }
        return try? decoder.decode(FamilyActivitySelection.self, from: data)
    }
}