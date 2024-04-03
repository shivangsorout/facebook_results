import 'package:facebook_results/constants/routes.dart';
import 'package:facebook_results/services/google_app_script/bloc/gas_bloc.dart';
import 'package:facebook_results/services/google_app_script/google_app_script_service.dart';
import 'package:facebook_results/views/create_result/create_result_view.dart';
import 'package:facebook_results/views/create_result/search_members.dart';
import 'package:facebook_results/views/history_view.dart';
import 'package:facebook_results/views/result_ready_view.dart';
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
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: context.mqSize.height * 0.026,
          ),
          toolbarHeight: context.mqSize.height * 0.08,
          backgroundColor: appBarBackgroundColor,
          elevation: 2.0,
          shadowColor: appBarShadowColor,
          surfaceTintColor: appBarBackgroundColor,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          background: appBackgroundColor,
        ),
      ),
      routes: {
        homeRoute: (context) => const HomeView(),
        createResultRoute: (context) => const CreateResultView(),
        searchMembersRoute: (context) => const SearchMembersView(),
        resultReadyRoute: (context) => const ResultReadyView(),
        historyRoute: (context) => const HistoryView(),
      },
      home: BlocProvider<GASBloc>(
        create: (context) => GASBloc(GoogleAppScriptService()),
        child: const HomeView(),
      ),
    );
  }
}
