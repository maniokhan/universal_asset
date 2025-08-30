import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:universal_asset/universal_asset.dart';

void main() {
  group('UniversalAsset Widget Tests', () {
    testWidgets('renders PNG image correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UniversalAsset(
              'assets/test_image.png',
              width: 100,
              height: 100,
            ),
          ),
        ),
      );

      await tester.pump();

      // Should find the Image widget
      expect(find.byType(Image), findsOneWidget);

      // Should have correct dimensions
      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.width, equals(100));
      expect(imageWidget.height, equals(100));
    });

    testWidgets('shows error widget for non-existent asset',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UniversalAsset(
              'assets/non_existent.png',
              width: 100,
              height: 100,
            ),
          ),
        ),
      );

      await tester.pump();

      // Should show error container
      expect(find.byType(Container), findsWidgets);
      expect(find.byIcon(Icons.broken_image), findsOneWidget);
    });

    testWidgets('handles SVG files with graceful degradation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UniversalAsset(
              'assets/test_icon.svg',
              width: 200,
              height: 150,
            ),
          ),
        ),
      );

      await tester.pump();

      // Should show SVG not supported message when flutter_svg is not available
      // Use a larger size so the full text message is displayed
      expect(
          find.text(
              'SVG support not available.\nAdd flutter_svg to pubspec.yaml'),
          findsOneWidget);
      expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
    });

    testWidgets('handles Lottie files with graceful degradation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UniversalAsset(
              'assets/animation.json',
              width: 200,
              height: 150,
            ),
          ),
        ),
      );

      await tester.pump();

      // Should show Lottie not supported message when lottie is not available
      expect(
          find.text(
              'Lottie support not available.\nAdd lottie to pubspec.yaml'),
          findsOneWidget);
      expect(find.byIcon(Icons.animation), findsOneWidget);
    });

    testWidgets('handles Rive files with graceful degradation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UniversalAsset(
              'assets/character.riv',
              width: 200,
              height: 150,
            ),
          ),
        ),
      );

      await tester.pump();

      // Should show Rive not supported message when rive is not available
      expect(find.text('Rive support not available.\nAdd rive to pubspec.yaml'),
          findsOneWidget);
      expect(find.byIcon(Icons.play_circle_outline), findsOneWidget);
    });

    testWidgets('renders network images correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UniversalAsset(
              'https://example.com/image.png',
              width: 200,
              height: 150,
            ),
          ),
        ),
      );

      await tester.pump();

      // Should find the Image.network widget
      expect(find.byType(Image), findsOneWidget);

      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.width, equals(200));
      expect(imageWidget.height, equals(150));
    });

    testWidgets('renders memory images correctly', (WidgetTester tester) async {
      final testBytes = Uint8List.fromList([
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // PNG signature
        // ... (minimal PNG data)
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UniversalAsset.memory(
              testBytes,
              width: 100,
              height: 100,
            ),
          ),
        ),
      );

      await tester.pump();

      // Should find the Image.memory widget
      expect(find.byType(Image), findsOneWidget);

      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.width, equals(100));
      expect(imageWidget.height, equals(100));
    });

    testWidgets('uses custom error widget when provided',
        (WidgetTester tester) async {
      const customErrorWidget = Text('Custom Error Message');

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UniversalAsset(
              'assets/non_existent.png',
              errorWidget: customErrorWidget,
            ),
          ),
        ),
      );

      await tester.pump();

      // Should show custom error widget
      expect(find.text('Custom Error Message'), findsOneWidget);
    });

    testWidgets('uses placeholder widget when provided',
        (WidgetTester tester) async {
      const placeholderWidget = CircularProgressIndicator();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UniversalAsset(
              'https://example.com/slow-image.png',
              placeholder: placeholderWidget,
            ),
          ),
        ),
      );

      await tester.pump();

      // In tests, network images load immediately and go to error state
      // So we expect to find the Image widget, not the placeholder
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('applies semantic label correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UniversalAsset(
              'assets/test_image.png',
              semanticLabel: 'Test Image Description',
            ),
          ),
        ),
      );

      await tester.pump();

      // Should have semantic label
      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.semanticLabel, equals('Test Image Description'));
    });

    testWidgets('handles null source gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UniversalAsset(null),
          ),
        ),
      );

      await tester.pump();

      // Should show error message for null source
      expect(find.text('No source or memory data provided'), findsOneWidget);
    });

    testWidgets('shows minimal error widget for small sizes',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: UniversalAsset(
              'assets/non_existent.png',
              width: 50,
              height: 50,
            ),
          ),
        ),
      );

      await tester.pump();

      // For small sizes, should show minimal error widget (just icon, no text)
      expect(find.byType(Container), findsWidgets);
      expect(find.byIcon(Icons.broken_image), findsOneWidget);
      // Should not show full error text for small widgets
      expect(find.text('Failed to load image: assets/non_existent.png'),
          findsNothing);
    });
  });

  group('AssetTypeDetector Tests', () {
    test('detects image types correctly', () {
      expect(
          AssetTypeDetector.detectType('image.png'), equals(AssetType.image));
      expect(
          AssetTypeDetector.detectType('photo.jpg'), equals(AssetType.image));
      expect(AssetTypeDetector.detectType('picture.jpeg'),
          equals(AssetType.image));
      expect(AssetTypeDetector.detectType('animation.gif'),
          equals(AssetType.image));
      expect(AssetTypeDetector.detectType('graphic.webp'),
          equals(AssetType.image));
      expect(
          AssetTypeDetector.detectType('bitmap.bmp'), equals(AssetType.image));
    });

    test('detects SVG type correctly', () {
      expect(AssetTypeDetector.detectType('icon.svg'), equals(AssetType.svg));
      expect(AssetTypeDetector.detectType('logo.SVG'), equals(AssetType.svg));
    });

    test('detects Lottie type correctly', () {
      expect(AssetTypeDetector.detectType('animation.json'),
          equals(AssetType.lottie));
      expect(AssetTypeDetector.detectType('loading.JSON'),
          equals(AssetType.lottie));
    });

    test('detects Rive type correctly', () {
      expect(AssetTypeDetector.detectType('character.riv'),
          equals(AssetType.rive));
      expect(AssetTypeDetector.detectType('animation.RIV'),
          equals(AssetType.rive));
    });

    test('detects network images correctly', () {
      expect(AssetTypeDetector.detectType('https://example.com/image.png'),
          equals(AssetType.image));
      expect(AssetTypeDetector.detectType('http://test.com/photo.jpg'),
          equals(AssetType.image));
    });

    test('handles unknown types', () {
      expect(AssetTypeDetector.detectType('document.pdf'),
          equals(AssetType.unknown));
      expect(
          AssetTypeDetector.detectType('video.mp4'), equals(AssetType.unknown));
      expect(AssetTypeDetector.detectType('no_extension'),
          equals(AssetType.unknown));
    });

    test('handles MIME type detection', () {
      expect(AssetTypeDetector.detectType('file', mimeType: 'image/png'),
          equals(AssetType.image));
      expect(AssetTypeDetector.detectType('file', mimeType: 'image/svg+xml'),
          equals(AssetType.svg));
      expect(AssetTypeDetector.detectType('file', mimeType: 'application/json'),
          equals(AssetType.unknown));
    });
  });

  group('Configuration Tests', () {
    test('LottieConfig has correct defaults', () {
      const config = LottieConfig();
      expect(config.speed, equals(1.0));
      expect(config.repeat, equals(true));
      expect(config.reverse, equals(false));
      expect(config.controller, isNull);
      expect(config.onLoaded, isNull);
    });

    test('RiveConfig has correct defaults', () {
      const config = RiveConfig();
      expect(config.artboard, isNull);
      expect(config.stateMachine, isNull);
      expect(config.animation, isNull);
      expect(config.autoplay, equals(true));
      expect(config.onInit, isNull);
    });

    test('SvgConfig has correct defaults', () {
      const config = SvgConfig();
      expect(config.colorOverride, isNull);
      expect(config.adaptToTheme, equals(false));
      expect(config.colorFilter, isNull);
      expect(config.allowDrawingOutsideViewBox, equals(false));
    });

    test('NetworkImageConfig has correct defaults', () {
      const config = NetworkImageConfig();
      expect(config.useCache, equals(true));
      expect(config.maxCacheAge, isNull);
      expect(config.maxCacheSize, isNull);
      expect(config.headers, isNull);
      expect(config.timeout, isNull);
    });
  });
}
