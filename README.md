# BlueTube App

A Flutter application that demonstrates Clean Architecture principles with a YouTube-like interface.

---

## 🗂️ Project Overview

**BlueTube** is a cross-platform mobile application built with **Flutter** (Dart) that mimics YouTube’s core user experience. The app is structured using Clean Architecture, ensuring a modular, maintainable, and scalable codebase.

---

## 🏛️ Architecture

The project is organized into three main layers:

- **Presentation Layer**  
  UI widgets, screens, controllers, and state management.
- **Domain Layer**  
  Business logic, use cases, entities, and repository interfaces.
- **Data Layer**  
  Data sources, repository implementations, and models.

This separation of concerns allows for easy testing, flexibility, and code reuse.

---

## ✨ Features

- Home feed with video recommendations
- Powerful video search functionality
- Video playback with advanced controls
- Shorts (short-form videos)
- User library and subscriptions
- Video comments and interactive features
- "Watch Later" and downloads functionality
- User authentication (mocked)
- Clean, responsive, and modern UI

---

## 📁 Mock Data Implementation

BlueTube uses local JSON files as mock data sources to simulate API interactions. This enables offline development and testing without needing an actual YouTube API key.

**Sample Mock Data Files:**

- `search_results.json`: Search results
- `video_details.json`: Video details
- `trending_videos.json`: Trending videos
- `comments.json`: Comments section
- `related_videos.json`: Related videos
- `categories.json`: Video categories
- `videos_by_category.json`: Category-specific videos
- `channel_details.json`: Channel information

---

## 🚀 Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/AymanAltairi73/bluetube_app.git
   cd bluetube_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Add assets**
   - Place sample video files in `assets/videos/`
   - Place sample image files in `assets/images/`

4. **Run the app**
   ```bash
   flutter run
   ```
   > Ensure you have a connected device or emulator.

---

## 🛠️ Dependencies

- **State Management:** GetX
- **Dependency Injection:** GetIt
- **UI Utilities:** flutter_screenutil, google_fonts, flutter_svg
- **Video Playback:** video_player, youtube_player_flutter
- **Functional Programming:** dartz
- **HTTP Requests:** http
- **Local Storage:** get_storage, path_provider
- **Caching:** flutter_cache_manager

---

## 🧹 Recent Cleanup and Optimization

BlueTube’s codebase has recently been refactored and optimized for maintainability:

- **Redundant Files Removed:**
  - Duplicate `app_routes.dart` file eliminated
  - Unused API implementation code removed

- **Configuration Improvements:**
  - Enhanced `ApiConfig` with network simulation parameters
  - Centralized configuration values for consistency

- **Code Structure:**
  - Local data sources now utilize centralized config
  - Improved organization and documentation

- **Dependency Cleanup:**
  - Removed unused `share_plus` dependency

---

## 🗺️ Roadmap & Future Improvements

- Complete the upload feature
- Add comprehensive unit and widget tests
- Integrate with live APIs using secure key management
- Implement offline video and thumbnail caching
- Enhance error handling and user feedback

---

## 📜 License

This project is for educational purposes only and is not affiliated with YouTube or Google.

---

> Developed with ❤️ by [AymanAltairi73](https://github.com/AymanAltairi73)
