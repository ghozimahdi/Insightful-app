import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

import '../gen/assets.gen.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      Assets.logoText.path,
      width: 120,
    );
  }
}
