import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../asset_config.dart';
import '../common_types.dart';
import 'error_renderer.dart';

/// Renderer for network images with optional caching
class NetworkImageRenderer {
  /// Renders a network image with optional caching
  static Widget render({
    required String source,
    required CommonRenderParams params,
    NetworkImageConfig? config,
  }) {
    try {
      final effectiveConfig = config ?? const NetworkImageConfig();

      if (effectiveConfig.useCache) {
        // Try to use cached_network_image if available
        return _renderWithCachedNetworkImage(source, params, effectiveConfig);
      } else {
        // Use standard Image.network
        return _renderWithStandardNetworkImage(source, params, effectiveConfig);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Network image rendering failed: $e');
      }

      return params.errorWidget ??
          ErrorRenderer.build(
            message: 'Failed to load network image',
            width: params.width,
            height: params.height,
          );
    }
  }

  /// Renders network image using standard Image.network
  static Widget _renderWithStandardNetworkImage(
    String source,
    CommonRenderParams params,
    NetworkImageConfig config,
  ) {
    Widget imageWidget = Image.network(
      source,
      width: params.width,
      height: params.height,
      fit: params.fit,
      alignment: params.alignment,
      semanticLabel: params.semanticLabel,
      excludeFromSemantics: params.excludeFromSemantics,
      headers: config.headers,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        if (params.placeholder != null) {
          return params.placeholder!;
        }

        return SizedBox(
          width: params.width,
          height: params.height,
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        if (kDebugMode) {
          debugPrint('Network image error: $error');
        }
        return params.errorWidget ??
            ErrorRenderer.build(
              message: 'Failed to load network image',
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
  }

  /// Attempts to render network image using cached_network_image
  static Widget _renderWithCachedNetworkImage(
    String source,
    CommonRenderParams params,
    NetworkImageConfig config,
  ) {
    // This would use conditional imports to check for cached_network_image
    // For now, fall back to standard network image
    if (kDebugMode) {
      debugPrint('Cached network images require cached_network_image package');
    }

    return _renderWithStandardNetworkImage(source, params, config);
  }
}

// This would be the actual implementation with conditional imports:
//
// import 'network_image_renderer_stub.dart'
//   if (dart.library.io) 'network_image_renderer_impl.dart';
//
// Where network_image_renderer_impl.dart would contain:
/*
import 'package:cached_network_image/cached_network_image.dart';

static Widget _renderWithCachedNetworkImage(
  String source,
  _CommonRenderParams params,
  NetworkImageConfig config,
) {
  return CachedNetworkImage(
    imageUrl: source,
    width: params.width,
    height: params.height,
    fit: params.fit,
    alignment: params.alignment,
    colorFilter: params.colorFilter,
    httpHeaders: config.headers,
    maxHeightDiskCache: config.maxCacheSize,
    maxWidthDiskCache: config.maxCacheSize,
    placeholder: (context, url) {
      return params.placeholder ?? SizedBox(
        width: params.width,
        height: params.height,
        child: const Center(child: CircularProgressIndicator()),
      );
    },
    errorWidget: (context, url, error) {
      if (kDebugMode) {
        debugPrint('Cached network image error: $error');
      }
      return params.errorWidget ?? ErrorRenderer.build(
        message: 'Failed to load cached network image',
        width: params.width,
        height: params.height,
      );
    },
  );
}
*/