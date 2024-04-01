import 'package:facebook_results/extensions/buildcontext/media_query_size.dart';
import 'package:flutter/material.dart';

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
