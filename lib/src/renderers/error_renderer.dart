import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Renderer for error states and unsupported asset types
class ErrorRenderer {
  /// Builds a standardized error widget
  static Widget build({
    required String message,
    double? width,
    double? height,
    IconData? icon,
    bool showInstructions = false,
  }) {
    // Use minimal error widget for very small sizes
    if ((width != null && width < 150) || (height != null && height < 150)) {
      return buildMinimal(
        width: width,
        height: height,
        icon: icon,
      );
    }

    return Container(
      width: width,
      height: height,
      constraints: const BoxConstraints(
        minWidth: 100,
        minHeight: 100,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade300,
          style: BorderStyle.solid,
          width: 1,
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon ?? Icons.broken_image,
                size: _getIconSize(width, height),
                color: Colors.grey.shade600,
              ),
              const SizedBox(height: 4),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: _getTextSize(width, height),
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (showInstructions && kDebugMode) ...[
                const SizedBox(height: 4),
                Text(
                  'See docs for setup',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: _getTextSize(width, height) - 1,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a minimal error widget for smaller sizes
  static Widget buildMinimal({
    double? width,
    double? height,
    IconData? icon,
  }) {
    return Container(
      width: width,
      height: height,
      constraints: const BoxConstraints(
        minWidth: 24,
        minHeight: 24,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Icon(
          icon ?? Icons.broken_image,
          size: _getIconSize(width, height),
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  /// Gets appropriate icon size based on container dimensions
  static double _getIconSize(double? width, double? height) {
    if (width == null && height == null) return 32;

    final size = width != null && height != null
        ? (width < height ? width : height)
        : (width ?? height!);

    if (size < 50) return size * 0.4;
    if (size < 100) return size * 0.3;
    return 32;
  }

  /// Gets appropriate text size based on container dimensions
  static double _getTextSize(double? width, double? height) {
    if (width == null && height == null) return 12;

    final size = width != null && height != null
        ? (width < height ? width : height)
        : (width ?? height!);

    if (size < 100) return 8;
    if (size < 150) return 10;
    return 12;
  }
}
