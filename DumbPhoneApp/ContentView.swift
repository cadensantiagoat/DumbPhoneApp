//
//  ContentView.swift
//  DumbPhoneApp
//
//  Created on 2024
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appLockManager: AppLockManager
    @EnvironmentObject var healthKitManager: HealthKitManager
    @EnvironmentObject var userSettings: UserSettings
    @State private var showingSettings = false
    @State private var showingBypassOptions = false
    
    private let columns = [
        GridItem(.adaptive(minimum: 70), spacing: 20)
    ]
    
    var body: some View {
        // Show onboarding if not completed
        if !userSettings.hasCompletedOnboarding {
            OnboardingView()
                .environmentObject(userSettings)
        } else {
            mainContentView
        }
    }
    
    private var mainContentView: some View {
        ZStack {
            // Black background
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with steps counter
                VStack(spacing: 8) {
                    HStack {
                        Text("Steps Today")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Spacer()
                        
                        Button(action: {
                            showingSettings = true
                        }) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Info about first-time prompt
                    if userSettings.showFirstTimePromptInfo {
                        HStack(spacing: 4) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                            Text("First-time app opens require confirmation")
                                .font(.system(size: 10, weight: .light))
                                .foregroundColor(.gray)
                            Spacer()
                            Button(action: {
                                userSettings.showFirstTimePromptInfo = false
                                userSettings.saveSettings()
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray.opacity(0.7))
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, -5)
                    }
                    
                    Text("\(healthKitManager.todaySteps)")
                        .font(.system(size: 48, weight: .thin, design: .rounded))
                        .foregroundColor(.white)
                    
                    if healthKitManager.todaySteps < userSettings.dailyStepGoal {
                        Text("Goal: \(userSettings.dailyStepGoal)")
                            .font(.system(size: 12, weight: .light))
                            .foregroundColor(.gray)
                    } else {
                        Text("Goal reached! 🎉")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.green)
                    }
                }
                .padding(.vertical, 20)
                
                Divider()
                    .background(Color.white.opacity(0.1))
                    .padding(.horizontal, 20)
                
                // App grid
                ScrollView {
                    if (appLockManager.lockedApps.isEmpty ? userSettings.lockedApps : appLockManager.lockedApps).isEmpty {
                        // Empty state
                        VStack(spacing: 20) {
                            Image(systemName: "square.grid.2x2")
                                .font(.system(size: 60))
                                .foregroundColor(.gray.opacity(0.5))
                            Text("No apps added yet")
                                .font(.system(size: 18, weight: .light))
                                .foregroundColor(.gray)
                            Text("Tap the settings icon to add apps")
                                .font(.system(size: 14, weight: .light))
                                .foregroundColor(.gray.opacity(0.7))
                        }
                        .padding(.top, 100)
                    } else {
                        LazyVGrid(columns: columns, spacing: 25) {
                            // Use apps from lock manager to get latest bypass state
                            ForEach(appLockManager.lockedApps.isEmpty ? userSettings.lockedApps : appLockManager.lockedApps) { app in
                                AppIconView(app: app, size: 70)
                                    .environmentObject(appLockManager)
                                    .environmentObject(healthKitManager)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 30)
                    }
                }
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
                .environmentObject(appLockManager)
                .environmentObject(healthKitManager)
                .environmentObject(userSettings)
        }
        .alert("Bypass Lock?", isPresented: $appLockManager.showingBypassAlert) {
            Button("Cancel", role: .cancel) { }
            Button("1 Hour") {
                if let app = appLockManager.currentBypassApp {
                    appLockManager.grantBypassAndSave(for: app, duration: 3600, settings: userSettings)
                }
            }
            Button("3 Hours") {
                if let app = appLockManager.currentBypassApp {
                    appLockManager.grantBypassAndSave(for: app, duration: 10800, settings: userSettings)
                }
            }
            Button("Until Tomorrow") {
                if let app = appLockManager.currentBypassApp {
                    let tomorrow = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date())
                    let duration = tomorrow.timeIntervalSinceNow
                    appLockManager.grantBypassAndSave(for: app, duration: duration, settings: userSettings)
                }
            }
        } message: {
            if let app = appLockManager.currentBypassApp {
                Text("\(app.name) requires \(app.requiredSteps) steps. You have \(healthKitManager.todaySteps) steps. Would you like to bypass this lock?")
            }
        }
        .alert("Cannot Open App", isPresented: $appLockManager.showingCannotOpenAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Unable to open \(appLockManager.cannotOpenAppName). The app may not be installed, or its URL scheme may not be configured correctly. You can manually open the app from your home screen.")
        }
        .onAppear {
            appLockManager.syncWithSettings(userSettings)
            healthKitManager.requestAuthorization()
        }
        .onChange(of: userSettings.lockedApps) { _ in
            appLockManager.syncWithSettings(userSettings)
        }
        .onChange(of: userSettings.hasCompletedOnboarding) { _ in
            // When onboarding completes, sync apps to lock manager
            if userSettings.hasCompletedOnboarding {
                appLockManager.syncWithSettings(userSettings)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppLockManager.shared)
        .environmentObject(HealthKitManager.shared)
        .environmentObject(UserSettings.shared)
}

