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
  - `SortedCitySearchDecorator` - Business rule implementation for alphabetical sorting
- **Design**: Protocol-driven development for testability and flexibility

#### 🏗️ **Infrastructure Layer**
- **Purpose**: Data sources, persistence, and external services
- **Components**:
  - `PrefixTreeInMemoryCityStore` - High-performance Trie-based search (200k+ cities)
  - `UserDefaultsFavoriteCityManager` - Thread-safe favorites persistence (Actor-based)
  - `CodableCity` - Persistence adapter for UserDefaults serialization
- **Features**: JSON data loading, UserDefaults persistence, observer pattern for reactive updates

#### 🔗 **Composition Layer**
- **Purpose**: Dependency injection and app assembly
- **Components**:
  - `CitySearchComposer` - Main composition root
  - Constructor injection for all dependencies
  - Shared callback coordination between ViewModels

### Key Architectural Decisions

#### **1. Trie Data Structure (Prefix Tree)**
- **Benefit**: O(m) search complexity where m = query length
- **Performance**: Handles 200,000+ cities with sub-millisecond search times
- **Memory**: Efficient prefix sharing reduces memory footprint

**WPrefix Tree strategy**
The `PrefixTreeInMemoryCityStore` implementation uses a Trie (prefix tree) data structure instead of simple array iteration, providing significant performance improvements for prefix-based searches.

**Performance Comparison:**
- **Array Iteration**: O(n) complexity - must check every city in the 200,000+ dataset
- **Trie Search**: O(m) complexity - only traverses characters in the search query
- **Real-world Impact**: Search for "Lon" in array = 200,000 comparisons vs. Trie = 3 character traversals

**Trie Implementation Benefits:**
- **Instant Results**: Sub-millisecond response times regardless of dataset size
- **Memory Efficiency**: Shared prefixes reduce memory usage (e.g., "London", "Londrina" share "Lon" prefix)
- **Scalability**: Performance remains constant even with millions of cities
- **User Experience**: Real-time search updates without performance degradation

**Alternative Search Strategies Considered:**

**Binary Search with Sorted Cities:**
- **Complexity**: O(log n) for exact matches, O(n) for prefix searches
- **Implementation**: Sort cities alphabetically, use binary search for range finding
- **Limitation**: Still requires linear scan within matching prefix range
- **Use Case**: Better for exact city name lookups rather than prefix searches

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

### Technical Decisions & Architectural Patterns

#### **Abstraction-Driven Design**

The architecture heavily emphasizes **abstraction layers** to ensure flexibility and maintainability. 
If we wanted to use a backend service in the future as the data source, we could implement a `RemoteCitySearchService` that implements our `CitySearchable` protocol and replace the `PrefixTreeInMemoryCityStore` with it in the composition layer

##### **1. Protocol-Based Data Layer (`CitySearchable`)**
```swift
protocol CitySearchable {
    func search(for query: String) async throws -> [City]
}
```

**Why This Matters:**
- **Future-Proof**: When transitioning from local JSON to backend API, only the implementation changes
- **Testability**: Easy to mock for unit testing without external dependencies
- **Flexibility**: Multiple implementations can coexist (local cache + remote API)

**Backend Transition Example:**
```swift
// Current: Local JSON implementation
let localStore = PrefixTreeInMemoryCityStore(jsonFileName: "cities")

// Future: Backend API implementation
let remoteStore = RemoteCitySearchService(apiClient: httpClient)

// Composition layer remains unchanged
let searchViewModel = CitySearchViewModel(cityStore: remoteStore)
```

##### **2. SOLID Principles Implementation**

**Single Responsibility Principle (SRP)**
- `PrefixTreeInMemoryCityStore`: Only handles Trie-based search
- `SortedCitySearchDecorator`: Only handles result sorting
- `UserDefaultsFavoriteCityManager`: Only manages favorites persistence

**Open/Closed Principle (OCP)**
- `CitySearchable` protocol allows extension without modification
- Decorator pattern enables adding new behaviors (caching, filtering) without changing existing code

**Liskov Substitution Principle (LSP)**
- Any `CitySearchable` implementation can replace another seamlessly
- ViewModels work with abstractions, not concrete implementations

**Interface Segregation Principle (ISP)**
- Focused protocols: `CitySearchable` only defines search behavior
- No forced implementation of unused methods

**Dependency Inversion Principle (DIP)**
- High-level modules (ViewModels) depend on abstractions (`CitySearchable`)
- Low-level modules (data stores) implement these abstractions

#### **4. Dependency Injection Architecture**

**Composition Root Pattern**
The `CitySearchComposer` serves as the single point where all dependencies are assembled:

```swift
// Current implementation
let cityStore = SortedCitySearchDecorator(
    decoratee: PrefixTreeInMemoryCityStore(jsonFileName: "cities")
)

// Future backend implementation (zero changes to ViewModels)
let cityStore = SortedCitySearchDecorator(
    decoratee: CachedRemoteCitySearchService(
        remoteStore: RemoteCitySearchService(apiClient: httpClient),
        cacheStore: InMemoryCityStore()
    )
)
```

## Implementation Strategy

### Team Organization & Parallel Development

The modular architecture enables efficient parallel development across multiple team members. Here's how tasks can be distributed and parallelized:

```mermaid
gantt
    title Team Implementation Strategy - Parallel Development
    dateFormat  YYYY-MM-DD
    section Core Foundation
    Domain Models & Protocols    :done, core, 2024-01-01, 2024-01-03
    Dependency Injection Setup   :done, di, 2024-01-01, 2024-01-04
    section Data Layer
    Trie Data Structure         :active, trie, 2024-01-02, 2024-01-06
    JSON Loading & Parsing      :active, json, 2024-01-02, 2024-01-05
    Favorites Persistence       :active, fav, 2024-01-03, 2024-01-07
    section Business Logic
    Search ViewModel           :vm1, after core, 3d
    Favorites ViewModel        :vm2, after core, 3d
    City Card ViewModel        :vm3, after core, 2d
    section UI Layer
    Search Interface           :ui1, after core, 4d
    Map Integration            :ui2, after core, 5d
    Favorites Screen           :ui3, after core, 3d
    City Details Card          :ui4, after core, 2d
    section Integration
    Component Assembly         :integration, after vm1, 2d
    End-to-End Testing         :e2e, after integration, 3d
```

#### **Phase 1: Foundation**

**Core Architecture Work:**
- `City` domain model and `Identifiable` conformance
- `CitySearchable` protocol definition
- `CodableCity` persistence adapter
- `CitySearchComposer` dependency injection setup

**Infrastructure Setup Work:**
- Project structure and module organization
- Google Maps SDK integration
- Bundle resource configuration
- Initial test framework setup

#### **Phase 2: Data Layer**

**Search Engine Work:**
- `PrefixTreeInMemoryCityStore` implementation
- Trie data structure optimization
- JSON parsing and city loading
- Search performance benchmarking

**Persistence Layer Work:**
- `UserDefaultsFavoriteCityManager` as Swift Actor
- Observer pattern for reactive updates
- Thread-safety and concurrency handling
- Persistence error handling

**Data Decorators Work:**
- `SortedCitySearchDecorator` implementation
- Search result sorting algorithms
- Extensible decorator pattern setup
- Performance testing for large datasets

#### **Phase 3: Business Logic**

**Search Logic Work:**
- `CitySearchViewModel` implementation
- Debounced search with `Task` management
- Real-time search state management
- Search result filtering and display logic

**Favorites Logic Work:**
- `FavoritesViewModel` implementation
- Favorites list management
- Add/remove favorites functionality
- Persistence integration

**Selection Logic Work:**
- `CityCardViewModel` implementation
- Selected city state management
- Favorites integration for selected cities
- Cross-component communication

#### **Phase 4: UI Layer**

**Search Interface Work:**
- `SearchinputView` with real-time updates
- Search results display with `LazyVStack`
- Debounced input handling
- Search state UI (loading, error, empty)

**Map Integration Work:**
- `GoogleMapView` SwiftUI wrapper
- City marker display and animation
- Map camera controls and gestures
- Location-based UI updates

**Favorites Interface Work:**
- `FavoritesView` with list management
- Add/remove favorites UI
- Empty state and error handling
- Navigation and modal presentation

**Details & Layout Work:**
- `CityCardView` overlay implementation
- `CitySearchMapView` main coordinator
- Tab-based navigation setup
- Responsive layout for orientations

#### **Phase 5: Integration & Testing**

**Integration Work:**
- Component assembly in `CitySearchComposer`
- Cross-component callback coordination
- End-to-end flow testing
- Performance optimization

**QA Work:**
- Unit test coverage for all components
- UI automation tests
- Performance benchmarking
- Device compatibility testing

### **Parallel Development Benefits**

#### **1. Minimal Dependencies**
- Protocol-driven design allows independent development
- Mock implementations enable UI development without backend
- Dependency injection delays coupling until integration phase

#### **3. Independent Testing**
- Each component can be unit tested in isolation
- Mock implementations allow comprehensive test coverage
- Performance testing can run in parallel with feature development

### **Technical Quality Assurance**

#### **Test-Driven Development (TDD) Approach if team members are familiarized with it**

**TDD Cycle Implementation:**
```
Red → Green → Refactor
```

**TDD Benefits for Team:**
- **Clear Requirements**: Tests define expected behavior before implementation
- **Regression Safety**: Immediate feedback on breaking changes
- **Design Quality**: Forces consideration of component interfaces
- **Documentation**: Tests serve as living documentation

**TDD Implementation Scope:**
In this project, we implemented TDD specifically for the `PrefixTreeInMemoryCityStore` due to its critical performance requirements and complex algorithm implementation. However, in a complete development cycle, **every file that contains business logic should follow the TDD approach**. This includes:

- **ViewModels**: `CitySearchViewModel`, `FavoritesViewModel`, `CityCardViewModel`
- **Infrastructure Components**: `UserDefaultsFavoriteCityManager`, `SortedCitySearchDecorator`
- **Core Business Logic**: Any future service classes, managers, or utility functions
- **Data Processing**: JSON parsing, city filtering, search algorithms

The TDD approach ensures that complex logic is thoroughly tested and well-designed from the start, preventing bugs and making refactoring safer throughout the development process.

#### **Unit Testing Strategy**

The testing approach follows the standard testing pyramid with 70% unit tests, 20% integration tests, and 10% UI tests. This distribution ensures fast feedback cycles while maintaining comprehensive coverage.


#### **Code Quality Guardrails**

**SwiftLint Integration** enforces coding standards and prevents common anti-patterns. The linter can be configured to catch oversized files (maximum 300 lines with warnings at 150), overly complex functions (maximum 20 cyclomatic complexity with warnings at 10), and lengthy functions (maximum 70 lines with warnings at 50). This prevents the creation of monolithic files that become difficult to maintain and review.

**SwiftFormat Automation** ensures consistent code formatting across the entire team. It automatically handles indentation (4 spaces), line wrapping (120 characters), whitespace management, and argument formatting. This eliminates debates about code style and ensures that pull requests focus on functionality rather than formatting differences.


#### **Continuous Integration Quality Gates**

The CI pipeline automatically runs comprehensive quality checks on every pull request. This includes linting validation, formatting verification, complete test suite execution, and code coverage analysis. The pipeline blocks merging of code that doesn't meet established quality standards, preventing technical debt accumulation.

#### **Team Quality Standards**

**Code Review Checklist:**
- [ ] All new code has corresponding unit tests
- [ ] SwiftLint passes without warnings
- [ ] SwiftFormat applied consistently
- [ ] No files exceed 300 lines
- [ ] No functions exceed 50 lines
- [ ] Documentation updated for public APIs

**Code Review Checklist:**
- Code coverage validation is not mentiones since code coverage by itself will not guarantee good quality in the app. Instead, focusing on adding trsts to every piece of code we push, will ensure the feature behaves the way we want, and code coverage will increase as a side effect

## Delivery Strategy

### **Trunk-Based Development with Short-Lived Feature Branches**

The team will follow a **trunk-based development** approach using short-lived feature branches to avoid the complexity and integration issues that come with long-lived feature branches. Developers create small feature branches that are merged back to main within 1-2 days through pull requests.

**Benefits of Trunk-Based Development:**
- **Reduced Integration Conflicts**: Small, frequent merges minimize the risk of complex merge conflicts
- **Faster Feedback**: Changes are integrated quickly, allowing rapid detection of issues
- **Simplified Workflow**: No need to manage multiple long-lived branches or complex merge strategies
- **Continuous Integration**: Every pull request triggers the full CI pipeline, ensuring quality at all times

**Implementation Strategy:**
- Feature development is broken into small, deployable increments
- Each feature branch lives for a maximum of 1-2 days before being merged
- Pull requests are small, focused, and reviewed quickly
- Developers sync with main frequently (at least twice daily) before creating new branches
- Feature flags are used to hide incomplete features from end users
- Direct commits to main are blocked - all changes go through pull request review

### **Sprint-Based TestFlight Delivery**

At the end of every sprint, a build containing all completed features will be automatically delivered to **TestFlight** for stakeholder and QA validation.

**TestFlight Delivery Pipeline:**
- **Automated Build Generation**: CI/CD pipeline creates release candidates automatically
- **Feature Documentation**: Each build includes release notes detailing new features and changes
- **Stakeholder Access**: Product owners, designers, and key stakeholders receive immediate access
- **QA Validation**: Quality assurance team can test features in a production-like environment
- **Client Feedback**: Early user feedback collection through TestFlight's built-in feedback mechanisms

**Benefits of Frequent TestFlight Releases:**
- **Early Feedback**: Stakeholders can provide input before features reach production
- **Risk Mitigation**: Issues are discovered in a controlled environment
- **Validation Cycles**: Product decisions can be validated with real user interaction
- **Quality Assurance**: QA team has consistent access to latest features for comprehensive testing

### **Error Reduction Through Frequent Delivery**

Delivering small changes frequently significantly reduces the likelihood of introducing critical errors and makes any issues easier to identify and resolve.

**Small Change Benefits:**
- **Easier Debugging**: When issues arise, the scope of potential causes is limited to recent small changes
- **Quick Rollbacks**: If problems are detected, rolling back small changes is fast and low-risk
- **Reduced Complexity**: Small changes are easier to review, test, and understand
- **Faster Resolution**: Development team can quickly identify and fix issues since context is fresh

**Quality Assurance Through Frequency:**
- Each small change goes through the full CI/CD pipeline
- Automated tests catch regressions immediately
- Manual testing can focus on specific areas affected by recent changes
- Production monitoring can quickly identify any performance or functionality issues

### **Production Rollout Strategy**

For rolling out features to production users, we implement a **feature flag strategy** that provides granular control over feature availability and allows for safe, gradual rollouts.

**Feature Flag Implementation:**
- **Gradual Rollout**: Start with 5% of users, gradually increase to 25%, 50%, then 100%
- **Device-Based Targeting**: Enable features only for users with specific device capabilities (iPhone 15+, iPad Pro, etc.)
- **iOS Version Targeting**: Restrict features to users running minimum iOS versions that support all functionality
- **Geographic Rollout**: Test features in specific regions before global deployment
- **User Segment Targeting**: Enable features for power users or beta testers first

This delivery strategy ensures that the Smart City Exploration feature can be developed, tested, and deployed with minimal risk while maximizing opportunities for feedback and validation throughout the development cycle.

## Product Success Observability

### **Event Logging Strategy**

To measure the success and adoption of the Smart City Exploration feature, we implement comprehensive event logging that tracks user interactions and feature utilization patterns.

**Core Success Metrics Through Event Logging:**

**Search Feature Analytics:**
- `city_search_completed` - User selects a city from search results
- `search_results_count` - Monitor search result quality and relevance

**Favorites Feature Analytics:**
- `favorites_screen_viewed` - User navigates to favorites screen (key metric for feature adoption)
- `city_added_to_favorites` - User marks a city as favorite
- `city_removed_from_favorites` - User removes city from favorites
- `favorites_list_empty_viewed` - User sees empty favorites state
- `favorite_city_selected` - User selects city from favorites list

**User Journey Analytics:**
- `app_session_started` - Track overall app engagement
- `feature_discovery_time` - Time taken to discover favorites feature
- `session_duration` - How long users spend in the city exploration feature
- `user_retention_daily` - Daily active users using city search
- `user_retention_weekly` - Weekly retention for the feature

### **Analytics Implementation**

**Firebase Analytics Integration:**
Firebase Analytics provides a robust, cloud-based solution for tracking user behavior and measuring feature success without requiring complex infrastructure setup.

### **Analytics Implementation Example**

**Decorator Pattern for Analytics Logging:**
Using the decorator pattern, we can add analytics logging to existing components without modifying their core functionality. Here's how we would implement analytics tracking for the search functionality:

```swift
// Analytics Protocol
protocol AnalyticsHandler {
    func logEvent(_ eventName: String, parameters: [String: Any]?)
}

// Firebase Analytics Implementation
class FirebaseAnalyticsHandler: AnalyticsHandler {
    func logEvent(_ eventName: String, parameters: [String: Any]?) {
        Analytics.logEvent(eventName, parameters: parameters)
    }
}

// Analytics Decorator for CitySearchable
class AnalyticsDecoratedCityStore: CitySearchable {
    private let decoratee: CitySearchable
    private let analyticsHandler: AnalyticsHandler
    
    init(decoratee: CitySearchable, analyticsHandler: AnalyticsHandler) {
        self.decoratee = decoratee
        self.analyticsHandler = analyticsHandler
    }
    
    func search(for query: String) async throws -> [City] {
        // Log search initiated event
        analyticsHandler.logEvent("city_search_initiated", parameters: [
            "query_length": query.count,
            "query_prefix": String(query.prefix(3)) // First 3 characters for pattern analysis
        ])
        
        let startTime = Date()
        
        do {
            let results = try await decoratee.search(for: query)
            
            let searchDuration = Date().timeIntervalSince(startTime)
            
            if results.isEmpty {
                // Log search with no results
                analyticsHandler.logEvent("city_search_no_results", parameters: [
                    "query": query,
                    "search_duration": searchDuration
                ])
            } else {
                // Log successful search
                analyticsHandler.logEvent("city_search_completed", parameters: [
                    "results_count": results.count,
                    "search_duration": searchDuration,
                    "query_length": query.count
                ])
            }
            
            return results
            
        } catch {
            // Log search failure
            analyticsHandler.logEvent("search_operation_failed", parameters: [
                "error": error.localizedDescription,
                "query": query,
                "search_duration": Date().timeIntervalSince(startTime)
            ])
            
            throw error
        }
    }
}

// Composition in CitySearchComposer
public enum CitySearchComposer {
    @MainActor
    static public func compose() throws -> some View {
        GMSServices.provideAPIKey("AIzaSyAVIvISQPshSOtqRHKu7eZ3zrARhXC6bMI")
        
        // Create analytics handler
        let analyticsHandler = FirebaseAnalyticsHandler()
        
        // Create base store
        let prefixTreeStore = try PrefixTreeInMemoryCityStore(jsonFileName: "cities")
        
        // Decorate with analytics
        let analyticsStore = AnalyticsDecoratedCityStore(
            decoratee: prefixTreeStore, 
            analyticsHandler: analyticsHandler
        )
        
        // Decorate with sorting
        let cityStore = SortedCitySearchDecorator(decoratee: analyticsStore)
        
        // Continue with rest of composition...
        let searchViewModel = CitySearchViewModel(cityStore: cityStore)
        // ...
    }
}
```

**Benefits of This Approach:**
- **Separation of Concerns**: Analytics logic is separate from search logic
- **Testability**: Can inject mock analytics handler for testing
- **Flexibility**: Can easily add/remove analytics without changing core functionality
- **Composability**: Multiple decorators can be chained (analytics + sorting + caching)
- **Single Responsibility**: Each decorator has one specific purpose

### **Crash and Error Tracking**

**Critical Stability Monitoring:**
Comprehensive crash and error tracking is essential for maintaining feature reliability and user trust. We implement multi-layered error monitoring to capture and resolve issues before they impact user experience.

**Crash Analytics:**
- **App Crashes**: Track crashes specifically related to city search functionality
- **Feature-Specific Crashes**: Monitor crashes during search operations, favorites management, and map interactions
- **Memory-Related Crashes**: Identify crashes caused by large dataset handling (200k+ cities)
- **Concurrency Crashes**: Track Swift Actor-related crashes in favorites persistence
- **UI Crashes**: Monitor SwiftUI-related crashes during view transitions and state updates

**Error Event Tracking:**
- `search_operation_failed` - Search queries that result in errors or timeouts
- `favorites_save_failed` - Failures when adding/removing cities from favorites
- `map_loading_failed` - Google Maps integration failures
- `json_parsing_failed` - City data loading and parsing errors
- `network_request_failed` - Future backend integration error tracking
- `user_defaults_access_failed` - Persistence layer errors

**Firebase Crashlytics Integration:**
Firebase Crashlytics provides comprehensive crash reporting and error tracking capabilities that integrate seamlessly with our existing Firebase Analytics implementation.

### **Team Communication Strategy**

#### **Daily Standups Focus:**
- Protocol contract changes
- Performance benchmark results
- Integration blockers
- Cross-component dependencies

#### **Weekly Architecture Reviews:**
- Code quality assessments
- Performance optimization opportunities
- Technical debt identification
- Future extensibility planning

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

