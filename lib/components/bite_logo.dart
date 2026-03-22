import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class BiteLogo extends StatelessWidget {
  const BiteLogo({
    super.key,
    this.fontSize = 22.0,
    this.fontWeight = FontWeight.bold,
    this.opacity = 1.0,
  });

  final double fontSize;
  final FontWeight fontWeight;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final style = theme.headlineMedium.override(
      fontFamily: theme.headlineMediumFamily,
      fontSize: fontSize,
      letterSpacing: 0.0,
      fontWeight: fontWeight,
      useGoogleFonts: !theme.headlineMediumIsCustom,
    );

    return Opacity(
      opacity: opacity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('b', style: style.copyWith(color: theme.primary)),
          Text('i', style: style.copyWith(color: theme.secondary)),
          Text('t', style: style.copyWith(color: theme.accent1)),
          Text('e', style: style.copyWith(color: theme.tertiary)),
        ],
      ),
    );
  }
}
