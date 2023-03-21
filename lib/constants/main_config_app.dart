import 'package:flutter/material.dart';

class MainConfigApp {
  //======== APP SETTINGS ========//

  //YANDEX API TOKEN (Надо поменять потом!!!)
  static String mapAPI = '280d67e0-e9e9-428f-baee-cd11699581f7';

  static String fontFamily1 = 'Inter';

  static List<String> decorBackgrounds = [
    'assets/backgrounds/main_bg_full.png',
    'assets/backgrounds/main_bg_middle.png',
    'assets/backgrounds/main_bg.png',
    'assets/backgrounds/1_bg_full.png',
    'assets/backgrounds/1_bg_middle.png',
    'assets/backgrounds/1_bg.png',
    'assets/backgrounds/2_bg_full.png',
    'assets/backgrounds/2_bg_middle.png',
    'assets/backgrounds/2_bg.png',
    'assets/backgrounds/blue_bg.png',
    'assets/backgrounds/yellow_bg.png',
    'assets/backgrounds/black_bg.png',
    'assets/backgrounds/pink_bg.png',
    'assets/backgrounds/redFull_bg.png',
    'assets/backgrounds/blueFull_bg.png',
    'assets/backgrounds/green_bg.png',
    'assets/backgrounds/grey_bg.png',
    'assets/backgrounds/brown_bg.png',
    'assets/backgrounds/purpl_bg.png',
  ];

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

  static List<AvatarsGridModel> avatars = [
    AvatarsGridModel(dirName: 'men', avatars: [
      'ava_14__kopia.png',
      'ava_serdechki.png',
      'ava_19.png',
      'ava_13.png',
      'ava_8.png',
      'ava_10.png',
      'ava_17.png',
      'ava_6.png',
      'ava_4.png',
      'kolch.png',
      'kostya.png',
      'IBRA.png',
    ]),
    AvatarsGridModel(dirName: 'girls', avatars: [
      'ava_15__kopia.png',
      'ava3.png',
      'ava_2.png',
      'ava_12.png',
      'ava_18.png',
      'ava_9.png',
      'ava_16.png',
      'ava_5.png',
      'ava_21.png',
      'sestra_koli.png',
      'ava_dob_2.png',
      '25.png',
    ]),
    AvatarsGridModel(dirName: 'animals', avatars: [
      'kit.png',
      'chkot_4.png',
      'akula_kontrastnaya.png',
      'kot_pukh_2.png',
      'lyagushka_kontrastnaya.png',
      'ovechka_2.png',
      'ping.png',
      'ptitsa.png',
      'tigor.png',
      'zayChIK.png',
      'krokodil_kontrastny.png',
      'enot_samy_finalny.png',
    ]),
    AvatarsGridModel(dirName: 'additions', avatars: [
      'arbuz_2.png',
      'kot_muzh.png',
      'kotost.png',
      'mr_inkredibil_3.png',
      'robert_tsel.png',
      'skalaaa.png',
      'kolobok.png',
      'serdtsekot_1.png',
      'zlaya_tykva_2.png',
      'medved_ob.png',
      'khomyak_mem_2.png',
      'serdtse.png',
    ]),
  ];

  static List<TagColor> tagColors = [
    TagColor(
        color: const Color(0xFF0177FF),
        colorHex: '#0177FF',
        assetPath: 'assets/icons/blue.svg'),
    TagColor(
        color: const Color(0xFFFF1D1D),
        colorHex: '#FF1D1D',
        assetPath: 'assets/icons/red.svg'),
    TagColor(
        color: const Color(0xFF20CB83),
        colorHex: '#20CB83',
        assetPath: 'assets/icons/green.svg'),
    TagColor(
        color: const Color(0xFF2C2C2E),
        colorHex: '#2C2C2E',
        assetPath: 'assets/icons/black.svg'),
    TagColor(
        color: const Color(0xFFC9237D),
        colorHex: '#C9237D',
        assetPath: 'assets/icons/perpul.svg'),
  ];
}

class TagColor {
  final Color color;
  final String colorHex;
  final String assetPath;
  TagColor(
      {required this.color, required this.colorHex, required this.assetPath});
}

class AvatarsGridModel {
  final List<String> avatars;
  final String dirName;
  AvatarsGridModel({required this.avatars, required this.dirName});
}
