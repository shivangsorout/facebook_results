import 'package:flutter/material.dart';

extension MediaQuerySize on BuildContext {
  Size get mqSize => MediaQuery.of(this).size;
}
