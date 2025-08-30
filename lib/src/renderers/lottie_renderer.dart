import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../asset_config.dart';
import '../common_types.dart';
import 'error_renderer.dart';

/// Renderer for Lottie animations using conditional imports
class LottieRenderer {
  /// Renders a Lottie animation asset
  static Widget render({
    required String source,
    required CommonRenderParams params,
    LottieConfig? config,
  }) {
    try {
      // Try to use lottie package if available
      return _renderWithLottie(source, params, config);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Lottie rendering failed: $e');
        debugPrint('Make sure lottie package is added to your pubspec.yaml');
      }

      return _buildLottieUnsupportedWidget(params, source);
    }
  }

  /// Attempts to render Lottie using lottie package
  static Widget _renderWithLottie(
    String source,
    CommonRenderParams params,
    LottieConfig? config,
  ) {
    // This will be replaced by conditional import logic
    // For now, we'll create a placeholder that shows the user needs lottie
    return _buildLottieUnsupportedWidget(params, source);
  }

  /// Builds a widget indicating Lottie support is not available
  static Widget _buildLottieUnsupportedWidget(
      CommonRenderParams params, String source) {
    if (params.errorWidget != null) {
      return params.errorWidget!;
    }

    return ErrorRenderer.build(
      message: 'Lottie support not available.\nAdd lottie to pubspec.yaml',
      width: params.width,
      height: params.height,
      icon: Icons.animation,
      showInstructions: true,
    );
  }
}

// This would be the actual implementation with conditional imports:
//
// The actual implementation would use:
// import 'lottie_renderer_stub.dart'
//   if (dart.library.io) 'lottie_renderer_impl.dart';
//
// Where lottie_renderer_impl.dart would contain:
/*
import 'package:lottie/lottie.dart';

static Widget _renderWithLottie(
  String source,
  _CommonRenderParams params,
  LottieConfig? config,
) {
  final effectiveConfig = config ?? const LottieConfig();
  
  return Lottie.asset(
    source,
    width: params.width,
    height: params.height,
    fit: params.fit ?? BoxFit.contain,
    alignment: params.alignment,
    repeat: effectiveConfig.repeat,
    reverse: effectiveConfig.reverse,
    controller: effectiveConfig.controller,
    onLoaded: (composition) {
      effectiveConfig.onLoaded?.call();
    },
    errorBuilder: (context, error, stackTrace) {
      if (kDebugMode) {
        debugPrint('Lottie error: $error');
      }
      return params.errorWidget ?? ErrorRenderer.build(
        message: 'Failed to load Lottie animation',
        width: params.width,
        height: params.height,
      );
    },
  );
}
*/