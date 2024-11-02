import 'package:flutter/cupertino.dart';
import 'package:whisky_application/whisky_app_style/sizes.dart';
import 'package:whisky_application/whisky_app_style/whisky_app_colors.dart';


class WhiskyAppTextStyle {
  static const xlBold = TextStyle(
    color: WhiskyAppColors.black,
    fontSize: Sizes.p18,
    fontWeight: FontWeight.bold,
  );

  // Lサイズ 太字
  static const lBold = TextStyle(
    color: WhiskyAppColors.black,
    fontSize: Sizes.p16,
    fontWeight: FontWeight.bold,
  );

  // Mサイズ
  static const m = TextStyle(
    color: WhiskyAppColors.black,
    fontSize: Sizes.p14,
  );

  // Mサイズ 太字
  static const mBold = TextStyle(
    color: WhiskyAppColors.black,
    fontSize: Sizes.p14,
    fontWeight: FontWeight.bold,
  );

  // Mサイズ グレー
  static final mGrey = TextStyle(
    color: WhiskyAppColors.darkGrey,
    fontSize: Sizes.p14,
  );

  // Sサイズ
  static const s = TextStyle(
    color: WhiskyAppColors.black,
    fontSize: Sizes.p12,
  );

  // Sサイズ グレー
  static final sGrey = TextStyle(
    color: WhiskyAppColors.darkGrey,
    fontSize: Sizes.p12,
  );

  // XSサイズ 緑
  static const xsGreen = TextStyle(
    color: WhiskyAppColors.green,
    fontSize: Sizes.p10,
  );
}
