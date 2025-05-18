import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../../../../core/errors/failures.dart';
import '../models/library_item_model.dart';

/// Local data source for library items
abstract class LibraryLocalDataSource {
  /// Get all library items
  Future<List<LibraryItemModel>> getLibraryItems();

  /// Get library items by type
  Future<List<LibraryItemModel>> getLibraryItemsByType(String type);

  /// Add item to library
  Future<bool> addToLibrary(LibraryItemModel item);

  /// Remove item from library
  Future<bool> removeFromLibrary(String itemId);
}

/// Implementation of [LibraryLocalDataSource] using mock data
class LibraryLocalDataSourceImpl implements LibraryLocalDataSource {
  // In-memory cache of mock data
  List<Map<String, dynamic>>? _cachedData;
  final Random _random = Random();

  // Load mock data from JSON file
  Future<List<Map<String, dynamic>>> _loadMockData() async {
    if (_cachedData != null) {
      return _cachedData!;
    }

    try {
      // Load the JSON file from assets
      final jsonString = await rootBundle.loadString('assets/mock_data/library_items.json');
      final jsonData = json.decode(jsonString);

      // Extract the items array
      _cachedData = List<Map<String, dynamic>>.from(jsonData['items']);
      return _cachedData!;
    } catch (e) {
      // Fallback to hardcoded data if JSON loading fails
      _cachedData = [
        {
          'id': 'lib001',
          'title': 'Flutter Clean Architecture Tutorial',
          'thumbnail_url': 'assets/images/thumbnail.jpg',
          'channel_name': 'Flutter Dev',
          'created_at': '2023-05-15T10:30:00Z',
          'type': 'watch_later',
          'views': 245000,
          'duration': '32:45'
        },
        {
          'id': 'lib002',
          'title': 'Building Responsive UIs in Flutter',
          'thumbnail_url': 'assets/images/thumbnail.jpg',
          'channel_name': 'Flutter Community',
          'created_at': '2023-05-14T15:45:00Z',
          'type': 'history',
          'views': 189000,
          'duration': '24:18'
        },
      ];
      return _cachedData!;
    }
  }

  // Simulate network delay with random duration
  Future<void> _simulateNetworkDelay() async {
    // Random delay between 200ms and 800ms
    final delay = 200 + _random.nextInt(600);
    await Future.delayed(Duration(milliseconds: delay));

    // Simulate random errors (10% chance)
    if (_random.nextDouble() < 0.1) {
      throw CacheFailure(message: 'Network error occurred. Please try again.');
    }
  }

  @override
  Future<List<LibraryItemModel>> getLibraryItems() async {
    await _simulateNetworkDelay();

    try {
      final data = await _loadMockData();
      return data.map((item) => LibraryItemModel.fromJson(item)).toList();
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to get library items: ${e.toString()}');
    }
  }

  @override
  Future<List<LibraryItemModel>> getLibraryItemsByType(String type) async {
    await _simulateNetworkDelay();

    try {
      final data = await _loadMockData();
      final filteredData = data.where((item) => item['type'] == type).toList();
      return filteredData.map((item) => LibraryItemModel.fromJson(item)).toList();
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to get library items by type: ${e.toString()}');
    }
  }

  @override
  Future<bool> addToLibrary(LibraryItemModel item) async {
    await _simulateNetworkDelay();

    try {
      final data = await _loadMockData();
      data.add(item.toJson());
      return true;
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to add item to library: ${e.toString()}');
    }
  }

  @override
  Future<bool> removeFromLibrary(String itemId) async {
    await _simulateNetworkDelay();

    try {
      final data = await _loadMockData();
      final initialLength = data.length;
      data.removeWhere((item) => item['id'] == itemId);

      // Return true if an item was removed
      return data.length < initialLength;
    } catch (e) {
      if (e is CacheFailure) {
        rethrow;
      }
      throw CacheFailure(message: 'Failed to remove item from library: ${e.toString()}');
    }
  }
}
