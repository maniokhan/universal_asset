import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'asset_type.dart';
import 'asset_config.dart';
import 'common_types.dart';
import 'renderers/image_renderer.dart';
import 'renderers/svg_renderer.dart';
import 'renderers/lottie_renderer.dart';
import 'renderers/rive_renderer.dart';
import 'renderers/network_image_renderer.dart';
import 'renderers/error_renderer.dart';

/// Common parameters for all renderers
class _CommonRenderParams {
  final double? width;
  final double? height;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final ColorFilter? colorFilter;
  final Widget? placeholder;
  final Widget? errorWidget;
  final String? semanticLabel;
  final bool excludeFromSemantics;

  const _CommonRenderParams({
    this.width,
    this.height,
    this.fit,
    required this.alignment,
    this.colorFilter,
    this.placeholder,
    this.errorWidget,
    this.semanticLabel,
    this.excludeFromSemantics = false,
  });
}

/// A universal widget for displaying different types of assets
///
/// Supports images, SVGs, Lottie animations, Rive animations, and network images
/// with automatic type detection and graceful fallback handling.
class UniversalAsset extends StatelessWidget {
  /// The source path or URL of the asset
  final String? source;

  /// Memory data for the asset (alternative to source)
  final Uint8List? memory;

  /// Width of the asset
  final double? width;

  /// Height of the asset
  final double? height;

  /// How the asset should fit within its bounds
  final BoxFit? fit;

  /// Alignment of the asset within its bounds
  final AlignmentGeometry alignment;

  /// Color filter to apply to the asset
  final ColorFilter? colorFilter;

  /// Widget to show while loading
  final Widget? placeholder;

  /// Widget to show when an error occurs
  final Widget? errorWidget;

  /// MIME type hint for better type detection
  final String? mimeType;

  /// Configuration for Lottie animations
  final LottieConfig? lottieConfig;

  /// Configuration for Rive animations
  final RiveConfig? riveConfig;

  /// Configuration for SVG rendering
  final SvgConfig? svgConfig;

  /// Configuration for network images
  final NetworkImageConfig? networkConfig;

  /// Semantic label for accessibility
  final String? semanticLabel;

  /// Whether to exclude from semantics tree
  final bool excludeFromSemantics;

  const UniversalAsset(
    this.source, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.colorFilter,
    this.placeholder,
    this.errorWidget,
    this.mimeType,
    this.lottieConfig,
    this.riveConfig,
    this.svgConfig,
    this.networkConfig,
    this.semanticLabel,
    this.excludeFromSemantics = false,
  }) : memory = null;

  /// Creates a UniversalAsset from memory data
  const UniversalAsset.memory(
    this.memory, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.colorFilter,
    this.placeholder,
    this.errorWidget,
    this.mimeType,
    this.lottieConfig,
    this.riveConfig,
    this.svgConfig,
    this.networkConfig,
    this.semanticLabel,
    this.excludeFromSemantics = false,
  }) : source = null;

  @override
  Widget build(BuildContext context) {
    // Validate input
    if (source == null && memory == null) {
      return _buildErrorWidget('No source or memory data provided');
    }

    try {
      final assetType = _detectAssetType();
      return _buildAssetWidget(context, assetType);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('UniversalAsset error: $e');
        debugPrint('Stack trace: $stackTrace');
      }
      return _buildErrorWidget('Failed to load asset: $e');
    }
  }

  /// Detects the type of asset based on source or memory data
  AssetType _detectAssetType() {
    if (memory != null) {
      return AssetType.memory;
    }

    if (source != null) {
      if (AssetTypeDetector.isNetworkUrl(source!)) {
        final detectedType =
            AssetTypeDetector.detectType(source!, mimeType: mimeType);
        return detectedType == AssetType.image
            ? AssetType.networkImage
            : detectedType;
      }
      return AssetTypeDetector.detectType(source!, mimeType: mimeType);
    }

    return AssetType.unknown;
  }

  /// Builds the appropriate widget based on asset type
  Widget _buildAssetWidget(BuildContext context, AssetType assetType) {
    final commonParams = CommonRenderParams(
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      colorFilter: colorFilter,
      placeholder: placeholder,
      errorWidget: errorWidget,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
    );

    switch (assetType) {
      case AssetType.image:
        return ImageRenderer.render(
          source: source!,
          params: commonParams,
        );

      case AssetType.svg:
        return SvgRenderer.render(
          source: source!,
          params: commonParams,
          config: svgConfig,
        );

      case AssetType.lottie:
        return LottieRenderer.render(
          source: source!,
          params: commonParams,
          config: lottieConfig,
        );

      case AssetType.rive:
        return RiveRenderer.render(
          source: source!,
          params: commonParams,
          config: riveConfig,
        );

      case AssetType.networkImage:
        return NetworkImageRenderer.render(
          source: source!,
          params: commonParams,
          config: networkConfig,
        );

      case AssetType.memory:
        return ImageRenderer.renderMemory(
          memory: memory!,
          params: commonParams,
        );

      case AssetType.unknown:
      default:
        return _buildErrorWidget(
            'Unsupported asset type: ${source ?? 'memory'}');
    }
  }

  /// Builds error widget with fallback
  Widget _buildErrorWidget(String message) {
    if (errorWidget != null) {
      return errorWidget!;
    }

    return ErrorRenderer.build(
      message: message,
      width: width,
      height: height,
    );
  }
}
