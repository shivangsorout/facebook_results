import 'package:facebook_results/extensions/buildcontext/media_query_size.dart';
import 'package:facebook_results/helpers/loading/loading_screen.dart';
import 'package:facebook_results/services/google_app_script/bloc/gas_bloc.dart';
import 'package:facebook_results/services/google_app_script/bloc/gas_event.dart';
import 'package:facebook_results/services/google_app_script/json_constants.dart';
import 'package:facebook_results/services/google_app_script/models/member.dart';
import 'package:facebook_results/utility/generics/confirmation_dialog.dart';
import 'package:facebook_results/utility/generics/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnTapCallback = void Function()?;
Text titleText({
  required BuildContext context,
  required String text,
}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: context.mqSize.height * 0.029,
      fontWeight: FontWeight.bold,
    ),
  );
}

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

Map<String, dynamic> stringToMap(String input) {
  input = input.substring(1, input.length - 1);

  // Split the string by commas
  List<String> keyValuePairs = input.split(',');

  Map<String, String> resultMap = {};

  for (String pair in keyValuePairs) {
    // Split the pair by colon
    List<String> keyValue = pair.split(':');

    // Remove leading and trailing whitespace from the key and value
    String key = keyValue[0].trim();
    String value = keyValue[1].trim();

    // Remove quotes if present
    if (value.startsWith("'") && value.endsWith("'")) {
      value = value.substring(1, value.length - 1);
    }

    // Add the key-value pair to the map
    resultMap[key] = value;
  }
  return resultMap;
}

bool areListsEqual(List<Member> list1, List<Member> list2) {
  if (list1.isNotEmpty && list2.isNotEmpty) {
    if (list1.length != list2.length) {
      return false;
    }

    // Sort the lists to ensure order does not affect comparison
    list1.sort((a, b) => a.id.compareTo(b.id));
    list2.sort((a, b) => a.id.compareTo(b.id));

    for (int i = 0; i < list1.length; i++) {
      if (list1[i] == list2[i] &&
          (list1[i].name != list2[i].name ||
              list1[i].isAdmin != list2[i].isAdmin ||
              list1[i].score != list2[i].score)) {
        return false;
      }
    }

    return true;
  } else {
    return true;
  }
}

String generateScoreText(List<Member> sortedMembers) {
  if (sortedMembers.isEmpty) {
    return ''; // Return empty string if the list is empty
  }

  String result = '';

  List<Member> adminsList =
      sortedMembers.where((element) => element.isAdmin).toList();
  List<Member> membersList =
      sortedMembers.where((element) => !element.isAdmin).toList();

  membersList.sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));
  adminsList.sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));

  const dots = "...................";
  int? memberScore = membersList.first.score;
  for (var i = 0; i < membersList.length; i++) {
    var memberInner = membersList[i];
    if (memberScore != null && memberScore != 0) {
      if (result.isNotEmpty && memberInner.score == memberScore) {
        result += '\n';
      }
      if (memberInner.score == memberScore) {
        result += memberInner.name;
      } else if (memberInner.score != null &&
          memberInner.score! < memberScore) {
        result += dots +
            memberScore.toString() +
            (i + 1 < membersList.length &&
                    (memberInner.score != null && memberInner.score != 0)
                ? '\n\n${memberInner.name}'
                : '');
        memberScore = memberInner.score;
      } else if (memberInner.score == null) {
        result += dots + memberScore.toString();
        memberScore = memberInner.score;
      }
    }
  }

  int? adminScore = adminsList.first.score;
  if (adminsList.isNotEmpty && adminScore != null && adminScore != 0) {
    result += '\n\n';
  }
  for (var admin in adminsList) {
    // If the admin's score is null or zero, skip it
    if (admin.score == null || admin.score == 0) {
      continue;
    }
    // Concatenate admin's name with dots and score
    result += '\n${admin.name + dots + admin.score.toString()}';
  }

  return result;
}

void listenerFunction(context, state) {
  /// Loading checks
  if (state.isLoading) {
    LoadingScreen().show(
      context: context,
      text: state.loadingText ?? 'Please wait a moment while we load!',
    );
  } else {
    LoadingScreen().hide();
  }

  /// Error checks
  if (state.exception != null) {
    // Extracting exception message part
    final exception = state.exception!.toString().replaceAll('Exception: ', '');

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
}

void copyToClipboard({
  required String text,
  required BuildContext context,
}) {
  Clipboard.setData(ClipboardData(text: text));
  // Show a snackbar to indicate that text has been copied
  // ScaffoldMessenger.of(context).showSnackBar(
  //   const SnackBar(
  //     content: Text('Text copied to clipboard'),
  //   ),
  // );
}
