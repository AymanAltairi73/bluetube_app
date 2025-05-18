import 'package:get/get.dart';
import '../../domain/entities/short.dart';
import '../../data/models/short_model.dart';
import '../../domain/usecases/get_shorts.dart';
import '../../domain/usecases/like_short.dart';
import '../../domain/usecases/subscribe_to_author.dart';

/// Controller for the Shorts screen using GetX
class ShortsController extends GetxController {
  final GetShorts getShorts;
  final LikeShort likeShort;
  final SubscribeToAuthor subscribeToAuthor;

  ShortsController({
    required this.getShorts,
    required this.likeShort,
    required this.subscribeToAuthor,
  });

  // State variables using Rx
  final RxBool isLoading = false.obs;
  final Rx<String?> errorMessage = Rx<String?>(null);
  final RxList<Short> shorts = <Short>[].obs;
  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadShorts();
  }

  /// Load shorts
  Future<void> loadShorts() async {
    isLoading.value = true;
    errorMessage.value = null;

    final result = await getShorts();

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
      },
      (shortsList) {
        shorts.assignAll(shortsList);
        isLoading.value = false;
      },
    );
  }

  /// Like a short
  Future<void> likeCurrentShort() async {
    if (shorts.isEmpty || currentIndex.value >= shorts.length) {
      return;
    }

    final short = shorts[currentIndex.value];
    final result = await likeShort(short.id);

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (success) {
        if (success) {
          // Update the short in the list with increased likes
          final updatedShort = ShortModel(
            id: short.id,
            title: short.title,
            videoUrl: short.videoUrl,
            thumbnailUrl: short.thumbnailUrl,
            author: short.author,
            authorAvatar: short.authorAvatar,
            likes: short.likes + 1,
            comments: short.comments,
            shares: short.shares,
            isSubscribed: short.isSubscribed,
            music: short.music,
            description: short.description,
          );

          final updatedShorts = List<Short>.from(shorts);
          updatedShorts[currentIndex.value] = updatedShort;
          shorts.assignAll(updatedShorts);
        }
      },
    );
  }

  /// Subscribe to the author of the current short
  Future<void> subscribeToCurrentAuthor() async {
    if (shorts.isEmpty || currentIndex.value >= shorts.length) {
      return;
    }

    final short = shorts[currentIndex.value];
    final result = await subscribeToAuthor(short.author);

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (success) {
        if (success) {
          // Update all shorts by this author to show as subscribed
          final updatedShorts = shorts.map((s) {
            if (s.author == short.author) {
              return ShortModel(
                id: s.id,
                title: s.title,
                videoUrl: s.videoUrl,
                thumbnailUrl: s.thumbnailUrl,
                author: s.author,
                authorAvatar: s.authorAvatar,
                likes: s.likes,
                comments: s.comments,
                shares: s.shares,
                isSubscribed: true,
                music: s.music,
                description: s.description,
              );
            }
            return s;
          }).toList();

          shorts.assignAll(updatedShorts);
        }
      },
    );
  }

  /// Change the current short
  void changeShort(int index) {
    if (index >= 0 && index < shorts.length) {
      currentIndex.value = index;
    }
  }

  /// Get the current short
  Short? get currentShort {
    if (shorts.isEmpty || currentIndex.value >= shorts.length) {
      return null;
    }
    return shorts[currentIndex.value];
  }

  /// Refresh shorts
  Future<void> refreshShorts() async {
    return loadShorts();
  }
}
