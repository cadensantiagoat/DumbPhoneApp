//
//  AppModel.swift
//  DumbPhoneApp
//
//  Created on 2024
//

import Foundation
import SwiftUI

struct LockedApp: Identifiable, Codable, Equatable {
    let id: String
    var name: String
    var iconSymbol: String
    let bundleIdentifier: String
    var isLocked: Bool
    var requiredSteps: Int
    var currentSteps: Int = 0
    var isBypassed: Bool = false
    var bypassUntil: Date?
    
    static func == (lhs: LockedApp, rhs: LockedApp) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(id: String = UUID().uuidString, name: String, iconSymbol: String, bundleIdentifier: String, isLocked: Bool = true, requiredSteps: Int = 1000) {
        self.id = id
        self.name = name
        self.iconSymbol = iconSymbol
        self.bundleIdentifier = bundleIdentifier
        self.isLocked = isLocked
        self.requiredSteps = requiredSteps
    }
}

// Predefined apps with retro-style icons
extension LockedApp {
    static let defaultApps: [LockedApp] = [
        LockedApp(name: "Instagram", iconSymbol: "📷", bundleIdentifier: "com.burbn.instagramgram", requiredSteps: 2000),
        LockedApp(name: "Facebook", iconSymbol: "f", bundleIdentifier: "com.facebook.Facebook", requiredSteps: 1500),
        LockedApp(name: "Twitter", iconSymbol: "@", bundleIdentifier: "com.atebits.Tweetie2", requiredSteps: 1800),
        LockedApp(name: "TikTok", iconSymbol: "♪", bundleIdentifier: "com.zhiliaoapp.musically", requiredSteps: 2500),
        LockedApp(name: "YouTube", iconSymbol: "▶", bundleIdentifier: "com.google.ios.youtube", requiredSteps: 2000),
        LockedApp(name: "Netflix", iconSymbol: "N", bundleIdentifier: "com.netflix.Netflix", requiredSteps: 1500),
        LockedApp(name: "Reddit", iconSymbol: "r", bundleIdentifier: "com.reddit.Reddit", requiredSteps: 1800),
        LockedApp(name: "Snapchat", iconSymbol: "👻", bundleIdentifier: "com.toyopagroup.picaboo", requiredSteps: 2000),
        LockedApp(name: "Discord", iconSymbol: "💬", bundleIdentifier: "com.hammerandchisel.discord", requiredSteps: 1500),
        LockedApp(name: "Gmail", iconSymbol: "✉", bundleIdentifier: "com.google.Gmail", requiredSteps: 1000),
        LockedApp(name: "Chrome", iconSymbol: "🌐", bundleIdentifier: "com.google.chrome.ios", requiredSteps: 3000),
        LockedApp(name: "Safari", iconSymbol: "🌐", bundleIdentifier: "com.apple.mobilesafari", requiredSteps: 3000),
        LockedApp(name: "Amazon", iconSymbol: "a", bundleIdentifier: "com.amazon.Amazon", requiredSteps: 1200),
        LockedApp(name: "eBay", iconSymbol: "ebay", bundleIdentifier: "com.ebay.iphone", requiredSteps: 1200),
        LockedApp(name: "PayPal", iconSymbol: "PayPal", bundleIdentifier: "com.yourcompany.PayPal", requiredSteps: 1000),
        LockedApp(name: "Spotify", iconSymbol: "♪", bundleIdentifier: "com.spotify.client", requiredSteps: 1000),
        LockedApp(name: "Apple Music", iconSymbol: "♪", bundleIdentifier: "com.apple.Music", requiredSteps: 1000),
        LockedApp(name: "Games", iconSymbol: "🎮", bundleIdentifier: "com.apple.gamecenter", requiredSteps: 2500),
    ]
}

