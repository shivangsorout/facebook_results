import 'package:facebook_results/extensions/buildcontext/media_query_size.dart';
import 'package:facebook_results/utility/utility.dart';
import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionBuilder,
}) {
  final options = optionBuilder();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Center(
          child: titleText(
            context: context,
            text: title,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: content.isNotEmpty,
              child: Center(
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: context.mqSize.height * 0.02,
                  ),
                ),
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: options.keys.map((optionTitle) {
          final value = options[optionTitle];
          final valueCheck =
              (value is bool) ? value : value == null || value == 'Edit';
          return MaterialButton(
            color: valueCheck ? Colors.black : Colors.white,
            shape: RoundedRectangleBorder(
              side: valueCheck ? BorderSide.none : const BorderSide(),
              borderRadius: BorderRadius.circular(7),
            ),
            onPressed: () {
              if (value != null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  optionTitle,
                  style: TextStyle(
                    color: !valueCheck ? Colors.black : Colors.white,
                    fontSize: context.mqSize.height * 0.019,
                  ),
                ),
                SizedBox(width: context.mqSize.width * 0.014),
                Visibility(
                  visible: value is String,
                  child: Icon(
                    value == 'Edit' ? Icons.edit : Icons.copy,
                    color: value == 'Edit' ? Colors.white : Colors.black,
                    size: context.mqSize.height * 0.019,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    },
  );
}
