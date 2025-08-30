import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common_types.dart';
import 'error_renderer.dart';

/// Renderer for standard image assets (PNG, JPG, etc.)
class ImageRenderer {
  /// Renders a local image asset
  static Widget render({
    required String source,
    required CommonRenderParams params,
  }) {
    try {
      Widget imageWidget = Image.asset(
        source,
        width: params.width,
        height: params.height,
        fit: params.fit,
        alignment: params.alignment,
        semanticLabel: params.semanticLabel,
        excludeFromSemantics: params.excludeFromSemantics,
        errorBuilder: (context, error, stackTrace) {
          if (kDebugMode) {
            debugPrint('Image asset error: $error');
          }
          return params.errorWidget ??
              ErrorRenderer.build(
                message: 'Failed to load image: $source',
                width: params.width,
                height: params.height,
              );
        },
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) {
            return child;
          }

          if (params.placeholder != null) {
            return params.placeholder!;
          }

          return SizedBox(
            width: params.width,
            height: params.height,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );

      // Apply color filter if provided
      if (params.colorFilter != null) {
        imageWidget = ColorFiltered(
          colorFilter: params.colorFilter!,
          child: imageWidget,
        );
      }

      return imageWidget;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Image renderer error: $e');
      }
      return params.errorWidget ??
          ErrorRenderer.build(
            message: 'Image rendering failed',
            width: params.width,
            height: params.height,
          );
    }
  }

  /// Renders an image from memory data
  static Widget renderMemory({
    required Uint8List memory,
    required CommonRenderParams params,
  }) {
    try {
      Widget imageWidget = Image.memory(
        memory,
        width: params.width,
        height: params.height,
        fit: params.fit,
        alignment: params.alignment,
        semanticLabel: params.semanticLabel,
        excludeFromSemantics: params.excludeFromSemantics,
        errorBuilder: (context, error, stackTrace) {
          if (kDebugMode) {
            debugPrint('Memory image error: $error');
          }
          return params.errorWidget ??
              ErrorRenderer.build(
                message: 'Failed to load memory image',
                width: params.width,
                height: params.height,
              );
        },
      );

      // Apply color filter if provided
      if (params.colorFilter != null) {
        imageWidget = ColorFiltered(
          colorFilter: params.colorFilter!,
          child: imageWidget,
        );
      }

      return imageWidget;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Memory image renderer error: $e');
      }
      return params.errorWidget ??
          ErrorRenderer.build(
            message: 'Memory image rendering failed',
            width: params.width,
            height: params.height,
          );
    }
  }
}
