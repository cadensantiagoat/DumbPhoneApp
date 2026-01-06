//
//  AppLockManager.swift
//  DumbPhoneApp
//
//  Created on 2024
//

import Foundation
import Combine
import UIKit

class AppLockManager: ObservableObject {
    static let shared = AppLockManager()
    
    @Published var lockedApps: [LockedApp] = []
    @Published var showingBypassAlert: Bool = false
    @Published var showingCannotOpenAlert: Bool = false
    @Published var currentBypassApp: LockedApp?
    @Published var cannotOpenAppName: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let healthKitManager = HealthKitManager.shared
    
    private init() {
        // Observe step changes
        healthKitManager.$todaySteps
            .sink { [weak self] _ in
                self?.updateAppLockStatus()
            }
            .store(in: &cancellables)
    }
    
    func updateAppLockStatus() {
        let todaySteps = healthKitManager.todaySteps
        
        for index in lockedApps.indices {
            var app = lockedApps[index]
            
            // Check if app is bypassed
            if let bypassUntil = app.bypassUntil, bypassUntil > Date() {
                app.isLocked = false
                app.isBypassed = true
            } else if app.isBypassed {
                // Bypass expired
                app.isBypassed = false
                app.bypassUntil = nil
                app.isLocked = todaySteps < app.requiredSteps
            } else {
                // Normal lock logic
                app.currentSteps = todaySteps
                app.isLocked = todaySteps < app.requiredSteps
            }
            
            lockedApps[index] = app
        }
    }
    
    func canOpenApp(_ app: LockedApp) -> Bool {
        // Check if app is bypassed
        if let bypassUntil = app.bypassUntil, bypassUntil > Date() {
            return true
        }
        
        // Check if steps requirement is met
        return healthKitManager.todaySteps >= app.requiredSteps
    }
    
    func requestBypass(for app: LockedApp) {
        currentBypassApp = app
        showingBypassAlert = true
    }
    
    func grantBypass(for app: LockedApp, duration: TimeInterval = 3600) {
        if let index = lockedApps.firstIndex(where: { $0.id == app.id }) {
            var updatedApp = lockedApps[index]
            updatedApp.isBypassed = true
            updatedApp.bypassUntil = Date().addingTimeInterval(duration)
            updatedApp.isLocked = false
            lockedApps[index] = updatedApp
        }
    }
    
    func grantBypassAndSave(for app: LockedApp, duration: TimeInterval = 3600, settings: UserSettings) {
        grantBypass(for: app, duration: duration)
        // Also update in settings to persist
        if let index = settings.lockedApps.firstIndex(where: { $0.id == app.id }) {
            var updatedApp = settings.lockedApps[index]
            updatedApp.isBypassed = true
            updatedApp.bypassUntil = Date().addingTimeInterval(duration)
            updatedApp.isLocked = false
            settings.lockedApps[index] = updatedApp
            settings.saveSettings()
        }
    }
    
    func attemptToOpenApp(_ app: LockedApp) {
        if canOpenApp(app) {
            openApp(app: app)
        } else {
            requestBypass(for: app)
        }
    }
    
    private func openApp(app: LockedApp) {
        // Use URL scheme to open the app
        guard let url = URL(string: app.urlScheme) else {
            showCannotOpenAlert(for: app.name)
            return
        }
        
        // Check if the URL scheme can be opened
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { success in
                if !success {
                    DispatchQueue.main.async {
                        self.showCannotOpenAlert(for: app.name)
                    }
                }
            }
        } else {
            // App is not installed or URL scheme doesn't work
            showCannotOpenAlert(for: app.name)
        }
    }
    
    private func showCannotOpenAlert(for appName: String) {
        cannotOpenAppName = appName
        showingCannotOpenAlert = true
    }
    
    func syncWithSettings(_ settings: UserSettings) {
        // Update each app's lock status based on current steps
        // Preserve bypass state from settings
        lockedApps = settings.lockedApps.map { app in
            var updatedApp = app
            updatedApp.currentSteps = healthKitManager.todaySteps
            
            // Check if bypass is still valid
            if let bypassUntil = updatedApp.bypassUntil, bypassUntil > Date() {
                updatedApp.isLocked = false
                updatedApp.isBypassed = true
            } else if updatedApp.bypassUntil != nil {
                // Bypass expired, clear it
                updatedApp.isBypassed = false
                updatedApp.bypassUntil = nil
                updatedApp.isLocked = healthKitManager.todaySteps < updatedApp.requiredSteps
                // Update in settings too
                if let index = settings.lockedApps.firstIndex(where: { $0.id == app.id }) {
                    settings.lockedApps[index] = updatedApp
                }
            } else {
                // Normal lock logic
                updatedApp.isLocked = healthKitManager.todaySteps < updatedApp.requiredSteps
            }
            
            return updatedApp
        }
    }
}

