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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.broken_image,
            size: 48,
            color: Colors.grey.shade600,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (showInstructions && kDebugMode) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'See universal_asset documentation for setup instructions',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
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
      child: Icon(
        icon ?? Icons.broken_image,
        size: (width != null && height != null)
            ? (width < height ? width : height) * 0.6
            : 16,
        color: Colors.grey.shade600,
      ),
    );
  }
}
