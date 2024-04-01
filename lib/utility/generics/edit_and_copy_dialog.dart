import 'package:facebook_results/utility/generics/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<String?> showEditAndCopyDialog(
  BuildContext context,
  // String content,
) {
  return showGenericDialog<String>(
    context: context,
    title: 'Do you want to',
    content: '',
    optionBuilder: () => {
      'EDIT': 'Edit',
      'COPY': 'Copy',
    },
  );
}
