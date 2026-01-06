//
//  UserSettings.swift
//  DumbPhoneApp
//
//  Created on 2024
//

import Foundation
import Combine

class UserSettings: ObservableObject {
    static let shared = UserSettings()
    
    @Published var lockedApps: [LockedApp] = []
    @Published var dailyStepGoal: Int = 5000
    @Published var isDumbPhoneModeEnabled: Bool = true
    @Published var showFirstTimePromptInfo: Bool = true
    @Published var hasCompletedOnboarding: Bool = false
    
    private let userDefaults = UserDefaults.standard
    private let appsKey = "lockedApps"
    private let stepGoalKey = "dailyStepGoal"
    private let dumbPhoneModeKey = "isDumbPhoneModeEnabled"
    private let showPromptInfoKey = "showFirstTimePromptInfo"
    private let hasCompletedOnboardingKey = "hasCompletedOnboarding"
    
    private init() {
        loadSettings()
        // Don't auto-populate apps anymore - user will select during onboarding
    }
    
    func loadSettings() {
        if let data = userDefaults.data(forKey: appsKey),
           let decoded = try? JSONDecoder().decode([LockedApp].self, from: data) {
            lockedApps = decoded
        }
        dailyStepGoal = userDefaults.integer(forKey: stepGoalKey)
        if dailyStepGoal == 0 {
            dailyStepGoal = 5000
        }
        isDumbPhoneModeEnabled = userDefaults.bool(forKey: dumbPhoneModeKey)
        // Only show prompt info if it hasn't been set yet (defaults to true for new users)
        if userDefaults.object(forKey: showPromptInfoKey) == nil {
            showFirstTimePromptInfo = true
        } else {
            showFirstTimePromptInfo = userDefaults.bool(forKey: showPromptInfoKey)
        }
        hasCompletedOnboarding = userDefaults.bool(forKey: hasCompletedOnboardingKey)
    }
    
    func saveSettings() {
        if let encoded = try? JSONEncoder().encode(lockedApps) {
            userDefaults.set(encoded, forKey: appsKey)
        }
        userDefaults.set(dailyStepGoal, forKey: stepGoalKey)
        userDefaults.set(isDumbPhoneModeEnabled, forKey: dumbPhoneModeKey)
        userDefaults.set(showFirstTimePromptInfo, forKey: showPromptInfoKey)
        userDefaults.set(hasCompletedOnboarding, forKey: hasCompletedOnboardingKey)
    }
    
    func addApp(_ app: LockedApp) {
        lockedApps.append(app)
        saveSettings()
    }
    
    func removeApp(_ app: LockedApp) {
        lockedApps.removeAll { $0.id == app.id }
        saveSettings()
    }
    
    func updateApp(_ app: LockedApp) {
        if let index = lockedApps.firstIndex(where: { $0.id == app.id }) {
            lockedApps[index] = app
            saveSettings()
        }
    }
    
    func completeOnboarding(selectedApps: [LockedApp]) {
        lockedApps = selectedApps
        hasCompletedOnboarding = true
        saveSettings()
    }
}


