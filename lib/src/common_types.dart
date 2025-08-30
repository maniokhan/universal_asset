import 'package:flutter/widgets.dart';

/// Common parameters shared across all asset renderers
class CommonRenderParams {
  final double? width;
  final double? height;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final ColorFilter? colorFilter;
  final Widget? placeholder;
  final Widget? errorWidget;
  final String? semanticLabel;
  final bool excludeFromSemantics;

  const CommonRenderParams({
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
