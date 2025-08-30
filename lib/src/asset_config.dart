import 'package:flutter/widgets.dart';

/// Configuration class for Lottie animations
class LottieConfig {
  /// Animation playback speed (default: 1.0)
  final double speed;

  /// Whether to repeat the animation (default: true)
  final bool repeat;

  /// Whether to play animation in reverse (default: false)
  final bool reverse;

  /// Animation controller for custom control
  final AnimationController? controller;

  /// Callback when animation completes
  final VoidCallback? onLoaded;

  const LottieConfig({
    this.speed = 1.0,
    this.repeat = true,
    this.reverse = false,
    this.controller,
    this.onLoaded,
  });
}

/// Configuration class for Rive animations
class RiveConfig {
  /// Name of the artboard to display
  final String? artboard;

  /// State machine to control
  final String? stateMachine;

  /// Animation name to play
  final String? animation;

  /// Whether to auto-play the animation
  final bool autoplay;

  /// Callback when Rive file loads
  final VoidCallback? onInit;

  const RiveConfig({
    this.artboard,
    this.stateMachine,
    this.animation,
    this.autoplay = true,
    this.onInit,
  });
}

/// Configuration class for SVG rendering
class SvgConfig {
  /// Color to override SVG colors
  final Color? colorOverride;

  /// Whether to adapt to current theme
  final bool adaptToTheme;

  /// Color filter to apply
  final ColorFilter? colorFilter;

  /// Whether to allow drawing outside bounds
  final bool allowDrawingOutsideViewBox;

  const SvgConfig({
    this.colorOverride,
    this.adaptToTheme = false,
    this.colorFilter,
    this.allowDrawingOutsideViewBox = false,
  });
}

/// Configuration class for network images
class NetworkImageConfig {
  /// Whether to use caching (requires cached_network_image package)
  final bool useCache;

  /// Cache duration in seconds
  final int? maxCacheAge;

  /// Maximum cache size in bytes
  final int? maxCacheSize;

  /// HTTP headers for the request
  final Map<String, String>? headers;

  /// Connection timeout duration
  final Duration? timeout;

  const NetworkImageConfig({
    this.useCache = true,
    this.maxCacheAge,
    this.maxCacheSize,
    this.headers,
    this.timeout,
  });
}
