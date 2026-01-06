//
//  AppIconView.swift
//  DumbPhoneApp
//
//  Created on 2024
//

import SwiftUI

struct AppIconView: View {
    let app: LockedApp
    let size: CGFloat
    @EnvironmentObject var appLockManager: AppLockManager
    @EnvironmentObject var healthKitManager: HealthKitManager
    @EnvironmentObject var userSettings: UserSettings
    
    // Get the current state of this app from the lock manager
    var currentApp: LockedApp? {
        appLockManager.lockedApps.first { $0.id == app.id } ?? app
    }
    
    var isUnlocked: Bool {
        guard let currentApp = currentApp else {
            return healthKitManager.todaySteps >= app.requiredSteps || app.isBypassed
        }
        // Check if bypassed or steps requirement met
        if let bypassUntil = currentApp.bypassUntil, bypassUntil > Date() {
            return true
        }
        return healthKitManager.todaySteps >= currentApp.requiredSteps
    }
    
    var progress: Double {
        guard let currentApp = currentApp else {
            guard app.requiredSteps > 0 else { return 1.0 }
            return min(Double(healthKitManager.todaySteps) / Double(app.requiredSteps), 1.0)
        }
        guard currentApp.requiredSteps > 0 else { return 1.0 }
        return min(Double(healthKitManager.todaySteps) / Double(currentApp.requiredSteps), 1.0)
    }
    
    var displayApp: LockedApp {
        currentApp ?? app
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Black rounded square background
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black)
                    .frame(width: size, height: size)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isUnlocked ? Color.white.opacity(0.3) : Color.gray.opacity(0.5), lineWidth: 1)
                    )
                
                // Progress indicator (subtle border)
                if !isUnlocked {
                    RoundedRectangle(cornerRadius: 12)
                        .trim(from: 0, to: progress)
                        .stroke(Color.white.opacity(0.6), style: StrokeStyle(lineWidth: 2, lineCap: .round))
                        .frame(width: size, height: size)
                        .rotationEffect(.degrees(-90))
                }
                
                // Icon content - Try SF Symbol first, then fallback to iconSymbol
                if let sfSymbol = AppIconHelper.sfSymbolForApp(displayApp.name) {
                    Image(systemName: sfSymbol)
                        .font(.system(size: size * 0.4, weight: .medium))
                        .foregroundColor(.white)
                } else if displayApp.iconSymbol.count == 1 && displayApp.iconSymbol.unicodeScalars.first?.properties.isEmoji == true {
                    // Emoji icon
                    Text(displayApp.iconSymbol)
                        .font(.system(size: size * 0.4))
                } else if displayApp.iconSymbol.count <= 3 {
                    // Text icon (like "f", "N", "a", etc.)
                    Text(displayApp.iconSymbol)
                        .font(.system(size: size * 0.35, weight: .medium, design: .default))
                        .foregroundColor(.white)
                } else {
                    // Longer text (like "ebay", "PayPal")
                    Text(displayApp.iconSymbol)
                        .font(.system(size: size * 0.2, weight: .medium, design: .default))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                }
                
                // Lock overlay
                if !isUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: size * 0.25))
                        .foregroundColor(.white.opacity(0.7))
                        .offset(x: size * 0.3, y: -size * 0.3)
                }
            }
            
            // App name
            Text(displayApp.name)
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(.white)
                .lineLimit(1)
                .frame(width: size + 10)
            
            // Steps progress
            if !isUnlocked {
                Text("\(healthKitManager.todaySteps)/\(displayApp.requiredSteps)")
                    .font(.system(size: 9, weight: .light))
                    .foregroundColor(.gray)
            }
        }
        .onTapGesture {
            // Use the current app state from lock manager
            if let currentApp = currentApp {
                appLockManager.attemptToOpenApp(currentApp)
            } else {
                appLockManager.attemptToOpenApp(app)
            }
        }
        .contextMenu {
            if isUnlocked {
                Button(action: {
                    if let currentApp = currentApp {
                        appLockManager.reLockApp(currentApp, settings: userSettings)
                    } else {
                        appLockManager.reLockApp(app, settings: userSettings)
                    }
                }) {
                    Label("Lock App", systemImage: "lock.fill")
                }
            }
        }
    }
}


