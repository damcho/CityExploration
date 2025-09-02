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

## User Story & Requirements

### Narrative
As a user, I want the app to load a map and display a search bar so I can search for a specific city and see its details.

### Acceptance Criteria
✅ **Real-time Prefix Search**: When the user starts typing in the search bar, the search must be done by prefix, updating the search on each character typed, displaying the search results in real time

✅ **Alphabetical Sorting**: Searched cities must be sorted alphabetically by name first and then country

✅ **Map Integration**: A city icon must appear on the map after selecting the searched city

✅ **Favorites Management**: The user can select the searched city as favourite city and access it directly from the favourites section when re-launching the app

✅ **Orientation Support**: The feature must support portrait and landscape modes

### Use Cases

#### 🔍 Search City
1. User starts typing city name
2. After three characters typed, search displays cities matching the prefix
3. Results are ordered by city and country alphabetically  
4. User taps on searched city from search list
5. City is displayed on map

#### ⭐ Select Favourite
1. User searches for a city
2. City is displayed on map
3. User can save city as favourite
4. City shows on favourites section
4. favorite cities are persisted on future app launches

#### ⭐ Unselect Favourite
1. User enters Favorite section
2. User can uncheck city as favourite
3. City gets removed from favourites section

#### 🚫 Empty Search
1. User searches for a non-existing city name
2. No results are displayed

## Solution Design

### Architecture Overview

The City Explorer application follows a **Clean Architecture** approach with clear separation of concerns, implementing the **MVVM (Model-View-ViewModel)** pattern with **SwiftUI** for the presentation layer. The architecture is organized into distinct layers that promote maintainability, testability, and scalability.

![Architecture Diagram](CitySearchArchitecture.drawio.png)

### Layer Structure

#### 🎨 **Presentation & UI Layer**
- **Framework**: SwiftUI with MVVM pattern
- **Components**: 
  - `CitySearchMapView` - Main coordinator view with dependency injection
  - `SearchinputView` - Real-time search interface with debouncing
  - `CityCardView` - City details overlay with favorites integration
  - `FavoritesView` - Favorites management interface
  - `GoogleMapView` - Map integration with city markers

#### 🧠 **ViewModel Layer**
- **Purpose**: Business logic and state management
- **Components**:
  - `CitySearchViewModel` - Search state and city selection logic
  - `FavoritesViewModel` - Favorites list management
  - `CityCardViewModel` - Selected city state and favorites interaction
- **Features**: Reactive UI updates with `@Published` properties, async task management

#### 🔧 **Core Layer**
- **Purpose**: Domain models and business protocols
- **Components**:
  - `City` - Core domain model (value type)
  - `CitySearchable` - Search abstraction protocol
  - `CodableCity` - Persistence adapter for UserDefaults
- **Design**: Protocol-driven development for testability and flexibility

#### 🏗️ **Infrastructure Layer**
- **Purpose**: Data sources, persistence, and external services
- **Components**:
  - `PrefixTreeInMemoryCityStore` - High-performance Trie-based search (200k+ cities)
  - `UserDefaultsFavoriteCityManager` - Thread-safe favorites persistence (Actor-based)
  - `SortedCitySearchDecorator` - Search result sorting decorator
- **Features**: JSON data loading, UserDefaults persistence, observer pattern for reactive updates

#### 🔗 **Composition Layer**
- **Purpose**: Dependency injection and app assembly
- **Components**:
  - `CitySearchComposer` - Main composition root
  - Constructor injection for all dependencies
  - Shared callback coordination between ViewModels

### Key Architectural Decisions

#### **1. Trie Data Structure**
- **Benefit**: O(m) search complexity where m = query length
- **Performance**: Handles 200,000+ cities with sub-millisecond search times
- **Memory**: Efficient prefix sharing reduces memory footprint

#### **2. Actor-Based Concurrency**
- **Component**: `UserDefaultsFavoriteCityManager` as Swift Actor
- **Benefit**: Thread-safe favorites management without data races
- **Pattern**: Observer pattern for reactive UI updates

#### **3. Decorator Pattern**
- **Implementation**: `SortedCitySearchDecorator` wraps search functionality
- **Benefit**: Separation of search logic from sorting logic
- **Extensibility**: Easy to add new behaviors (filtering, caching, etc.)

#### **4. Dependency Injection**
- **Pattern**: Constructor injection throughout the application
- **Composition Root**: Single point of dependency graph assembly
- **Benefits**: Testability, flexibility, and clear dependency flow

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

