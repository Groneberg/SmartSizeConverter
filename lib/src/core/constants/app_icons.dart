import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class AppIcons {
  static const String _path = 'assets/icons';

  static const String user = '$_path/ic_user.svg';
  static const String shirt = '$_path/ic_shirt.svg';
  static const String pants = '$_path/ic_pants.svg';
  static const String shoes = '$_path/ic_shoes.svg';

  static Widget svg(String assetName, {double size = 24, Color? color}) {
    return SvgPicture.asset(
      assetName,
      width: size,
      height: size,
      colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }
}