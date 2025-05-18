import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// Library feature
import '../../features/library/data/datasources/library_local_data_source.dart';
import '../../features/library/data/repositories/library_repository_impl.dart';
import '../../features/library/domain/repositories/library_repository.dart';
import '../../features/library/domain/usecases/get_library_items.dart';
import '../../features/library/presentation/controllers/library_controller.dart';

// YouTube Search feature
import '../../features/youtube_search/data/datasources/youtube_api_data_source.dart';
import '../../features/youtube_search/data/repositories/youtube_search_repository_impl.dart';
import '../../features/youtube_search/domain/repositories/youtube_search_repository.dart';
import '../../features/youtube_search/domain/usecases/search_videos.dart';
import '../../features/youtube_search/domain/usecases/get_video_details.dart';
import '../../features/youtube_search/presentation/controllers/youtube_search_controller.dart';

// Watch Later feature
import '../../features/youtube_search/data/datasources/watch_later_local_data_source.dart';
import '../../features/youtube_search/data/repositories/watch_later_repository_impl.dart';
import '../../features/youtube_search/domain/repositories/watch_later_repository.dart';
import '../../features/youtube_search/domain/usecases/get_saved_videos.dart';
import '../../features/youtube_search/domain/usecases/save_video.dart';
import '../../features/youtube_search/domain/usecases/remove_saved_video.dart';
import '../../features/youtube_search/domain/usecases/is_video_saved.dart';
import '../../features/youtube_search/presentation/controllers/watch_later_controller.dart';

// Downloads feature
import '../../features/youtube_search/data/datasources/downloads_local_data_source.dart';
import '../../features/youtube_search/data/repositories/downloads_repository_impl.dart';
import '../../features/youtube_search/domain/repositories/downloads_repository.dart';
import '../../features/youtube_search/domain/usecases/get_downloaded_videos.dart';
import '../../features/youtube_search/domain/usecases/download_video.dart';
import '../../features/youtube_search/domain/usecases/delete_downloaded_video.dart';
import '../../features/youtube_search/domain/usecases/is_video_downloaded.dart';
import '../../features/youtube_search/presentation/controllers/downloads_controller.dart';

// Auth feature
import '../../features/auth/presentation/controllers/auth_controller.dart';

// Home feature
import '../../features/home/data/datasources/home_local_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_videos.dart';
import '../../features/home/domain/usecases/get_categories.dart';
import '../../features/home/domain/usecases/get_videos_by_category.dart' as home;
import '../../features/home/presentation/controllers/home_controller.dart';

// Shorts feature
import '../../features/shorts/data/datasources/shorts_local_data_source.dart';
import '../../features/shorts/data/repositories/shorts_repository_impl.dart';
import '../../features/shorts/domain/repositories/shorts_repository.dart';
import '../../features/shorts/domain/usecases/get_shorts.dart';
import '../../features/shorts/domain/usecases/like_short.dart';
import '../../features/shorts/domain/usecases/subscribe_to_author.dart';
import '../../features/shorts/presentation/controllers/shorts_controller.dart';

// Subscription feature
import '../../features/subscription/data/datasources/subscription_local_data_source.dart';
import '../../features/subscription/data/repositories/subscription_repository_impl.dart';
import '../../features/subscription/domain/repositories/subscription_repository.dart';
import '../../features/subscription/domain/usecases/get_subscribed_channels.dart';
import '../../features/subscription/domain/usecases/get_subscription_videos.dart';
import '../../features/subscription/domain/usecases/get_filtered_subscription_videos.dart';
import '../../features/subscription/domain/usecases/get_subscription_filters.dart';
import '../../features/subscription/presentation/controllers/subscription_controller.dart';

// Explore feature
import '../../features/explore/data/datasources/explore_local_data_source.dart';
import '../../features/explore/data/repositories/explore_repository_impl.dart';
import '../../features/explore/domain/repositories/explore_repository.dart';
import '../../features/explore/domain/usecases/get_explore_categories.dart';
import '../../features/explore/domain/usecases/get_trending_videos.dart';
import '../../features/explore/domain/usecases/get_videos_by_category.dart';
import '../../features/explore/presentation/controllers/explore_controller.dart';

// Video feature
import '../../features/video/data/datasources/video_local_data_source.dart';
import '../../features/video/data/repositories/video_repository_impl.dart';
import '../../features/video/domain/repositories/video_repository.dart';
import '../../features/video/domain/usecases/get_video_detail.dart';
import '../../features/video/domain/usecases/get_video_comments.dart';
import '../../features/video/domain/usecases/get_related_videos.dart';
import '../../features/video/domain/usecases/like_video.dart';
import '../../features/video/domain/usecases/dislike_video.dart';
import '../../features/video/domain/usecases/remove_like_dislike.dart';
import '../../features/video/domain/usecases/subscribe_to_channel.dart';
import '../../features/video/domain/usecases/unsubscribe_from_channel.dart';
import '../../features/video/domain/usecases/add_comment.dart';
import '../../features/video/domain/usecases/like_comment.dart';
import '../../features/video/domain/usecases/unlike_comment.dart';
import '../../features/video/presentation/controllers/video_controller.dart';

// GetIt instance
final sl = GetIt.instance;

/// Initialize application dependencies
Future<void> init() async {
  //! External dependencies

  //! Core

  //! Features - Library
  // Controllers
  sl.registerFactory(
    () => LibraryController(getLibraryItems: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetLibraryItems(sl()));

  // Repositories
  sl.registerLazySingleton<LibraryRepository>(
    () => LibraryRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<LibraryLocalDataSource>(
    () => LibraryLocalDataSourceImpl(),
  );

  //! Features - Home
  // Controllers
  sl.registerFactory(
    () => HomeController(
      getVideos: sl(),
      getCategories: sl(),
      getVideosByCategory: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetVideos(sl()));
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerLazySingleton(() => home.GetVideosByCategory(sl()));

  // Repositories
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(),
  );

  //! Features - Shorts
  // Controllers
  sl.registerFactory(
    () => ShortsController(
      getShorts: sl(),
      likeShort: sl(),
      subscribeToAuthor: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetShorts(sl()));
  sl.registerLazySingleton(() => LikeShort(sl()));
  sl.registerLazySingleton(() => SubscribeToAuthor(sl()));

  // Repositories
  sl.registerLazySingleton<ShortsRepository>(
    () => ShortsRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ShortsLocalDataSource>(
    () => ShortsLocalDataSourceImpl(),
  );

  //! Features - Subscription
  // Controllers
  sl.registerFactory(
    () => SubscriptionController(
      getSubscribedChannels: sl(),
      getSubscriptionVideos: sl(),
      getFilteredSubscriptionVideos: sl(),
      getSubscriptionFilters: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetSubscribedChannels(sl()));
  sl.registerLazySingleton(() => GetSubscriptionVideos(sl()));
  sl.registerLazySingleton(() => GetFilteredSubscriptionVideos(sl()));
  sl.registerLazySingleton(() => GetSubscriptionFilters(sl()));

  // Repositories
  sl.registerLazySingleton<SubscriptionRepository>(
    () => SubscriptionRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<SubscriptionLocalDataSource>(
    () => SubscriptionLocalDataSourceImpl(),
  );

  //! Features - Upload
  // Upload feature is currently a placeholder
  // Will be implemented in future iterations

  //! Features - Explore
  // Controllers
  sl.registerFactory(
    () => ExploreController(
      getExploreCategories: sl(),
      getTrendingVideos: sl(),
      getVideosByCategory: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetExploreCategories(sl()));
  sl.registerLazySingleton(() => GetTrendingVideos(sl()));
  sl.registerLazySingleton(() => GetVideosByCategory(sl()));

  // Repositories
  sl.registerLazySingleton<ExploreRepository>(
    () => ExploreRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ExploreLocalDataSource>(
    () => ExploreLocalDataSourceImpl(),
  );

  //! Features - Video
  // Controllers
  sl.registerFactory(
    () => VideoController(
      getVideoDetail: sl(),
      getVideoComments: sl(),
      getRelatedVideos: sl(),
      likeVideo: sl(),
      dislikeVideo: sl(),
      removeLikeDislike: sl(),
      subscribeToChannel: sl(),
      unsubscribeFromChannel: sl(),
      addComment: sl(),
      likeComment: sl(),
      unlikeComment: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetVideoDetail(sl()));
  sl.registerLazySingleton(() => GetVideoComments(sl()));
  sl.registerLazySingleton(() => GetRelatedVideos(sl()));
  sl.registerLazySingleton(() => LikeVideo(sl()));
  sl.registerLazySingleton(() => DislikeVideo(sl()));
  sl.registerLazySingleton(() => RemoveLikeDislike(sl()));
  sl.registerLazySingleton(() => SubscribeToChannel(sl()));
  sl.registerLazySingleton(() => UnsubscribeFromChannel(sl()));
  sl.registerLazySingleton(() => AddComment(sl()));
  sl.registerLazySingleton(() => LikeComment(sl()));
  sl.registerLazySingleton(() => UnlikeComment(sl()));

  // Repositories
  sl.registerLazySingleton<VideoRepository>(
    () => VideoRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<VideoLocalDataSource>(
    () => VideoLocalDataSourceImpl(),
  );

  //! Features - YouTube Search
  // Controllers
  sl.registerFactory(
    () => YouTubeSearchController(
      searchVideos: sl(),
      getVideoDetails: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SearchVideos(sl()));
  sl.registerLazySingleton(() => GetYouTubeVideoDetails(sl()));

  // Repositories
  sl.registerLazySingleton<YouTubeSearchRepository>(
    () => YouTubeSearchRepositoryImpl(dataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<YouTubeApiDataSource>(
    () => YouTubeApiDataSourceImpl(client: sl()),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => GetStorage());
  sl.registerLazySingleton(() => DefaultCacheManager());

  //! Features - Authentication
  // Controllers
  sl.registerFactory(
    () => AuthController(),
  );

  //! Features - Watch Later
  // Controllers
  sl.registerFactory(
    () => WatchLaterController(
      getSavedVideos: sl(),
      saveVideo: sl(),
      removeSavedVideo: sl(),
      isVideoSaved: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetSavedVideos(sl()));
  sl.registerLazySingleton(() => SaveVideo(sl()));
  sl.registerLazySingleton(() => RemoveSavedVideo(sl()));
  sl.registerLazySingleton(() => IsVideoSaved(sl()));

  // Repositories
  sl.registerLazySingleton<WatchLaterRepository>(
    () => WatchLaterRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<WatchLaterLocalDataSource>(
    () => WatchLaterLocalDataSourceImpl(storage: sl()),
  );

  //! Features - Downloads
  // Controllers
  sl.registerFactory(
    () => DownloadsController(
      getDownloadedVideos: sl(),
      downloadVideo: sl(),
      deleteDownloadedVideo: sl(),
      isVideoDownloaded: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetDownloadedVideos(sl()));
  sl.registerLazySingleton(() => DownloadVideo(sl()));
  sl.registerLazySingleton(() => DeleteDownloadedVideo(sl()));
  sl.registerLazySingleton(() => IsVideoDownloaded(sl()));

  // Repositories
  sl.registerLazySingleton<DownloadsRepository>(
    () => DownloadsRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<DownloadsLocalDataSource>(
    () => DownloadsLocalDataSourceImpl(
      storage: sl(),
      cacheManager: sl(),
    ),
  );
}
