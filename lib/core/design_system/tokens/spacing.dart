class AppSpacing {
  AppSpacing._();

  // Base spacing unit (4px)
  static const double unit = 4.0;

  // Spacing scale
  static const double xs = unit; // 4px
  static const double sm = unit * 2; // 8px
  static const double md = unit * 3; // 12px
  static const double lg = unit * 4; // 16px
  static const double xl = unit * 5; // 20px
  static const double xxl = unit * 6; // 24px
  static const double xxxl = unit * 8; // 32px
  static const double huge = unit * 12; // 48px
  static const double massive = unit * 16; // 64px

  // Semantic spacing
  static const double elementSpacing = md; // 12px - between related elements
  static const double sectionSpacing = xl; // 20px - between sections
  static const double pageSpacing = xxl; // 24px - page margins
  static const double componentSpacing =
      lg; // 16px - component internal spacing

  // Grid spacing
  static const double gridSpacing = lg; // 16px
  static const double gridItemSpacing = md; // 12px

  // Card spacing
  static const double cardPadding = lg; // 16px
  static const double cardMargin = md; // 12px

  // Button spacing
  static const double buttonPaddingHorizontal = xl; // 20px
  static const double buttonPaddingVertical = md; // 12px
  static const double buttonSpacing = md; // 12px between buttons

  // List spacing
  static const double listItemSpacing = lg; // 16px
  static const double listItemPadding = lg; // 16px
  static const double listSectionSpacing = xxl; // 24px

  // Form spacing
  static const double formFieldSpacing = lg; // 16px
  static const double formSectionSpacing = xxl; // 24px
  static const double formPadding = xl; // 20px

  // Icon spacing
  static const double iconSpacing = sm; // 8px
  static const double iconPadding = xs; // 4px

  // Responsive spacing helpers
  static double responsive(
    double base, {
    double? tablet,
    double? desktop,
  }) {
    // This would be used with MediaQuery in actual widgets
    return base; // Default implementation
  }
}
