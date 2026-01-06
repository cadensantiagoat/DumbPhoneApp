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
    
    var isUnlocked: Bool {
        healthKitManager.todaySteps >= app.requiredSteps || app.isBypassed
    }
    
    var progress: Double {
        guard app.requiredSteps > 0 else { return 1.0 }
        return min(Double(healthKitManager.todaySteps) / Double(app.requiredSteps), 1.0)
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
                
                // Icon content
                if app.iconSymbol.count == 1 && app.iconSymbol.unicodeScalars.first?.properties.isEmoji == true {
                    // Emoji icon
                    Text(app.iconSymbol)
                        .font(.system(size: size * 0.4))
                } else if app.iconSymbol.count <= 3 {
                    // Text icon (like "f", "N", "a", etc.)
                    Text(app.iconSymbol)
                        .font(.system(size: size * 0.35, weight: .medium, design: .default))
                        .foregroundColor(.white)
                } else {
                    // Longer text (like "ebay", "PayPal")
                    Text(app.iconSymbol)
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
            Text(app.name)
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(.white)
                .lineLimit(1)
                .frame(width: size + 10)
            
            // Steps progress
            if !isUnlocked {
                Text("\(healthKitManager.todaySteps)/\(app.requiredSteps)")
                    .font(.system(size: 9, weight: .light))
                    .foregroundColor(.gray)
            }
        }
        .onTapGesture {
            appLockManager.attemptToOpenApp(app)
        }
    }
}


