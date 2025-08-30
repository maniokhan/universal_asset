Changelog
All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog, and this project adheres to Semantic Versioning.

[1.0.0] - 2024-01-15
Added
Initial release of UniversalAsset package
Support for multiple asset types:
Standard images (PNG, JPG, JPEG, GIF, WebP, BMP)
SVG vector graphics
Lottie animations (JSON)
Rive animations (.riv)
Network images with caching
Memory-based assets (Uint8List)
Automatic asset type detection based on file extensions and MIME types
Graceful degradation when optional dependencies are missing
Comprehensive configuration options:
LottieConfig for animation control
RiveConfig for artboard and state machine control
SvgConfig for color override and theme adaptation
NetworkImageConfig for caching and network settings
Error handling with customizable error widgets
Placeholder support for loading states
Full accessibility support with semantic labels
Comprehensive documentation and examples
Complete test suite with widget and unit tests
Demo app showcasing all features
Features
Lightweight: Core package has minimal dependencies
Modular: Optional imports prevent bloating your app
Safe: Null-safe implementation with comprehensive error handling
Performant: Efficient rendering with proper caching
Accessible: Full support for screen readers and accessibility
Customizable: Extensive configuration options for all asset types
Developer-friendly: Clear error messages and debugging support
Documentation
Comprehensive README with usage examples
Inline code documentation for all public APIs
Example app demonstrating all features
Setup instructions for optional dependencies
Migration guide and best practices
Testing
Unit tests for asset type detection
Widget tests for rendering behavior
Configuration tests for all config classes
Error handling tests
Memory asset tests
