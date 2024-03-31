import 'package:facebook_results/services/google_app_script/bloc/gas_bloc.dart';
import 'package:facebook_results/services/google_app_script/google_app_script_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:facebook_results/constants/theme_constant.dart';
import 'package:facebook_results/extensions/buildcontext/media_query_size.dart';
import 'package:facebook_results/views/home_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            toolbarHeight: context.mqSize.height * 0.08,
            backgroundColor: appBarBackgroundColor,
            elevation: 2.0,
            shadowColor: appBarShadowColor,
            surfaceTintColor: appBarBackgroundColor,
          ),
          colorScheme: const ColorScheme.light(
            background: appBackgroundColor,
          )),
      home: BlocProvider<GASBloc>(
        create: (context) => GASBloc(GoogleAppScriptService()),
        child: const HomeView(),
      ),
    );
  }
}
