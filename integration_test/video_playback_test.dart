import 'package:bluetube_app/app/app.dart';
import 'package:bluetube_app/app/di/dependency_injection.dart' as di;
import 'package:bluetube_app/features/home/presentation/screens/home_screen.dart';
import 'package:bluetube_app/features/home/presentation/widgets/video_card.dart';
import 'package:bluetube_app/features/video/presentation/screens/video_screen.dart';
import 'package:bluetube_app/features/video/presentation/widgets/custom_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await di.init();
  });

  testWidgets('Video playback flow test', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const BlueTubeApp());
    await tester.pumpAndSettle();

    // Verify that we are on the home screen
    expect(find.byType(HomeScreen), findsOneWidget);

    // Find and tap on a video card
    final videoCardFinder = find.byType(VideoCard).first;
    expect(videoCardFinder, findsOneWidget);
    await tester.tap(videoCardFinder);
    await tester.pumpAndSettle();

    // Verify that we navigated to the video screen
    expect(find.byType(VideoScreen), findsOneWidget);

    // Verify that the video player is displayed
    expect(find.byType(CustomVideoPlayer), findsOneWidget);

    // Verify that video details are displayed
    expect(find.text('Comments'), findsOneWidget);
    expect(find.text('Related Videos'), findsOneWidget);

    // Tap on the like button
    final likeButtonFinder = find.byIcon(Icons.thumb_up_outlined).first;
    expect(likeButtonFinder, findsOneWidget);
    await tester.tap(likeButtonFinder);
    await tester.pumpAndSettle();

    // Tap on the comments section to expand it
    final commentsSectionFinder = find.text('Comments');
    expect(commentsSectionFinder, findsOneWidget);
    await tester.tap(commentsSectionFinder);
    await tester.pumpAndSettle();

    // Enter a comment
    final commentFieldFinder = find.byType(TextField);
    expect(commentFieldFinder, findsOneWidget);
    await tester.enterText(commentFieldFinder, 'Great video!');
    await tester.pumpAndSettle();

    // Tap on the send button
    final sendButtonFinder = find.byIcon(Icons.send);
    expect(sendButtonFinder, findsOneWidget);
    await tester.tap(sendButtonFinder);
    await tester.pumpAndSettle();

    // Navigate back to the home screen
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Verify that we are back on the home screen
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
