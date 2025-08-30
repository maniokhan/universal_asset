import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../asset_config.dart';
import '../common_types.dart';
import 'error_renderer.dart';

/// Renderer for Rive animations using conditional imports
class RiveRenderer {
  /// Renders a Rive animation asset
  static Widget render({
    required String source,
    required CommonRenderParams params,
    RiveConfig? config,
  }) {
    try {
      // Try to use rive package if available
      return _renderWithRive(source, params, config);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Rive rendering failed: $e');
        debugPrint('Make sure rive package is added to your pubspec.yaml');
      }

      return _buildRiveUnsupportedWidget(params, source);
    }
  }

  /// Attempts to render Rive using rive package
  static Widget _renderWithRive(
    String source,
    CommonRenderParams params,
    RiveConfig? config,
  ) {
    // This will be replaced by conditional import logic
    // For now, we'll create a placeholder that shows the user needs rive
    return _buildRiveUnsupportedWidget(params, source);
  }

  /// Builds a widget indicating Rive support is not available
  static Widget _buildRiveUnsupportedWidget(
      CommonRenderParams params, String source) {
    if (params.errorWidget != null) {
      return params.errorWidget!;
    }

    return ErrorRenderer.build(
      message: 'Rive support not available.\nAdd rive to pubspec.yaml',
      width: params.width,
      height: params.height,
      icon: Icons.play_circle_outline,
      showInstructions: true,
    );
  }
}

// This would be the actual implementation with conditional imports:
//
// import 'rive_renderer_stub.dart'
//   if (dart.library.io) 'rive_renderer_impl.dart';
//
// Where rive_renderer_impl.dart would contain:
/*
import 'package:rive/rive.dart';

static Widget _renderWithRive(
  String source,
  _CommonRenderParams params,
  RiveConfig? config,
) {
  final effectiveConfig = config ?? const RiveConfig();
  
  return RiveAnimation.asset(
    source,
    artboard: effectiveConfig.artboard,
    animations: effectiveConfig.animation != null ? [effectiveConfig.animation!] : null,
    stateMachines: effectiveConfig.stateMachine != null ? [effectiveConfig.stateMachine!] : null,
    fit: params.fit ?? BoxFit.contain,
    alignment: params.alignment,
    placeHolder: params.placeholder,
    antialiasing: true,
    onInit: (artboard) {
      effectiveConfig.onInit?.call();
    },
  );
}
*/