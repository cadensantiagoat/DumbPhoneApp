//
//  DumbPhoneAppApp.swift
//  DumbPhoneApp
//
//  Created on 2024
//

import SwiftUI

@main
struct DumbPhoneAppApp: App {
    @StateObject private var appLockManager = AppLockManager.shared
    @StateObject private var healthKitManager = HealthKitManager.shared
    @StateObject private var userSettings = UserSettings.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appLockManager)
                .environmentObject(healthKitManager)
                .environmentObject(userSettings)
                .preferredColorScheme(.dark)
        }
    }
}


