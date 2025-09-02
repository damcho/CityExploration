# City Explorer

City Explorer is a SwiftUI-based iOS application that allows users to discover and explore cities from around the world. Built with modern iOS development practices, the app provides an intuitive interface for searching through a comprehensive database of over 200,000 cities worldwide.

## Features

### 🔍 CitySearch Feature

The CitySearch feature is the core functionality of City Explorer, providing users with powerful city discovery capabilities:

- **Global City Database**: Search through 200,000+ cities from around the world with real-time prefix-based search
- **Interactive Map Integration**: View selected cities on an integrated Google Maps interface with precise location markers
- **Smart Search Results**: Cities are automatically sorted alphabetically by name and country for easy browsing
- **Favorites Management**: Save your favorite cities for quick access with persistent local storage
- **Country Information**: Each search result displays the city name along with its country code for clear identification
- **Responsive UI**: Clean, modern SwiftUI interface with smooth animations and intuitive navigation

The CitySearch feature leverages a high-performance prefix tree (Trie) data structure for lightning-fast search results, ensuring smooth user experience even with the large dataset. Search results are intelligently sorted and presented in a user-friendly format that makes it easy to distinguish between cities with similar names across different countries.

## Technical Requirements

### Development Stack
- **iOS**: 15.0+
- **Xcode**: 16.0+
- **Swift**: 5.7+
- **SwiftUI**: Latest version
- **Google Maps SDK**: Integrated via Swift Package Manager

### Dependencies
- **GoogleMaps**: For interactive map functionality and city location visualization
- **Foundation**: Core Swift framework for data handling and JSON processing
- **SwiftUI**: Modern declarative UI framework

### Device Support
- **Supported Devices**: iPhone, iPad
- **Orientations**: Portrait (primary), supports all orientations on iPad
- **Minimum iOS Version**: iOS 15.0

## Getting Started

### Prerequisites
1. macOS with Xcode 16.0 or later installed
2. iOS Simulator or physical iOS device (iOS 15.0+)
3. Google Maps API key (included in project for development)

### Installation
```bash
# Clone the repository
git clone https://github.com/yourusername/CityExploration.git

# Navigate to project directory
cd CityExploration/CitySearch

# Open in Xcode
open CitySearch.xcworkspace
```

### Running the App
1. Select your target device (simulator or physical device)
2. Build and run the project (⌘+R)
3. The app will launch with the city search interface ready to use

### Configuration
- **Google Maps API Key**: Pre-configured for development use
- **City Database**: Automatically loaded from bundled `cities.json` file
- **No additional setup required** - the app is ready to run out of the box

