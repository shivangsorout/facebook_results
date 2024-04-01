import 'package:facebook_results/extensions/buildcontext/media_query_size.dart';
import 'package:facebook_results/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomSheetIconButton extends StatelessWidget {
  final String iconName;
  final IconData? icon;
  final String buttonName;
  final OnTapCallback onPress;
  final double sizeFactor;
  final bool isIcon;

  const BottomSheetIconButton({
    super.key,
    this.iconName = '',
    required this.buttonName,
    required this.onPress,
    this.sizeFactor = 0.036,
    this.isIcon = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            constraints: BoxConstraints(
              minHeight: context.mqSize.height * 0.036,
            ),
            child: isIcon
                ? Icon(
                    icon,
                    size: context.mqSize.height * sizeFactor,
                  )
                : SvgPicture.asset(
                    'assets/icons/$iconName.svg',
                    height: context.mqSize.height * sizeFactor,
                  ),
          ),
          SizedBox(height: context.mqSize.height * 0.002),
          Text(
            buttonName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: context.mqSize.height * 0.017,
            ),
          ),
        ],
      ),
    );
  }
}
