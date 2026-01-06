//
//  AppIconHelper.swift
//  DumbPhoneApp
//
//  Created on 2024
//

import Foundation

struct AppIconHelper {
    // Map app names to SF Symbols for better icon representation
    static func sfSymbolForApp(_ appName: String) -> String? {
        let symbolMap: [String: String] = [
            // Social Media
            "Instagram": "camera.fill",
            "Facebook": "f.circle.fill",
            "Twitter": "at",
            "TikTok": "music.note",
            "Snapchat": "camera.fill",
            "Reddit": "r.circle.fill",
            "Discord": "message.fill",
            "LinkedIn": "briefcase.fill",
            "Pinterest": "p.circle.fill",
            "WhatsApp": "message.fill",
            "Telegram": "paperplane.fill",
            "Signal": "lock.shield.fill",
            "WeChat": "message.fill",
            // Video & Entertainment
            "YouTube": "play.rectangle.fill",
            "Netflix": "tv.fill",
            "Hulu": "tv.fill",
            "Disney+": "tv.fill",
            "Prime Video": "play.rectangle.fill",
            "HBO Max": "tv.fill",
            "Twitch": "gamecontroller.fill",
            "Vimeo": "play.rectangle.fill",
            // Music & Audio
            "Spotify": "music.note.list",
            "Apple Music": "music.note",
            "Pandora": "music.note",
            "SoundCloud": "music.note",
            "Audible": "book.fill",
            "Podcasts": "mic.fill",
            // Shopping
            "Amazon": "cart.fill",
            "eBay": "tag.fill",
            "Etsy": "bag.fill",
            "Target": "target",
            "Walmart": "cart.fill",
            "Best Buy": "cart.fill",
            // Payment & Finance
            "PayPal": "creditcard.fill",
            "Venmo": "dollarsign.circle.fill",
            "Cash App": "dollarsign.circle.fill",
            "Zelle": "dollarsign.circle.fill",
            "Robinhood": "chart.line.uptrend.xyaxis",
            "Chase": "creditcard.fill",
            "Bank of America": "creditcard.fill",
            // Browsers
            "Chrome": "globe",
            "Safari": "safari.fill",
            "Firefox": "flame.fill",
            "Edge": "globe",
            "Brave": "shield.fill",
            "DuckDuckGo": "magnifyingglass",
            // Email
            "Gmail": "envelope.fill",
            "Outlook": "envelope.fill",
            "Yahoo Mail": "envelope.fill",
            "Mail": "envelope.fill",
            // Food & Delivery
            "Uber Eats": "takeoutbag.and.cup.and.straw.fill",
            "DoorDash": "takeoutbag.and.cup.and.straw.fill",
            "Grubhub": "takeoutbag.and.cup.and.straw.fill",
            "Postmates": "takeoutbag.and.cup.and.straw.fill",
            "Starbucks": "cup.and.saucer.fill",
            // Travel
            "Uber": "car.fill",
            "Lyft": "car.fill",
            "Airbnb": "house.fill",
            "Booking.com": "bed.double.fill",
            "Expedia": "airplane",
            "Google Maps": "map.fill",
            "Waze": "map.fill",
            "Maps": "map.fill",
            // Productivity
            "Slack": "message.fill",
            "Microsoft Teams": "person.2.fill",
            "Zoom": "video.fill",
            "Notion": "note.text",
            "Evernote": "note.text",
            "Notes": "note.text",
            "Reminders": "list.bullet",
            "Calendar": "calendar",
            // Games
            "Games": "gamecontroller.fill",
            // News & Reading
            "News": "newspaper.fill",
            "Kindle": "book.fill",
            "Medium": "book.fill",
            // Fitness & Health
            "Strava": "figure.run",
            "MyFitnessPal": "figure.strengthtraining.traditional",
            "Nike Run Club": "figure.run",
            // Photo & Video
            "Photos": "photo.fill",
            "Camera": "camera.fill",
            "VSCO": "camera.fill",
            // Default iOS Apps
            "Messages": "message.fill",
            "Phone": "phone.fill",
            "FaceTime": "video.fill",
            "Contacts": "person.fill",
            "Settings": "gearshape.fill",
            "App Store": "square.and.arrow.down.fill",
            "Wallet": "creditcard.fill",
            "Health": "heart.fill",
            "Weather": "cloud.fill",
            "Clock": "clock.fill",
            "Calculator": "number",
            "Files": "folder.fill"
        ]
        
        return symbolMap[appName]
    }
}

