import 'package:flutter/material.dart';

class MainConfigApp {
  //======== APP SETTINGS ========//


  static String fontFamily1 = 'Inter';


  static List<String> months = [
    'Янв',
    'Фев',
    'Мар',
    'Апр',
    'Май',
    'Июн',
    'Июл',
    'Авг',
    'Сен',
    'Окт',
    'Ноя',
    'Дек',
  ];

  static List<TagColor> tagColors = [
    TagColor(
      color: const Color(0xFF0177FF),
      colorHex: '#0177FF',
      assetPath: 'assets/icons/blue.svg'
    ),
    TagColor(
      color: const Color(0xFFFF1D1D),
      colorHex: '#FF1D1D',
      assetPath: 'assets/icons/red.svg'
    ),
    TagColor(
      color: const Color(0xFF20CB83),
      colorHex: '#20CB83',
      assetPath: 'assets/icons/green.svg'
    ),
    TagColor(
      color: const Color(0xFF2C2C2E),
      colorHex: '#2C2C2E',
      assetPath: 'assets/icons/black.svg'
    ),
    TagColor(
      color: const Color(0xFFC9237D),
      colorHex: '#C9237D',
      assetPath: 'assets/icons/perpul.svg'
    ),
  ];
}




class TagColor {
  final Color color;
  final String colorHex;
  final String assetPath;
  TagColor({
    required this.color,
    required this.colorHex,
    required this.assetPath
  });
}