import 'package:facebook_results/constants/routes.dart';
import 'package:facebook_results/constants/theme_constant.dart';
import 'package:facebook_results/extensions/buildcontext/media_query_size.dart';
import 'package:facebook_results/helpers/custom_widgets/home_view_button.dart';
import 'package:facebook_results/services/google_app_script/bloc/gas_bloc.dart';
import 'package:facebook_results/services/google_app_script/bloc/gas_event.dart';
import 'package:facebook_results/services/google_app_script/bloc/gas_state.dart';
import 'package:facebook_results/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GASBloc, GASState>(
      listener: listenerFunction,
      builder: (context, state) {
        return PopScope(
          canPop: !state.isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: SvgPicture.asset(
                'assets/images/facebook results.svg',
                height: context.mqSize.height * 0.0343,
              ),
            ),
            body: Padding(
              padding:
                  EdgeInsets.all(context.mqSize.height * bodyPaddingFactor),
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
                        onPress: () {
                          context
                              .read<GASBloc>()
                              .add(const GASEventPrepareResultSheet());
                          Navigator.of(context).pushNamed(createResultRoute);
                        },
                      ),
                      SizedBox(width: context.mqSize.width * 0.025),
                      HomeViewButton(
                        iconName: 'history',
                        text: 'History',
                        size: 0.044,
                        onPress: () {
                          Navigator.of(context).pushNamed(historyRoute);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
