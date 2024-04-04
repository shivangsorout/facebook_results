import 'package:facebook_results/utility/generics/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteDialog({
  required BuildContext context,
  required String content,
}) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete',
    content: content,
    optionBuilder: () => {
      'YES': true,
      'NO': false,
    },
  ).then((value) => value ?? false);
}
