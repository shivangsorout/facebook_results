import 'package:facebook_results/extensions/buildcontext/media_query_size.dart';
import 'package:facebook_results/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeViewButton extends StatelessWidget {
  final String iconName;
  final String text;
  final double size;
  final OnTapCallback onPress;

  const HomeViewButton({
    super.key,
    required this.iconName,
    required this.text,
    this.size = 0.051,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        borderRadius: BorderRadius.circular(8),
        elevation: 6,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            child: InkWell(
              onTap: onPress,
              child: Container(
                constraints: BoxConstraints(
                  minHeight: context.mqSize.height * 0.115,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: context.mqSize.width * 0.039,
                  vertical: context.mqSize.height * 0.015,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/$iconName.svg',
                      height: context.mqSize.height * size,
                    ),
                    SizedBox(height: context.mqSize.height * 0.01),
                    Text(
                      text,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: context.mqSize.height * 0.021,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
