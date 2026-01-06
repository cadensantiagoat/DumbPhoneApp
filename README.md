# DumbPhone App

An iOS app that transforms your iPhone into a "dumbphone" by locking apps until you complete your daily step goals. Features a minimalist retro-style interface with black background and simple app icons.

## Features

- **Step-Based App Locking**: Lock apps until you complete a customizable number of steps
- **Retro-Style UI**: Minimalist black background with simple white icons, similar to classic phone interfaces
- **Customizable Apps**: Add, remove, and configure which apps are locked and their step requirements
- **Bypass Functionality**: Temporarily bypass locked apps when needed (1 hour, 3 hours, or until tomorrow)
- **HealthKit Integration**: Automatically tracks your daily steps using Apple HealthKit
- **Real-Time Updates**: Step counter and app lock status update in real-time

## Requirements

- iOS 17.0 or later
- Xcode 15.0 or later
- HealthKit access (requires user permission)

## Setup

1. Open `DumbPhoneApp.xcodeproj` in Xcode
2. Select your development team in the project settings
3. Build and run on a physical iOS device (HealthKit requires a real device)
4. Grant HealthKit permissions when prompted

## How It Works

### App Locking
- Each app can be configured with a required step count
- Apps remain locked until you reach the required steps for the day
- Step count resets daily at midnight

### Bypass Feature
- When you try to open a locked app, you'll be prompted to bypass the lock
- Choose from:
  - 1 hour bypass
  - 3 hour bypass
  - Until tomorrow bypass
- Bypass automatically expires after the selected duration

### Customization
- Add new apps to lock
- Modify step requirements for each app
- Change app icons (use emojis or text)
- Set your daily step goal

## Limitations

**Important iOS Security Note**: Due to iOS security restrictions, this app cannot directly prevent access to other apps on your device. The app provides:

1. A custom launcher interface that shows your locked apps
2. Visual indicators showing which apps are locked/unlocked
3. Bypass functionality for when you need access

To fully lock apps, you would need to use iOS Screen Time API (which requires special entitlements from Apple) or use the device's built-in Screen Time features.

## Project Structure

- `DumbPhoneAppApp.swift` - Main app entry point
- `ContentView.swift` - Main home screen with app grid
- `SettingsView.swift` - Settings and app management
- `AppIconView.swift` - Individual app icon component
- `AppModel.swift` - Data models for locked apps
- `HealthKitManager.swift` - HealthKit integration for step tracking
- `AppLockManager.swift` - App locking and bypass logic
- `UserSettings.swift` - User preferences and data persistence

## Customization

### Adding Apps
1. Open Settings
2. Tap "Add App"
3. Enter app name, icon symbol (emoji or text), bundle identifier, and required steps

### Predefined Apps
The app comes with several predefined apps including:
- Social media apps (Instagram, Facebook, Twitter, TikTok, Reddit)
- Entertainment apps (Netflix, YouTube, Spotify)
- Shopping apps (Amazon, eBay)
- And more...

## Privacy

- All data is stored locally on your device
- HealthKit data is only read, never written
- No data is sent to external servers
- Step data is only used to determine app lock status

## Future Enhancements

Potential features for future versions:
- Screen Time API integration for true app blocking
- Custom step goals per app
- Weekly/monthly step tracking
- Widget support
- Apple Watch integration
- Multiple bypass duration options

## License

This project is provided as-is for educational and personal use.


