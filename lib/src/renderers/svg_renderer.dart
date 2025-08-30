import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../asset_config.dart';
import '../common_types.dart';
import 'error_renderer.dart';

/// Renderer for SVG assets using conditional imports
class SvgRenderer {
  /// Renders an SVG asset
  static Widget render({
    required String source,
    required CommonRenderParams params,
    SvgConfig? config,
  }) {
    try {
      // Try to use flutter_svg if available
      return _renderWithFlutterSvg(source, params, config);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SVG rendering failed: $e');
        debugPrint(
            'Make sure flutter_svg package is added to your pubspec.yaml');
      }

      return _buildSvgUnsupportedWidget(params, source);
    }
  }

  /// Attempts to render SVG using flutter_svg package
  static Widget _renderWithFlutterSvg(
    String source,
    CommonRenderParams params,
    SvgConfig? config,
  ) {
    // This will be replaced by conditional import logic
    // For now, we'll create a placeholder that shows the user needs flutter_svg
    return _buildSvgUnsupportedWidget(params, source);
  }

  /// Builds a widget indicating SVG support is not available
  static Widget _buildSvgUnsupportedWidget(
      CommonRenderParams params, String source) {
    if (params.errorWidget != null) {
      return params.errorWidget!;
    }

    return ErrorRenderer.build(
      message: 'SVG support not available.\nAdd flutter_svg to pubspec.yaml',
      width: params.width,
      height: params.height,
      icon: Icons.image_not_supported,
      showInstructions: true,
    );
  }
}

// This would be the actual implementation with conditional imports
// The pattern would be:
// 
// import 'svg_renderer_stub.dart'
//   if (dart.library.io) 'svg_renderer_io.dart'
//   if (dart.library.html) 'svg_renderer_web.dart';
//
// Where each implementation tries to import flutter_svg and falls back gracefully