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
    var urlScheme: String  // URL scheme to open the app (e.g., "instagram://")
    var isLocked: Bool
    var requiredSteps: Int
    var currentSteps: Int = 0
    var isBypassed: Bool = false
    var bypassUntil: Date?
    
    static func == (lhs: LockedApp, rhs: LockedApp) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(id: String = UUID().uuidString, name: String, iconSymbol: String, bundleIdentifier: String, urlScheme: String = "", isLocked: Bool = true, requiredSteps: Int = 1000) {
        self.id = id
        self.name = name
        self.iconSymbol = iconSymbol
        self.bundleIdentifier = bundleIdentifier
        // If no URL scheme provided, try to construct one from bundle identifier
        if urlScheme.isEmpty {
            let parts = bundleIdentifier.components(separatedBy: ".")
            if let lastPart = parts.last {
                self.urlScheme = "\(lastPart.lowercased())://"
            } else {
                self.urlScheme = "\(bundleIdentifier.replacingOccurrences(of: ".", with: "").lowercased())://"
            }
        } else {
            self.urlScheme = urlScheme
        }
        self.isLocked = isLocked
        self.requiredSteps = requiredSteps
    }
}

// Predefined apps with retro-style icons
extension LockedApp {
    static let defaultApps: [LockedApp] = [
        LockedApp(name: "Instagram", iconSymbol: "📷", bundleIdentifier: "com.burbn.instagramgram", urlScheme: "instagram://", requiredSteps: 2000),
        LockedApp(name: "Facebook", iconSymbol: "f", bundleIdentifier: "com.facebook.Facebook", urlScheme: "fb://", requiredSteps: 1500),
        LockedApp(name: "Twitter", iconSymbol: "@", bundleIdentifier: "com.atebits.Tweetie2", urlScheme: "twitter://", requiredSteps: 1800),
        LockedApp(name: "TikTok", iconSymbol: "♪", bundleIdentifier: "com.zhiliaoapp.musically", urlScheme: "tiktok://", requiredSteps: 2500),
        LockedApp(name: "YouTube", iconSymbol: "▶", bundleIdentifier: "com.google.ios.youtube", urlScheme: "youtube://", requiredSteps: 2000),
        LockedApp(name: "Netflix", iconSymbol: "N", bundleIdentifier: "com.netflix.Netflix", urlScheme: "nflx://", requiredSteps: 1500),
        LockedApp(name: "Reddit", iconSymbol: "r", bundleIdentifier: "com.reddit.Reddit", urlScheme: "reddit://", requiredSteps: 1800),
        LockedApp(name: "Snapchat", iconSymbol: "👻", bundleIdentifier: "com.toyopagroup.picaboo", urlScheme: "snapchat://", requiredSteps: 2000),
        LockedApp(name: "Discord", iconSymbol: "💬", bundleIdentifier: "com.hammerandchisel.discord", urlScheme: "discord://", requiredSteps: 1500),
        LockedApp(name: "Gmail", iconSymbol: "✉", bundleIdentifier: "com.google.Gmail", urlScheme: "googlegmail://", requiredSteps: 1000),
        LockedApp(name: "Chrome", iconSymbol: "🌐", bundleIdentifier: "com.google.chrome.ios", urlScheme: "googlechrome://", requiredSteps: 3000),
        LockedApp(name: "Safari", iconSymbol: "🌐", bundleIdentifier: "com.apple.mobilesafari", urlScheme: "x-web-search://", requiredSteps: 3000),
        LockedApp(name: "Amazon", iconSymbol: "a", bundleIdentifier: "com.amazon.Amazon", urlScheme: "amazon://", requiredSteps: 1200),
        LockedApp(name: "eBay", iconSymbol: "ebay", bundleIdentifier: "com.ebay.iphone", urlScheme: "ebay://", requiredSteps: 1200),
        LockedApp(name: "PayPal", iconSymbol: "PayPal", bundleIdentifier: "com.yourcompany.PayPal", urlScheme: "paypal://", requiredSteps: 1000),
        LockedApp(name: "Spotify", iconSymbol: "♪", bundleIdentifier: "com.spotify.client", urlScheme: "spotify://", requiredSteps: 1000),
        LockedApp(name: "Apple Music", iconSymbol: "♪", bundleIdentifier: "com.apple.Music", urlScheme: "music://", requiredSteps: 1000),
        LockedApp(name: "Games", iconSymbol: "🎮", bundleIdentifier: "com.apple.gamecenter", urlScheme: "gamecenter://", requiredSteps: 2500),
    ]
}

