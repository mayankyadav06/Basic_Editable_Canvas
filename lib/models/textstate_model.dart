import 'package:flutter/material.dart';

class TextState {
  final Offset position;
  final bool isBold;
  final bool isItalic;
  final String fontFamily;

  TextState({
    required this.position,
    required this.isBold,
    required this.isItalic,
    required this.fontFamily,
  });
}