import 'package:facebook_results/constants/routes.dart';
import 'package:facebook_results/helpers/loading/loading_screen.dart';
import 'package:facebook_results/services/google_app_script/bloc/gas_bloc.dart';
import 'package:facebook_results/services/google_app_script/bloc/gas_event.dart';
import 'package:facebook_results/services/google_app_script/bloc/gas_state.dart';
import 'package:facebook_results/services/google_app_script/google_app_script_service.dart';
import 'package:facebook_results/services/google_app_script/json_constants.dart';
import 'package:facebook_results/utility/generics/confirmation_dialog.dart';
import 'package:facebook_results/utility/generics/error_dialog.dart';
import 'package:facebook_results/utility/utility.dart';
import 'package:facebook_results/views/create_result/create_result_view.dart';
import 'package:facebook_results/views/create_result/search_members.dart';
import 'package:facebook_results/views/history_view.dart';
import 'package:facebook_results/views/result_ready_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:facebook_results/constants/theme_constant.dart';
import 'package:facebook_results/extensions/buildcontext/media_query_size.dart';
import 'package:facebook_results/views/home_view.dart';
import 'package:flutter/material.dart';
// import 'dart:developer' as devtools show log;

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
    return BlocProvider(
      create: (context) => GASBloc(GoogleAppScriptService()),
      child: MaterialApp(
        navigatorObservers: [routeObserver],
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
        initialRoute: null,
        routes: {
          homeRoute: (context) => const HomeView(),
          createResultRoute: (context) => const CreateResultView(),
          searchMembersRoute: (context) => const SearchMembersView(),
          resultReadyRoute: (context) => const ResultReadyView(),
          historyRoute: (context) => const HistoryView(),
        },
        home: BlocListener<GASBloc, GASState>(
          listener: (context, state) {
            /// Loading checks
            if (state.isLoading) {
              LoadingScreen().show(
                context: context,
                text:
                    state.loadingText ?? 'Please wait a moment while we load!',
              );
            } else {
              LoadingScreen().hide();
            }

            /// Error checks
            if (state.exception != null) {
              // Extracting exception message part
              final exception =
                  state.exception!.toString().replaceAll('Exception: ', '');

              // Extracting main error message
              final String errorMessage = !exception.contains('{')
                  ? exception
                  : stringToMap(exception).containsKey(keyMessage)
                      ? stringToMap(exception)[keyMessage]
                      : exception;

              // Showing error
              showErrorDialog(context, errorMessage).then((value) {
                // If app is at HomeView and we have sheet Id then we will delete it
                // if (state is GASStateCreatingResult &&
                //     (state.sheetId != null &&
                //         (ModalRoute.of(context)?.settings.name == '/' ||
                //             ModalRoute.of(context)?.settings.name ==
                //                 homeRoute))) {
                //   context
                //       .read<GASBloc>()
                //       .add(GASEventDeleteSheet(sheetId: state.sheetId!));
                // }

                // Resetting error state
                context.read<GASBloc>().add(const GASEventResetState());
              });
            }

            // If there is any success message
            if (state.successMessage.isNotEmpty) {
              showConfirmationDialog(context, state.successMessage);
            }
          },
          child: const HomeView(),
        ),
      ),
    );
  }
}
