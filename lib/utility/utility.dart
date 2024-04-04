import 'package:facebook_results/extensions/buildcontext/media_query_size.dart';
import 'package:facebook_results/services/google_app_script/models/member.dart';
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
