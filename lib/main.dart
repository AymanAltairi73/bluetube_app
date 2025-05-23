import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'app/app.dart';
import 'app/di/dependency_injection.dart' as di;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase Auth persistence is enabled by default

  // Initialize GetStorage for theme persistence
  await GetStorage.init();

  // Initialize dependencies
  await di.init();

  runApp(const BlueTubeApp());
}