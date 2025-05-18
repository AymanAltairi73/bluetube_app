import 'package:get/get.dart';
import '../../domain/entities/channel.dart';
import '../../domain/entities/subscription_video.dart';
import '../../domain/entities/subscription_filter.dart';
import '../../domain/usecases/get_subscribed_channels.dart';
import '../../domain/usecases/get_subscription_videos.dart';
import '../../domain/usecases/get_filtered_subscription_videos.dart';
import '../../domain/usecases/get_subscription_filters.dart';

/// Controller for the Subscription screen using GetX
class SubscriptionController extends GetxController {
  final GetSubscribedChannels getSubscribedChannels;
  final GetSubscriptionVideos getSubscriptionVideos;
  final GetFilteredSubscriptionVideos getFilteredSubscriptionVideos;
  final GetSubscriptionFilters getSubscriptionFilters;
  
  SubscriptionController({
    required this.getSubscribedChannels,
    required this.getSubscriptionVideos,
    required this.getFilteredSubscriptionVideos,
    required this.getSubscriptionFilters,
  });
  
  // State variables using Rx
  final RxBool isChannelsLoading = false.obs;
  final RxBool isVideosLoading = false.obs;
  final RxBool isFiltersLoading = false.obs;
  final Rx<String?> errorMessage = Rx<String?>(null);
  final RxList<Channel> channels = <Channel>[].obs;
  final RxList<SubscriptionVideo> videos = <SubscriptionVideo>[].obs;
  final RxList<SubscriptionFilter> filters = <SubscriptionFilter>[].obs;
  final RxString selectedFilter = 'All'.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }
  
  /// Load initial data (channels, videos, and filters)
  Future<void> loadInitialData() async {
    await loadFilters();
    await loadChannels();
    await loadVideos();
  }
  
  /// Load subscribed channels
  Future<void> loadChannels() async {
    isChannelsLoading.value = true;
    
    final result = await getSubscribedChannels();
    
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isChannelsLoading.value = false;
      },
      (channelsList) {
        channels.assignAll(channelsList);
        isChannelsLoading.value = false;
      },
    );
  }
  
  /// Load subscription videos
  Future<void> loadVideos() async {
    isVideosLoading.value = true;
    errorMessage.value = null;
    
    final result = await getSubscriptionVideos();
    
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isVideosLoading.value = false;
      },
      (videosList) {
        videos.assignAll(videosList);
        isVideosLoading.value = false;
      },
    );
  }
  
  /// Load subscription filters
  Future<void> loadFilters() async {
    isFiltersLoading.value = true;
    
    final result = await getSubscriptionFilters();
    
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isFiltersLoading.value = false;
      },
      (filtersList) {
        filters.assignAll(filtersList);
        isFiltersLoading.value = false;
      },
    );
  }
  
  /// Load videos by filter
  Future<void> loadVideosByFilter(String filter) async {
    isVideosLoading.value = true;
    errorMessage.value = null;
    selectedFilter.value = filter;
    
    // Update selected filter in the list
    final updatedFilters = filters.map((f) {
      return f.copyWith(isSelected: f.name == filter);
    }).toList();
    filters.assignAll(updatedFilters);
    
    final result = await getFilteredSubscriptionVideos(filter);
    
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isVideosLoading.value = false;
      },
      (videosList) {
        videos.assignAll(videosList);
        isVideosLoading.value = false;
      },
    );
  }
  
  /// Refresh subscription data
  Future<void> refreshSubscriptionData() async {
    return loadInitialData();
  }
}
