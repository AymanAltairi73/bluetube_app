# BlueTube App

A Flutter application that demonstrates Clean Architecture principles with a YouTube-like interface.

## Project Overview

BlueTube is a mobile application built with Flutter that follows Clean Architecture principles. It provides a YouTube-like experience with features such as video browsing, search, playback, and user interactions.

## Architecture

The project follows Clean Architecture with three main layers:

1. **Presentation Layer**: Contains UI components, screens, and controllers.
2. **Domain Layer**: Contains business logic, use cases, entities, and repository interfaces.
3. **Data Layer**: Contains repository implementations, data sources, and models.

## Features

- Home feed with video recommendations
- Video search functionality
- Video playback with controls
- Shorts (short-form videos)
- User library and subscriptions
- Video comments and interactions
- Watch later and downloads functionality
- User authentication

## Mock Data Implementation

The app uses mock data stored in JSON files to simulate API responses. This approach allows for offline development and testing without requiring an actual YouTube API key.

### Mock Data Files

- `search_results.json`: Mock search results
- `video_details.json`: Mock video details
- `trending_videos.json`: Mock trending videos
- `comments.json`: Mock comments
- `related_videos.json`: Mock related videos
- `categories.json`: Mock video categories
- `videos_by_category.json`: Mock videos by category
- `channel_details.json`: Mock channel details

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Add sample video files to the `assets/videos/` directory
4. Add sample image files to the `assets/images/` directory
5. Run the app with `flutter run`

## Dependencies

- **State Management**: GetX
- **Dependency Injection**: GetIt
- **UI Utilities**: flutter_screenutil, google_fonts, flutter_svg
- **Video Playback**: video_player, youtube_player_flutter
- **Functional Programming**: dartz
- **HTTP Requests**: http
- **Local Storage**: get_storage, path_provider
- **Caching**: flutter_cache_manager

## Recent Cleanup and Optimization

The codebase has undergone a comprehensive cleanup to improve maintainability and reduce technical debt:

1. **Removed Redundant Files**:
   - Eliminated duplicate app_routes.dart file
   - Simplified API-related code by removing unused implementation

2. **Improved Configuration**:
   - Enhanced ApiConfig class with network simulation parameters
   - Centralized configuration values for consistent behavior

3. **Code Structure Improvements**:
   - Updated local data sources to use centralized configuration
   - Improved code organization and documentation

4. **Dependency Cleanup**:
   - Removed unused share_plus dependency

## Future Improvements

- Complete implementation of the Upload feature
- Add comprehensive unit and widget tests
- Implement actual API integration with proper key management
- Add offline caching for videos and thumbnails
- Improve error handling and user feedback

## License

This project is for educational purposes only and is not affiliated with YouTube or Google.
