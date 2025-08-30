/// Enumeration of supported asset types
enum AssetType {
  /// Standard image formats (PNG, JPG, JPEG, GIF, WebP, BMP)
  image,

  /// SVG vector graphics
  svg,

  /// Lottie animations (JSON format)
  lottie,

  /// Rive animations (.riv format)
  rive,

  /// Network images with caching
  networkImage,

  /// Memory-based assets (Uint8List)
  memory,

  /// Unknown or unsupported format
  unknown,
}

/// Utility class for detecting asset types
class AssetTypeDetector {
  /// Detects asset type based on file extension or MIME type
  static AssetType detectType(String source, {String? mimeType}) {
    // Check MIME type first if provided
    if (mimeType != null) {
      return _detectByMimeType(mimeType);
    }

    // Check if it's a network URL
    if (isNetworkUrl(source)) {
      final extension = _getFileExtension(source);
      return _detectByExtension(extension);
    }

    // Check file extension for local assets
    final extension = _getFileExtension(source);
    return _detectByExtension(extension);
  }

  /// Checks if source is a network URL
  static bool isNetworkUrl(String source) {
    return source.startsWith('http://') || source.startsWith('https://');
  }

  /// Extracts file extension from source path
  static String _getFileExtension(String source) {
    final uri = Uri.tryParse(source);
    final path = uri?.path ?? source;
    final lastDot = path.lastIndexOf('.');

    if (lastDot == -1 || lastDot == path.length - 1) {
      return '';
    }

    return path.substring(lastDot + 1).toLowerCase();
  }

  /// Detects asset type by file extension
  static AssetType _detectByExtension(String extension) {
    switch (extension) {
      case 'png':
      case 'jpg':
      case 'jpeg':
      case 'gif':
      case 'webp':
      case 'bmp':
        return AssetType.image;
      case 'svg':
        return AssetType.svg;
      case 'json':
        return AssetType.lottie;
      case 'riv':
        return AssetType.rive;
      default:
        return AssetType.unknown;
    }
  }

  /// Detects asset type by MIME type
  static AssetType _detectByMimeType(String mimeType) {
    final type = mimeType.toLowerCase();

    if (type.startsWith('image/')) {
      if (type == 'image/svg+xml') {
        return AssetType.svg;
      }
      return AssetType.image;
    }

    if (type == 'application/json' && type.contains('lottie')) {
      return AssetType.lottie;
    }

    return AssetType.unknown;
  }
}
