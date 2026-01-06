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
// Note: iOS doesn't allow apps to enumerate all installed apps for privacy reasons.
// We can only check if specific apps are installed by testing their URL schemes.
// This list includes many common apps - if your app isn't here, you can add it manually in Settings.
extension LockedApp {
    static let defaultApps: [LockedApp] = [
        // Social Media
        LockedApp(name: "Instagram", iconSymbol: "📷", bundleIdentifier: "com.burbn.instagramgram", urlScheme: "instagram://", requiredSteps: 2000),
        LockedApp(name: "Facebook", iconSymbol: "f", bundleIdentifier: "com.facebook.Facebook", urlScheme: "fb://", requiredSteps: 1500),
        LockedApp(name: "Twitter", iconSymbol: "@", bundleIdentifier: "com.atebits.Tweetie2", urlScheme: "twitter://", requiredSteps: 1800),
        LockedApp(name: "TikTok", iconSymbol: "♪", bundleIdentifier: "com.zhiliaoapp.musically", urlScheme: "tiktok://", requiredSteps: 2500),
        LockedApp(name: "Snapchat", iconSymbol: "👻", bundleIdentifier: "com.toyopagroup.picaboo", urlScheme: "snapchat://", requiredSteps: 2000),
        LockedApp(name: "Reddit", iconSymbol: "r", bundleIdentifier: "com.reddit.Reddit", urlScheme: "reddit://", requiredSteps: 1800),
        LockedApp(name: "Discord", iconSymbol: "💬", bundleIdentifier: "com.hammerandchisel.discord", urlScheme: "discord://", requiredSteps: 1500),
        LockedApp(name: "LinkedIn", iconSymbol: "in", bundleIdentifier: "com.linkedin.LinkedIn", urlScheme: "linkedin://", requiredSteps: 1500),
        LockedApp(name: "Pinterest", iconSymbol: "P", bundleIdentifier: "pinterest", urlScheme: "pinterest://", requiredSteps: 1500),
        LockedApp(name: "WhatsApp", iconSymbol: "💬", bundleIdentifier: "net.whatsapp.WhatsApp", urlScheme: "whatsapp://", requiredSteps: 1500),
        LockedApp(name: "Telegram", iconSymbol: "✈", bundleIdentifier: "ph.telegra.Telegraph", urlScheme: "tg://", requiredSteps: 1500),
        LockedApp(name: "Signal", iconSymbol: "🔒", bundleIdentifier: "org.whispersystems.signal", urlScheme: "sgnl://", requiredSteps: 1500),
        LockedApp(name: "WeChat", iconSymbol: "💬", bundleIdentifier: "com.tencent.xin", urlScheme: "weixin://", requiredSteps: 1500),
        
        // Video & Entertainment
        LockedApp(name: "YouTube", iconSymbol: "▶", bundleIdentifier: "com.google.ios.youtube", urlScheme: "youtube://", requiredSteps: 2000),
        LockedApp(name: "Netflix", iconSymbol: "N", bundleIdentifier: "com.netflix.Netflix", urlScheme: "nflx://", requiredSteps: 1500),
        LockedApp(name: "Hulu", iconSymbol: "H", bundleIdentifier: "com.hulu.plus", urlScheme: "hulu://", requiredSteps: 1500),
        LockedApp(name: "Disney+", iconSymbol: "D", bundleIdentifier: "com.disney.disneyplus", urlScheme: "disneyplus://", requiredSteps: 1500),
        LockedApp(name: "Prime Video", iconSymbol: "▶", bundleIdentifier: "com.amazon.aiv.AIVApp", urlScheme: "intent://", requiredSteps: 1500),
        LockedApp(name: "HBO Max", iconSymbol: "H", bundleIdentifier: "com.hbo.hbonow", urlScheme: "hbomax://", requiredSteps: 1500),
        LockedApp(name: "Twitch", iconSymbol: "🎮", bundleIdentifier: "tv.twitch", urlScheme: "twitch://", requiredSteps: 2000),
        LockedApp(name: "Vimeo", iconSymbol: "V", bundleIdentifier: "com.vimeo.vimeo", urlScheme: "vimeo://", requiredSteps: 1500),
        
        // Music & Audio
        LockedApp(name: "Spotify", iconSymbol: "♪", bundleIdentifier: "com.spotify.client", urlScheme: "spotify://", requiredSteps: 1000),
        LockedApp(name: "Apple Music", iconSymbol: "♪", bundleIdentifier: "com.apple.Music", urlScheme: "music://", requiredSteps: 1000),
        LockedApp(name: "Pandora", iconSymbol: "♪", bundleIdentifier: "com.pandora", urlScheme: "pandora://", requiredSteps: 1000),
        LockedApp(name: "SoundCloud", iconSymbol: "♪", bundleIdentifier: "com.soundcloud.TouchApp", urlScheme: "soundcloud://", requiredSteps: 1000),
        LockedApp(name: "Audible", iconSymbol: "📚", bundleIdentifier: "com.audible.iphone", urlScheme: "audible://", requiredSteps: 1000),
        LockedApp(name: "Podcasts", iconSymbol: "🎙", bundleIdentifier: "com.apple.podcasts", urlScheme: "podcasts://", requiredSteps: 1000),
        
        // Shopping
        LockedApp(name: "Amazon", iconSymbol: "a", bundleIdentifier: "com.amazon.Amazon", urlScheme: "amazon://", requiredSteps: 1200),
        LockedApp(name: "eBay", iconSymbol: "ebay", bundleIdentifier: "com.ebay.iphone", urlScheme: "ebay://", requiredSteps: 1200),
        LockedApp(name: "Etsy", iconSymbol: "E", bundleIdentifier: "com.etsy.etsyforios", urlScheme: "etsy://", requiredSteps: 1200),
        LockedApp(name: "Target", iconSymbol: "T", bundleIdentifier: "com.target.TargetApp", urlScheme: "target://", requiredSteps: 1200),
        LockedApp(name: "Walmart", iconSymbol: "W", bundleIdentifier: "com.walmart.ios", urlScheme: "walmart://", requiredSteps: 1200),
        LockedApp(name: "Best Buy", iconSymbol: "B", bundleIdentifier: "com.bestbuy.BBYiPhoneApp", urlScheme: "bestbuy://", requiredSteps: 1200),
        
        // Payment & Finance
        LockedApp(name: "PayPal", iconSymbol: "PayPal", bundleIdentifier: "com.yourcompany.PayPal", urlScheme: "paypal://", requiredSteps: 1000),
        LockedApp(name: "Venmo", iconSymbol: "V", bundleIdentifier: "com.venmo.touch", urlScheme: "venmo://", requiredSteps: 1000),
        LockedApp(name: "Cash App", iconSymbol: "$", bundleIdentifier: "com.squareup.cash", urlScheme: "squarecash://", requiredSteps: 1000),
        LockedApp(name: "Zelle", iconSymbol: "Z", bundleIdentifier: "com.zellepay.zelle", urlScheme: "zelle://", requiredSteps: 1000),
        LockedApp(name: "Robinhood", iconSymbol: "R", bundleIdentifier: "com.robinhood.release.Robinhood", urlScheme: "robinhood://", requiredSteps: 1500),
        LockedApp(name: "Chase", iconSymbol: "C", bundleIdentifier: "com.chase.sig.android", urlScheme: "chase://", requiredSteps: 1000),
        LockedApp(name: "Bank of America", iconSymbol: "B", bundleIdentifier: "com.bankofamerica.mobile", urlScheme: "bofa://", requiredSteps: 1000),
        
        // Browsers
        LockedApp(name: "Chrome", iconSymbol: "🌐", bundleIdentifier: "com.google.chrome.ios", urlScheme: "googlechrome://", requiredSteps: 3000),
        LockedApp(name: "Safari", iconSymbol: "🌐", bundleIdentifier: "com.apple.mobilesafari", urlScheme: "x-web-search://", requiredSteps: 3000),
        LockedApp(name: "Firefox", iconSymbol: "🌐", bundleIdentifier: "org.mozilla.ios.Firefox", urlScheme: "firefox://", requiredSteps: 3000),
        LockedApp(name: "Edge", iconSymbol: "🌐", bundleIdentifier: "com.microsoft.msedge", urlScheme: "microsoft-edge-https://", requiredSteps: 3000),
        LockedApp(name: "Brave", iconSymbol: "🌐", bundleIdentifier: "com.brave.ios.browser", urlScheme: "brave://", requiredSteps: 3000),
        LockedApp(name: "DuckDuckGo", iconSymbol: "🦆", bundleIdentifier: "com.duckduckgo.mobile.ios", urlScheme: "ddgQuickLink://", requiredSteps: 3000),
        
        // Email
        LockedApp(name: "Gmail", iconSymbol: "✉", bundleIdentifier: "com.google.Gmail", urlScheme: "googlegmail://", requiredSteps: 1000),
        LockedApp(name: "Outlook", iconSymbol: "✉", bundleIdentifier: "com.microsoft.Office.Outlook", urlScheme: "ms-outlook://", requiredSteps: 1000),
        LockedApp(name: "Yahoo Mail", iconSymbol: "✉", bundleIdentifier: "com.yahoo.mobile.iphone.mail", urlScheme: "ymail://", requiredSteps: 1000),
        LockedApp(name: "Mail", iconSymbol: "✉", bundleIdentifier: "com.apple.mail", urlScheme: "message://", requiredSteps: 1000),
        
        // Food & Delivery
        LockedApp(name: "Uber Eats", iconSymbol: "🍔", bundleIdentifier: "com.ubercab.UberEats", urlScheme: "uber-eats://", requiredSteps: 1500),
        LockedApp(name: "DoorDash", iconSymbol: "🍔", bundleIdentifier: "com.doordash.DoorDashConsumer", urlScheme: "doordash://", requiredSteps: 1500),
        LockedApp(name: "Grubhub", iconSymbol: "🍔", bundleIdentifier: "com.grubhub.Grubhub", urlScheme: "grubhub://", requiredSteps: 1500),
        LockedApp(name: "Postmates", iconSymbol: "🍔", bundleIdentifier: "com.postmates.merchant", urlScheme: "postmates://", requiredSteps: 1500),
        LockedApp(name: "Starbucks", iconSymbol: "☕", bundleIdentifier: "com.starbucks.mystarbucks", urlScheme: "starbucks://", requiredSteps: 1000),
        
        // Travel
        LockedApp(name: "Uber", iconSymbol: "🚗", bundleIdentifier: "com.ubercab.UberClient", urlScheme: "uber://", requiredSteps: 1500),
        LockedApp(name: "Lyft", iconSymbol: "🚗", bundleIdentifier: "me.lyft.Lyft", urlScheme: "lyft://", requiredSteps: 1500),
        LockedApp(name: "Airbnb", iconSymbol: "🏠", bundleIdentifier: "com.airbnb.app", urlScheme: "airbnb://", requiredSteps: 1500),
        LockedApp(name: "Booking.com", iconSymbol: "🏨", bundleIdentifier: "com.booking.BookingApp", urlScheme: "booking://", requiredSteps: 1500),
        LockedApp(name: "Expedia", iconSymbol: "✈", bundleIdentifier: "com.expedia.iphone", urlScheme: "expedia://", requiredSteps: 1500),
        LockedApp(name: "Google Maps", iconSymbol: "🗺", bundleIdentifier: "com.google.Maps", urlScheme: "comgooglemaps://", requiredSteps: 1000),
        LockedApp(name: "Waze", iconSymbol: "🗺", bundleIdentifier: "com.waze.iphone", urlScheme: "waze://", requiredSteps: 1000),
        LockedApp(name: "Maps", iconSymbol: "🗺", bundleIdentifier: "com.apple.Maps", urlScheme: "maps://", requiredSteps: 1000),
        
        // Productivity
        LockedApp(name: "Slack", iconSymbol: "💼", bundleIdentifier: "com.tinyspeck.chatlyio", urlScheme: "slack://", requiredSteps: 1500),
        LockedApp(name: "Microsoft Teams", iconSymbol: "💼", bundleIdentifier: "com.microsoft.skype.teams", urlScheme: "msteams://", requiredSteps: 1500),
        LockedApp(name: "Zoom", iconSymbol: "📹", bundleIdentifier: "us.zoom.videomeetings", urlScheme: "zoomus://", requiredSteps: 1500),
        LockedApp(name: "Notion", iconSymbol: "📝", bundleIdentifier: "notion.id", urlScheme: "notion://", requiredSteps: 1500),
        LockedApp(name: "Evernote", iconSymbol: "📝", bundleIdentifier: "com.evernote.iPhone.Evernote", urlScheme: "evernote://", requiredSteps: 1500),
        LockedApp(name: "Notes", iconSymbol: "📝", bundleIdentifier: "com.apple.mobilenotes", urlScheme: "mobilenotes://", requiredSteps: 1000),
        LockedApp(name: "Reminders", iconSymbol: "📋", bundleIdentifier: "com.apple.reminders", urlScheme: "x-apple-reminder://", requiredSteps: 1000),
        LockedApp(name: "Calendar", iconSymbol: "📅", bundleIdentifier: "com.apple.mobilecal", urlScheme: "calshow://", requiredSteps: 1000),
        
        // Games
        LockedApp(name: "Games", iconSymbol: "🎮", bundleIdentifier: "com.apple.gamecenter", urlScheme: "gamecenter://", requiredSteps: 2500),
        
        // News & Reading
        LockedApp(name: "News", iconSymbol: "📰", bundleIdentifier: "com.apple.news", urlScheme: "applenews://", requiredSteps: 1500),
        LockedApp(name: "Kindle", iconSymbol: "📚", bundleIdentifier: "com.amazon.Lassen", urlScheme: "kindle://", requiredSteps: 1500),
        LockedApp(name: "Medium", iconSymbol: "📖", bundleIdentifier: "com.medium.reader", urlScheme: "medium://", requiredSteps: 1500),
        
        // Fitness & Health
        LockedApp(name: "Strava", iconSymbol: "🏃", bundleIdentifier: "com.strava.stravaride", urlScheme: "strava://", requiredSteps: 2000),
        LockedApp(name: "MyFitnessPal", iconSymbol: "💪", bundleIdentifier: "com.myfitnesspal.mfp", urlScheme: "mfp://", requiredSteps: 1500),
        LockedApp(name: "Nike Run Club", iconSymbol: "👟", bundleIdentifier: "com.nike.nikeplus.gps", urlScheme: "nikeplus://", requiredSteps: 2000),
        
        // Photo & Video
        LockedApp(name: "Photos", iconSymbol: "📸", bundleIdentifier: "com.apple.mobileslideshow", urlScheme: "photos-redirect://", requiredSteps: 1000),
        LockedApp(name: "Camera", iconSymbol: "📷", bundleIdentifier: "com.apple.camera", urlScheme: "camera://", requiredSteps: 1000),
        LockedApp(name: "VSCO", iconSymbol: "📷", bundleIdentifier: "co.vsco.cam", urlScheme: "vsco://", requiredSteps: 1500),
        
        // Default iOS Apps
        LockedApp(name: "Messages", iconSymbol: "💬", bundleIdentifier: "com.apple.MobileSMS", urlScheme: "sms://", requiredSteps: 1000),
        LockedApp(name: "Phone", iconSymbol: "📞", bundleIdentifier: "com.apple.mobilephone", urlScheme: "tel://", requiredSteps: 1000),
        LockedApp(name: "FaceTime", iconSymbol: "📹", bundleIdentifier: "com.apple.facetime", urlScheme: "facetime://", requiredSteps: 1000),
        LockedApp(name: "Contacts", iconSymbol: "👤", bundleIdentifier: "com.apple.MobileAddressBook", urlScheme: "addressbook://", requiredSteps: 1000),
        LockedApp(name: "Settings", iconSymbol: "⚙", bundleIdentifier: "com.apple.Preferences", urlScheme: "app-settings://", requiredSteps: 1000),
        LockedApp(name: "App Store", iconSymbol: "📱", bundleIdentifier: "com.apple.AppStore", urlScheme: "itms-apps://", requiredSteps: 2000),
        LockedApp(name: "Wallet", iconSymbol: "💳", bundleIdentifier: "com.apple.Passbook", urlScheme: "shoebox://", requiredSteps: 1000),
        LockedApp(name: "Health", iconSymbol: "❤", bundleIdentifier: "com.apple.Health", urlScheme: "x-apple-health://", requiredSteps: 1000),
        LockedApp(name: "Weather", iconSymbol: "☀", bundleIdentifier: "com.apple.weather", urlScheme: "weather://", requiredSteps: 1000),
        LockedApp(name: "Clock", iconSymbol: "⏰", bundleIdentifier: "com.apple.mobiletimer", urlScheme: "clock-worldclock://", requiredSteps: 1000),
        LockedApp(name: "Calculator", iconSymbol: "🔢", bundleIdentifier: "com.apple.calculator", urlScheme: "calculator://", requiredSteps: 1000),
        LockedApp(name: "Files", iconSymbol: "📁", bundleIdentifier: "com.apple.DocumentsApp", urlScheme: "shareddocuments://", requiredSteps: 1000),
    ]
}

