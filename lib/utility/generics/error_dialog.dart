import 'package:facebook_results/utility/generics/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String content,
) {
  return showGenericDialog(
    context: context,
    title: 'Error',
    content: content,
    optionBuilder: () => {'OK': null},
  );
}
