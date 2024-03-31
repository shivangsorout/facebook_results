import 'package:facebook_results/extensions/buildcontext/media_query_size.dart';
import 'package:facebook_results/helpers/custom_widgets/home_view_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/images/facebook results.svg',
          width: context.mqSize.width * 0.56,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(context.mqSize.height * 0.016),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Menu',
              style: TextStyle(
                fontSize: context.mqSize.height * 0.029,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: context.mqSize.height * 0.01),
            Row(
              children: [
                HomeViewButton(
                  iconName: 'result_clipboard',
                  text: 'Create Result',
                  onPress: () {},
                ),
                SizedBox(width: context.mqSize.width * 0.025),
                HomeViewButton(
                  iconName: 'history',
                  text: 'History',
                  size: 0.044,
                  onPress: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
