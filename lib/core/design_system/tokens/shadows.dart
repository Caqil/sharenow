import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  // Elevation-based shadows
  static const List<BoxShadow> elevation1 = [
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> elevation2 = [
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> elevation3 = [
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 1),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> elevation4 = [
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 2),
      blurRadius: 16,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 8),
      blurRadius: 10,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> elevation5 = [
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 4),
      blurRadius: 24,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 12),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  // Semantic shadows
  static const List<BoxShadow> card = elevation2;
  static const List<BoxShadow> button = elevation1;
  static const List<BoxShadow> dialog = elevation4;
  static const List<BoxShadow> drawer = elevation5;
  static const List<BoxShadow> bottomSheet = elevation3;
  static const List<BoxShadow> appBar = elevation1;

  // Colored shadows
  static const List<BoxShadow> primaryShadow = [
    BoxShadow(
      color: Color(0x200EA5E9),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> successShadow = [
    BoxShadow(
      color: Color(0x2010B981),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> errorShadow = [
    BoxShadow(
      color: Color(0x20EF4444),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> warningShadow = [
    BoxShadow(
      color: Color(0x20F59E0B),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  // Glow effects
  static const List<BoxShadow> glow = [
    BoxShadow(
      color: Color(0x400EA5E9),
      offset: Offset(0, 0),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> innerShadow = [
    BoxShadow(
      color: Color(0x10000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -2,
    ),
  ];

  // Dark theme shadows
  static const List<BoxShadow> darkElevation1 = [
    BoxShadow(
      color: Color(0x40000000),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> darkElevation2 = [
    BoxShadow(
      color: Color(0x40000000),
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x60000000),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> darkElevation3 = [
    BoxShadow(
      color: Color(0x40000000),
      offset: Offset(0, 1),
      blurRadius: 8,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x60000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: 0,
    ),
  ];
}
