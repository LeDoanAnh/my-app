import 'package:flutter/material.dart';
import 'package:my_app/l10n/ui_text.dart';

class AppLogoWidget extends StatelessWidget {
  final double sizeMultiplier;
  final bool showShadow;
  final bool showSlogan;

  const AppLogoWidget({
    super.key,
    this.sizeMultiplier = 1.0,
    this.showShadow = true,
    this.showSlogan = true,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1E3A8A);

    double iconCircleSize = 60.0 * sizeMultiplier;
    double iconSize = 35.0 * sizeMultiplier;
    double fontSize = 24.0 * sizeMultiplier;
    double sloganFontSize = 10.0 * sizeMultiplier;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon bọc tròn
        Container(
          padding: EdgeInsets.all(15 * sizeMultiplier),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: showShadow
                ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.15),
                      blurRadius: 20 * sizeMultiplier,
                      offset: Offset(0, 8 * sizeMultiplier),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            Icons.assignment_turned_in_rounded,
            size: iconSize,
            color: primaryColor,
          ),
        ),
        SizedBox(height: 12 * sizeMultiplier),

        // Tên MyApp
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: fontSize,
              letterSpacing: 1.2 * sizeMultiplier,
              color: primaryColor,
            ),
            children: const [
              TextSpan(
                text: "My",
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
              TextSpan(
                text: "App",
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),

        if (showSlogan) ...[
          SizedBox(height: 4 * sizeMultiplier),
          TrText(
            "E-SUBMISSION SYSTEM",
            style: TextStyle(
              fontSize: sloganFontSize,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5 * sizeMultiplier,
              color: primaryColor.withOpacity(0.6),
            ),
          ),
        ],
      ],
    );
  }
}
