import 'package:facebook_results/extensions/buildcontext/media_query_size.dart';
import 'package:facebook_results/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconSVGButton extends StatelessWidget {
  final OnTapCallback onPress;
  final String iconName;

  const IconSVGButton({
    super.key,
    this.onPress,
    required this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPress,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.mqSize.height * 0.008,
          horizontal: context.mqSize.width * 0.012,
        ),
        child: SvgPicture.asset(
          'assets/icons/$iconName.svg',
          height: context.mqSize.height * 0.026,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
