import 'package:flutter/material.dart';
import '../../../../core/widgets/bluetube_app_bar.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BlueTubeAppBar(
        title: 'Create',
        showLogo: false,
      ),
      body: const Center(
        child: Text('Upload Screen - Migrated to Clean Architecture'),
      ),
    );
  }
}
