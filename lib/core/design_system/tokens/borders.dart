import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class AppBorders {
  AppBorders._();

  // Border radius values
  static const double radiusXs = 4.0;
  static const double radiusSm = AppConstants.smallBorderRadius; // 8.0
  static const double radiusMd = AppConstants.defaultBorderRadius; // 12.0
  static const double radiusLg = AppConstants.largeBorderRadius; // 16.0
  static const double radiusXl = 20.0;
  static const double radiusXxl = 24.0;
  static const double radiusRound = 999.0; // For fully rounded elements

  // Border radius objects
  static const BorderRadius roundedXs =
      BorderRadius.all(Radius.circular(radiusXs));
  static const BorderRadius roundedSm =
      BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius roundedMd =
      BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius roundedLg =
      BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius roundedXl =
      BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius roundedXxl =
      BorderRadius.all(Radius.circular(radiusXxl));
  static const BorderRadius roundedFull =
      BorderRadius.all(Radius.circular(radiusRound));

  // Semantic border radius
  static const BorderRadius button = roundedMd;
  static const BorderRadius card = roundedLg;
  static const BorderRadius dialog = roundedXl;
  static const BorderRadius bottomSheet = BorderRadius.only(
    topLeft: Radius.circular(radiusXl),
    topRight: Radius.circular(radiusXl),
  );
  static const BorderRadius avatar = roundedFull;
  static const BorderRadius chip = roundedFull;
  static const BorderRadius input = roundedMd;

  // Border widths
  static const double borderWidthThin = 0.5;
  static const double borderWidthDefault = 1.0;
  static const double borderWidthThick = 2.0;
  static const double borderWidthFocus = 2.0;

  // Border colors (will be overridden by theme)
  static const Color borderColorLight = Color(0xFFE5E5E5);
  static const Color borderColorDark = Color(0xFF404040);
  static const Color borderColorFocus = Color(0xFF0EA5E9);
  static const Color borderColorError = Color(0xFFEF4444);
  static const Color borderColorSuccess = Color(0xFF10B981);

  // Border styles
  static const Border defaultBorder = Border.fromBorderSide(
    BorderSide(color: borderColorLight, width: borderWidthDefault),
  );

  static const Border thickBorder = Border.fromBorderSide(
    BorderSide(color: borderColorLight, width: borderWidthThick),
  );

  static const Border focusBorder = Border.fromBorderSide(
    BorderSide(color: borderColorFocus, width: borderWidthFocus),
  );

  static const Border errorBorder = Border.fromBorderSide(
    BorderSide(color: borderColorError, width: borderWidthDefault),
  );

  static const Border successBorder = Border.fromBorderSide(
    BorderSide(color: borderColorSuccess, width: borderWidthDefault),
  );

  // Divider styles
  static const Divider horizontalDivider = Divider(
    height: 1,
    thickness: borderWidthThin,
    color: borderColorLight,
  );

  static const VerticalDivider verticalDivider = VerticalDivider(
    width: 1,
    thickness: borderWidthThin,
    color: borderColorLight,
  );
}
