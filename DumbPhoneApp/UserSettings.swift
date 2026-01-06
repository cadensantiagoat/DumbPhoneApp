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
    
    private let userDefaults = UserDefaults.standard
    private let appsKey = "lockedApps"
    private let stepGoalKey = "dailyStepGoal"
    private let dumbPhoneModeKey = "isDumbPhoneModeEnabled"
    
    private init() {
        loadSettings()
        if lockedApps.isEmpty {
            lockedApps = LockedApp.defaultApps
            saveSettings()
        }
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
    }
    
    func saveSettings() {
        if let encoded = try? JSONEncoder().encode(lockedApps) {
            userDefaults.set(encoded, forKey: appsKey)
        }
        userDefaults.set(dailyStepGoal, forKey: stepGoalKey)
        userDefaults.set(isDumbPhoneModeEnabled, forKey: dumbPhoneModeKey)
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
}


