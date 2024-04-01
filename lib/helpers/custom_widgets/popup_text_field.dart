import 'package:facebook_results/extensions/buildcontext/media_query_size.dart';
import 'package:flutter/material.dart';

typedef ValidatorCallback = String? Function(String?);

class PopupTextField extends StatelessWidget {
  final String textFieldName;
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final ValidatorCallback validator;
  const PopupTextField({
    super.key,
    required this.textFieldName,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.name,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            bottom: context.mqSize.height * 0.0057,
            left: context.mqSize.width * 0.0048,
          ),
          child: Text(
            textFieldName,
            style: TextStyle(
              fontSize: context.mqSize.height * 0.017,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              vertical: context.mqSize.height * 0.0087,
              horizontal: context.mqSize.width * 0.02,
            ),
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),
      ],
    );
  }
}
