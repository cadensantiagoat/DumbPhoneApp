//
//  OnboardingView.swift
//  DumbPhoneApp
//
//  Created on 2024
//

import SwiftUI
import UIKit

struct OnboardingView: View {
    @EnvironmentObject var userSettings: UserSettings
    @State private var selectedApps: Set<String> = []
    @State private var availableApps: [AvailableApp] = []
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    Text("Welcome to DumbPhone")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    
                    Text("Select apps to add to your homescreen")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Text("Note: iOS privacy restrictions limit us to checking specific apps. If your app isn't listed, you can add it manually in Settings.")
                        .font(.system(size: 11, weight: .light))
                        .foregroundColor(.gray.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.top, 4)
                }
                .padding(.bottom, 30)
                
                // App selection list
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(availableApps) { app in
                            AppSelectionRow(
                                app: app,
                                isSelected: selectedApps.contains(app.id),
                                onToggle: {
                                    if selectedApps.contains(app.id) {
                                        selectedApps.remove(app.id)
                                    } else {
                                        selectedApps.insert(app.id)
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                // Continue button
                Button(action: {
                    let appsToAdd = availableApps
                        .filter { selectedApps.contains($0.id) }
                        .map { app -> LockedApp in
                            LockedApp(
                                name: app.name,
                                iconSymbol: app.iconSymbol,
                                bundleIdentifier: app.bundleIdentifier,
                                urlScheme: app.urlScheme,
                                requiredSteps: app.defaultSteps
                            )
                        }
                    userSettings.completeOnboarding(selectedApps: appsToAdd)
                }) {
                    Text("Continue")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(selectedApps.isEmpty ? Color.gray : Color.white)
                        .cornerRadius(12)
                }
                .disabled(selectedApps.isEmpty)
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            checkInstalledApps()
        }
    }
    
    private func checkInstalledApps() {
        // Check which apps from our list are installed
        // Only show installed apps
        availableApps = LockedApp.defaultApps
            .compactMap { app -> AvailableApp? in
                guard let url = URL(string: app.urlScheme) else { return nil }
                let isInstalled = UIApplication.shared.canOpenURL(url)
                
                // Only include if installed
                guard isInstalled else { return nil }
                
                return AvailableApp(
                    id: app.id,
                    name: app.name,
                    iconSymbol: app.iconSymbol,
                    sfSymbolName: AppIconHelper.sfSymbolForApp(app.name),
                    bundleIdentifier: app.bundleIdentifier,
                    urlScheme: app.urlScheme,
                    defaultSteps: app.requiredSteps,
                    isInstalled: true
                )
            }
            .sorted { app1, app2 in
                // Sort alphabetically
                return app1.name < app2.name
            }
    }
}

struct AvailableApp: Identifiable {
    let id: String
    let name: String
    let iconSymbol: String
    let sfSymbolName: String?
    let bundleIdentifier: String
    let urlScheme: String
    let defaultSteps: Int
    let isInstalled: Bool
}

struct AppSelectionRow: View {
    let app: AvailableApp
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 16) {
                // Icon - Try to use SF Symbol first, then fallback to iconSymbol
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.black)
                        .frame(width: 50, height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                    
                    if let sfSymbol = app.sfSymbolName {
                        Image(systemName: sfSymbol)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.white)
                    } else if app.iconSymbol.count == 1 && app.iconSymbol.unicodeScalars.first?.properties.isEmoji == true {
                        Text(app.iconSymbol)
                            .font(.system(size: 24))
                    } else if app.iconSymbol.count <= 3 {
                        Text(app.iconSymbol)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    } else {
                        Text(app.iconSymbol)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                }
                
                // App name
                Text(app.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Selection indicator
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.white : Color.gray, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 16, height: 16)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.white.opacity(0.1) : Color.gray.opacity(0.05))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

