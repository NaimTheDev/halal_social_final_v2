import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Reusable Connectly logo widget with different variants
class ConnectlyLogo extends StatelessWidget {
  const ConnectlyLogo({
    super.key,
    this.height,
    this.width,
    this.variant = ConnectlyLogoVariant.full,
    this.forDarkBackground = false,
  });

  final double? height;
  final double? width;
  final ConnectlyLogoVariant variant;
  final bool forDarkBackground;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final useWhiteVersion = forDarkBackground || isDarkTheme;

    String assetPath;

    switch (variant) {
      case ConnectlyLogoVariant.full:
        assetPath =
            useWhiteVersion
                ? 'assets/images/logo/connectly_logo_white.png'
                : 'assets/images/logo/connectly_logo.png';
        break;
      case ConnectlyLogoVariant.iconOnly:
        assetPath = 'assets/images/logo/connectly_icon.svg';
        break;
    }

    // Determine if we're dealing with an SVG file
    final isSvg = assetPath.toLowerCase().endsWith('.svg');

    return isSvg
        ? SvgPicture.asset(
          assetPath,
          height: height,
          width: width,
          fit: BoxFit.contain,
          placeholderBuilder: (context) => _buildFallback(useWhiteVersion),
        )
        : Image.asset(
          assetPath,
          height: height,
          width: width,
          fit: BoxFit.contain,
          errorBuilder:
              (context, error, stackTrace) => _buildFallback(useWhiteVersion),
        );
  }

  Widget _buildFallback(bool useWhiteVersion) {
    return Container(
      height: height ?? 40,
      width: width,
      decoration: BoxDecoration(
        color: useWhiteVersion ? Colors.white : const Color(0xFFFF8C00),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          variant == ConnectlyLogoVariant.iconOnly ? 'C' : 'Connectly',
          style: TextStyle(
            color: useWhiteVersion ? const Color(0xFFFF8C00) : Colors.white,
            fontSize: variant == ConnectlyLogoVariant.iconOnly ? 16 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// Available logo variants
enum ConnectlyLogoVariant {
  /// Full logo with text
  full,

  /// Icon-only version (square format)
  iconOnly,
}
