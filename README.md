# TCAMovies 🎬

A modern iOS movie discovery app built with SwiftUI and The Composable Architecture (TCA), featuring movie browsing, favorites management, and offline support.

## 📱 Overview

TCAMovies is a comprehensive movie discovery application that allows users to explore movies across different categories, view detailed information, and manage their personal favorites list. The app leverages modern iOS development practices with a focus on maintainable, testable code architecture.

### Key Features

- 🎬 **Movie Discovery**: Browse movies in three curated categories (Now Playing, Popular, Top Rated)
- ❤️ **Favorites Management**: Save and organize favorite movies with local persistence
- 📱 **Modern UI**: Clean, intuitive interface built with SwiftUI
- 🔄 **Stubs for developers**: Stub data for development and testing
- 🏗️ **Scalable Architecture**: Feature-based organization with clear boundaries

## 🛠️ Tech Stack

### Core Technologies
- **SwiftUI** - Declarative UI framework
- **Swift** - Primary programming language
- **iOS 17+** - Target platform
- **Xcode 15+** - Development environment

### Architecture & State Management
- **The Composable Architecture (TCA)** - Unidirectional data flow and state management
- **Swift Dependencies** - Dependency injection system
- **Swift Navigation** - Type-safe navigation utilities

### Data Layer
- **SwiftData** - Modern data persistence framework (currently being integrated)
- **The Movie Database (TMDB) API** - External movie data source
- **Custom HTTP Client** - Built-in networking layer
- **Stub Data System** - JSON-based mock data for offline development

### Key Dependencies
```swift
swift-composable-architecture: 1.22.3
swift-dependencies: 1.9.2
swift-navigation: 2.3.1
swift-identified-collections: 1.1.1
swift-concurrency-extras: 1.3.1
swift-perception: 1.6.0
```

## 🏗️ Architecture

### Project Structure
```
TCAMovies/
├── Feature/                    # Feature-based modules
│   ├── MovieList/             # Movie browsing functionality
│   ├── MovieDetails/          # Detailed movie view
│   ├── FavoriteList/          # Favorites management
│   └── TabBar/                # Navigation structure
├── Models/                     # Data models
├── Network/                    # API and networking
│   ├── Client/                # HTTP client implementation
│   ├── Endpoints/             # API endpoint definitions
│   └── Helpers/               # Network utilities
├── Persistence/               # Data persistence layer
│   ├── Database.swift         # SwiftData configuration
│   ├── FavoriteDatabase.swift # Favorites repository
│   └── FavoriteModel.swift    # SwiftData model
└── Stubs/                     # Mock data for development
```

### Architecture Benefits
- **Testable**: TCA enables comprehensive unit testing
- **Predictable**: Unidirectional data flow prevents state bugs
- **Modular**: Clear separation of concerns with feature-based organization
- **Scalable**: Easy to add new features without affecting existing code
- **Type-Safe**: Leverages Swift's type system for compile-time safety

## 🚧 Current Development Status

### SwiftData Integration (In Progress)
The project is currently in the process of integrating SwiftData for local data persistence:

#### 📋 Pending
- Favorites list view implementation
- Data migration strategies
- Performance optimization for large datasets
- Offline-first data management

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 17.0+ deployment target
- Swift 5.9+

### Installation
1. Clone the repository
2. Open `TCAMovies.xcodeproj` in Xcode
3. Build and run the project
4. The app will use stub data for development

### API Configuration
The app uses The Movie Database (TMDB) API.

## 🎯 Future Improvements & Features

### Short-term Enhancements
- **Complete Favorites Implementation**
  - Finish the favorites list UI
  - Implement add/remove functionality
  - Add favorites count indicators

- **Enhanced Movie Details**
  - Cast and crew information
  - Movie trailers and videos
  - User reviews and ratings
  - Similar movies recommendations

- **Search Functionality**
  - Movie search with real-time suggestions
  - Filter by genre, year, rating
  - Search history

### Medium-term Features
- **User Experience**
  - Pull-to-refresh functionality
  - Infinite scrolling for movie lists
  - Dark mode support
  - Accessibility improvements
  - Offline-first architecture
  - Data synchronization strategies
  - Cache management
  - Image caching and optimization
  - Lazy loading for large datasets
  - Memory management optimization
  - iPad optimization
  - macOS support
  - Widget support for iOS
  - **Unit Tests**: Reducer logic and business rules
  - **Snapshot Tests**: Visual regression testing

## 📄 License

This project is for educational and development purposes.

## 🤝 Contributing

This is a personal project showcasing modern iOS development practices with TCA and SwiftUI.

---

**Built with ❤️ using SwiftUI and The Composable Architecture**