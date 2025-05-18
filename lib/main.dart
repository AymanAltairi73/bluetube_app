import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'app/app.dart';
import 'app/di/dependency_injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage for theme persistence
  await GetStorage.init();

  // Initialize dependencies
  await di.init();

  runApp(const BlueTubeApp());
}