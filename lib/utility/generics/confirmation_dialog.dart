import 'package:facebook_results/utility/generics/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showConfirmationDialog(
  BuildContext context,
  String content,
) {
  return showGenericDialog(
    context: context,
    title: 'Success',
    content: content,
    optionBuilder: () => {'OK': null},
  );
}
