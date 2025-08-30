# Universal Asset

A lightweight, modular Flutter package for displaying different types of assets (images, SVGs, Lottie animations, Rive animations) using a single widget with automatic type detection and graceful fallback handling.

<!-- [![pub package](https://img.shields.io/pub/v/universal_asset.svg)](https://pub.dev/packages/universal_asset)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) -->

## Features

- 🎯 **Single Widget**: Use `UniversalAsset` for all asset types
- 🚀 **Automatic Detection**: File type detection based on extensions and MIME types
- 📦 **Modular Dependencies**: Optional imports - only add what you need
- 🛡️ **Graceful Degradation**: Fallback widgets when dependencies are missing
- 🎨 **Highly Customizable**: Extensive configuration options for each asset type
- 🔍 **Error Handling**: Comprehensive error handling with debugging support
- ♿ **Accessibility**: Full semantic support for screen readers
- 💾 **Memory Support**: Load assets from memory (Uint8List)

## Supported Asset Types

| Type               | Extensions                                       | Package Required                  | Features                                           |
| ------------------ | ------------------------------------------------ | --------------------------------- | -------------------------------------------------- |
| **Images**         | `.png`, `.jpg`, `.jpeg`, `.gif`, `.webp`, `.bmp` | None (Flutter built-in)           | Placeholder, error handling, color filters         |
| **SVG**            | `.svg`                                           | `flutter_svg`                     | Color override, theme adaptation, color filters    |
| **Lottie**         | `.json`                                          | `lottie`                          | Speed control, repeat, reverse, custom controllers |
| **Rive**           | `.riv`                                           | `rive`                            | Artboard selection, state machines, animations     |
| **Network Images** | Any image URL                                    | `cached_network_image` (optional) | Caching, headers, timeout configuration            |
| **Memory**         | `Uint8List`                                      | None                              | Direct memory rendering                            |

## Installation

Add `universal_asset` to your `pubspec.yaml`:

```yaml
dependencies:
  universal_asset: ^1.0.0
```

### Optional Dependencies

Add only the packages you need:

```yaml
dependencies:
  # For SVG support
  flutter_svg: ^2.0.9

  # For Lottie animations
  lottie: ^3.0.0

  # For Rive animations
  rive: ^0.12.0

  # For cached network images
  cached_network_image: ^3.3.0
```

## Basic Usage

```dart
import 'package:universal_asset/universal_asset.dart';

// Automatic type detection
UniversalAsset('assets/logo.png')
UniversalAsset('assets/icon.svg')
UniversalAsset('assets/animation.json')  // Lottie
UniversalAsset('assets/character.riv')   // Rive
UniversalAsset('https://example.com/image.png')

// From memory
UniversalAsset.memory(uint8ListData)

// With sizing
UniversalAsset(
  'assets/logo.png',
  width: 200,
  height: 100,
  fit: BoxFit.cover,
)
```

## Advanced Configuration

### Lottie Animations

```dart
UniversalAsset(
  'assets/loading.json',
  lottieConfig: LottieConfig(
    speed: 1.5,
    repeat: true,
    reverse: false,
    onLoaded: () => print('Lottie loaded!'),
  ),
)
```

### Rive Animations

```dart
UniversalAsset(
  'assets/character.riv',
  riveConfig: RiveConfig(
    artboard: 'MainArtboard',
    stateMachine: 'StateMachine',
    autoplay: true,
    onInit: () => print('Rive initialized!'),
  ),
)
```

### SVG Customization

```dart
UniversalAsset(
  'assets/icon.svg',
  svgConfig: SvgConfig(
    colorOverride: Colors.blue,
    adaptToTheme: true,
    colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
  ),
)
```

### Network Images

```dart
UniversalAsset(
  'https://example.com/image.jpg',
  networkConfig: NetworkImageConfig(
    useCache: true,
    headers: {'Authorization': 'Bearer token'},
    timeout: Duration(seconds: 30),
  ),
  placeholder: CircularProgressIndicator(),
  errorWidget: Icon(Icons.error),
)
```

## Error Handling

When a required package is missing, UniversalAsset shows a helpful error widget:

```dart
// If flutter_svg is not installed
UniversalAsset('assets/icon.svg')
// Shows: "SVG support not available. Add flutter_svg to pubspec.yaml"
```

### Custom Error Widgets

```dart
UniversalAsset(
  'invalid/path.png',
  errorWidget: Container(
    child: Text('Custom Error Message'),
  ),
)
```

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:universal_asset/universal_asset.dart';

class AssetGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Universal Asset Demo')),
      body: Column(
        children: [
          // Standard image
          UniversalAsset(
            'assets/photo.jpg',
            width: 200,
            height: 150,
            fit: BoxFit.cover,
          ),

          // SVG with color override
          UniversalAsset(
            'assets/icon.svg',
            width: 48,
            height: 48,
            svgConfig: SvgConfig(
              colorOverride: Theme.of(context).primaryColor,
            ),
          ),

          // Lottie animation
          UniversalAsset(
            'assets/loading.json',
            width: 100,
            height: 100,
            lottieConfig: LottieConfig(
              repeat: true,
              speed: 1.2,
            ),
          ),

          // Network image with caching
          UniversalAsset(
            'https://picsum.photos/200/200',
            width: 200,
            height: 200,
            networkConfig: NetworkImageConfig(
              useCache: true,
            ),
            placeholder: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
```

## API Reference

### UniversalAsset

| Parameter              | Type                  | Description                         |
| ---------------------- | --------------------- | ----------------------------------- |
| `source`               | `String?`             | Asset path or URL                   |
| `memory`               | `Uint8List?`          | Memory data (alternative to source) |
| `width`                | `double?`             | Asset width                         |
| `height`               | `double?`             | Asset height                        |
| `fit`                  | `BoxFit?`             | How asset fits within bounds        |
| `alignment`            | `AlignmentGeometry`   | Asset alignment (default: center)   |
| `colorFilter`          | `ColorFilter?`        | Color filter to apply               |
| `placeholder`          | `Widget?`             | Loading placeholder                 |
| `errorWidget`          | `Widget?`             | Error fallback widget               |
| `mimeType`             | `String?`             | MIME type hint for detection        |
| `lottieConfig`         | `LottieConfig?`       | Lottie-specific configuration       |
| `riveConfig`           | `RiveConfig?`         | Rive-specific configuration         |
| `svgConfig`            | `SvgConfig?`          | SVG-specific configuration          |
| `networkConfig`        | `NetworkImageConfig?` | Network image configuration         |
| `semanticLabel`        | `String?`             | Accessibility label                 |
| `excludeFromSemantics` | `bool`                | Exclude from accessibility tree     |

## Testing

Run tests with:

```bash
flutter test
```

The package includes comprehensive tests for:

- Asset type detection
- Widget rendering
- Error handling
- Configuration options

## Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup

1. Clone the repository
2. Run `flutter pub get`
3. Add optional dependencies for testing:
   ```bash
   flutter pub add --dev flutter_svg lottie rive cached_network_image
   ```
4. Run tests: `flutter test`
5. Run the example app: `cd example && flutter run`

## Roadmap

- [ ] Video asset support
- [ ] GIF animation controls
- [ ] 3D model support (glTF)
- [ ] PDF rendering support
- [ ] Custom asset type plugins
- [ ] Performance optimizations
- [ ] Web-specific optimizations

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📖 [Documentation](https://pub.dev/packages/universal_asset)
- 🐛 [Issue Tracker](https://github.com/maniokhan/universal_asset/issues)
<!-- - 💬 [Discussions](https://github.com/maniokhan/universal_asset/discussions) -->

---

**Made with ❤️ for the Flutter community**
