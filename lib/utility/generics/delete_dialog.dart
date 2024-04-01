import 'package:facebook_results/utility/generics/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete',
    content: 'Are you sure you want to delete this member?',
    optionBuilder: () => {
      'YES': true,
      'NO': false,
    },
  ).then((value) => value ?? false);
}
