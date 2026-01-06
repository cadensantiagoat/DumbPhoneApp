//
//  SettingsView.swift
//  DumbPhoneApp
//
//  Created on 2024
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appLockManager: AppLockManager
    @EnvironmentObject var healthKitManager: HealthKitManager
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedApp: LockedApp?
    @State private var showingAddApp = false
    @State private var newAppName = ""
    @State private var newAppIcon = ""
    @State private var newAppSteps = 1000
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                List {
                    Section(header: Text("General Settings").foregroundColor(.white)) {
                        HStack {
                            Text("Daily Step Goal")
                                .foregroundColor(.white)
                            Spacer()
                            Stepper("", value: $userSettings.dailyStepGoal, in: 1000...20000, step: 500)
                                .labelsHidden()
                            Text("\(userSettings.dailyStepGoal)")
                                .foregroundColor(.gray)
                                .frame(width: 60, alignment: .trailing)
                        }
                        .listRowBackground(Color.gray.opacity(0.1))
                        
                        Toggle("DumbPhone Mode", isOn: $userSettings.isDumbPhoneModeEnabled)
                            .foregroundColor(.white)
                            .listRowBackground(Color.gray.opacity(0.1))
                        
                        HStack {
                            Text("HealthKit Status")
                                .foregroundColor(.white)
                            Spacer()
                            Text(healthKitManager.isAuthorized ? "Authorized" : "Not Authorized")
                                .foregroundColor(healthKitManager.isAuthorized ? .green : .red)
                            
                            if !healthKitManager.isAuthorized {
                                Button("Authorize") {
                                    healthKitManager.requestAuthorization()
                                }
                                .foregroundColor(.blue)
                            }
                        }
                        .listRowBackground(Color.gray.opacity(0.1))
                    }
                    
                    Section(header: Text("Locked Apps").foregroundColor(.white)) {
                        ForEach(userSettings.lockedApps) { app in
                            NavigationLink(destination: AppDetailView(app: app)
                                .environmentObject(userSettings)
                                .environmentObject(appLockManager)) {
                                HStack {
                                    // Mini icon preview
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.black)
                                            .frame(width: 40, height: 40)
                                        Text(app.iconSymbol)
                                            .font(.system(size: 16))
                                            .foregroundColor(.white)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(app.name)
                                            .foregroundColor(.white)
                                        Text("\(app.requiredSteps) steps")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    if app.isLocked {
                                        Image(systemName: "lock.fill")
                                            .foregroundColor(.gray)
                                    } else {
                                        Image(systemName: "lock.open.fill")
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                            .listRowBackground(Color.gray.opacity(0.1))
                        }
                        .onDelete(perform: deleteApps)
                        
                        Button(action: {
                            showingAddApp = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add App")
                            }
                            .foregroundColor(.blue)
                        }
                        .listRowBackground(Color.gray.opacity(0.1))
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        userSettings.saveSettings()
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingAddApp) {
                AddAppView()
                    .environmentObject(userSettings)
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func deleteApps(at offsets: IndexSet) {
        for index in offsets {
            userSettings.removeApp(userSettings.lockedApps[index])
        }
    }
}

struct AppDetailView: View {
    let app: LockedApp
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var appLockManager: AppLockManager
    @State private var appName: String
    @State private var appIcon: String
    @State private var urlScheme: String
    @State private var requiredSteps: Int
    @Environment(\.dismiss) var dismiss
    
    init(app: LockedApp) {
        self.app = app
        _appName = State(initialValue: app.name)
        _appIcon = State(initialValue: app.iconSymbol)
        _urlScheme = State(initialValue: app.urlScheme)
        _requiredSteps = State(initialValue: app.requiredSteps)
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            Form {
                Section(header: Text("App Details").foregroundColor(.white)) {
                    TextField("App Name", text: $appName)
                        .foregroundColor(.white)
                        .listRowBackground(Color.gray.opacity(0.1))
                    
                    TextField("Icon Symbol", text: $appIcon)
                        .foregroundColor(.white)
                        .listRowBackground(Color.gray.opacity(0.1))
                    
                    TextField("URL Scheme (e.g., instagram://)", text: $urlScheme)
                        .foregroundColor(.white)
                        .listRowBackground(Color.gray.opacity(0.1))
                    
                    HStack {
                        Text("Required Steps")
                            .foregroundColor(.white)
                        Spacer()
                        Stepper("", value: $requiredSteps, in: 100...10000, step: 100)
                            .labelsHidden()
                        Text("\(requiredSteps)")
                            .foregroundColor(.gray)
                            .frame(width: 80, alignment: .trailing)
                    }
                    .listRowBackground(Color.gray.opacity(0.1))
                }
                
                Section {
                    // Show re-lock option if app is currently unlocked
                    if let currentApp = userSettings.lockedApps.first(where: { $0.id == app.id }),
                       (!currentApp.isLocked || currentApp.isBypassed) {
                        Button(action: {
                            appLockManager.reLockApp(app, settings: userSettings)
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: "lock.fill")
                                Text("Re-lock App")
                            }
                        }
                        .foregroundColor(.orange)
                        .listRowBackground(Color.gray.opacity(0.1))
                    }
                    
                    Button("Save Changes") {
                        if let index = userSettings.lockedApps.firstIndex(where: { $0.id == app.id }) {
                            var updatedApp = userSettings.lockedApps[index]
                            updatedApp.name = appName
                            updatedApp.iconSymbol = appIcon
                            updatedApp.urlScheme = urlScheme.isEmpty ? updatedApp.urlScheme : urlScheme
                            updatedApp.requiredSteps = requiredSteps
                            userSettings.updateApp(updatedApp)
                        }
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    .listRowBackground(Color.gray.opacity(0.1))
                    
                    Button("Delete App", role: .destructive) {
                        userSettings.removeApp(app)
                        dismiss()
                    }
                    .listRowBackground(Color.gray.opacity(0.1))
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Edit App")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
}

struct AddAppView: View {
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.dismiss) var dismiss
    @State private var appName = ""
    @State private var appIcon = ""
    @State private var urlScheme = ""
    @State private var requiredSteps = 1000
    @State private var bundleIdentifier = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                Form {
                    Section(header: Text("New App").foregroundColor(.white)) {
                        TextField("App Name", text: $appName)
                            .foregroundColor(.white)
                            .listRowBackground(Color.gray.opacity(0.1))
                        
                        TextField("Icon Symbol (emoji or text)", text: $appIcon)
                            .foregroundColor(.white)
                            .listRowBackground(Color.gray.opacity(0.1))
                        
                        TextField("URL Scheme (e.g., instagram://)", text: $urlScheme)
                            .foregroundColor(.white)
                            .listRowBackground(Color.gray.opacity(0.1))
                        
                        TextField("Bundle Identifier", text: $bundleIdentifier)
                            .foregroundColor(.white)
                            .listRowBackground(Color.gray.opacity(0.1))
                        
                        HStack {
                            Text("Required Steps")
                                .foregroundColor(.white)
                            Spacer()
                            Stepper("", value: $requiredSteps, in: 100...10000, step: 100)
                                .labelsHidden()
                            Text("\(requiredSteps)")
                                .foregroundColor(.gray)
                                .frame(width: 80, alignment: .trailing)
                        }
                        .listRowBackground(Color.gray.opacity(0.1))
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Add App")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let newApp = LockedApp(
                            name: appName.isEmpty ? "New App" : appName,
                            iconSymbol: appIcon.isEmpty ? "📱" : appIcon,
                            bundleIdentifier: bundleIdentifier.isEmpty ? "com.example.app" : bundleIdentifier,
                            urlScheme: urlScheme,
                            requiredSteps: requiredSteps
                        )
                        userSettings.addApp(newApp)
                        dismiss()
                    }
                    .disabled(appName.isEmpty)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}


