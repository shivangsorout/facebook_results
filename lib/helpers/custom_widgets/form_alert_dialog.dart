import 'package:facebook_results/extensions/buildcontext/media_query_size.dart';
import 'package:facebook_results/helpers/custom_widgets/popup_text_field.dart';
import 'package:facebook_results/services/google_app_script/models/member.dart';
import 'package:facebook_results/utility/utility.dart';
import 'package:flutter/material.dart';

typedef SubmitCallback = void Function(Member);

class FormAlertDialog extends StatefulWidget {
  final Member? member;
  final SubmitCallback onSubmit;

  const FormAlertDialog({
    super.key,
    this.member,
    required this.onSubmit,
  });

  @override
  State<FormAlertDialog> createState() => _FormAlertDialogState();
}

class _FormAlertDialogState extends State<FormAlertDialog> {
  late TextEditingController _controllerMemberName;
  late TextEditingController _controllerMemberScore;
  bool isAdmin = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controllerMemberName =
        TextEditingController(text: widget.member?.name ?? '');
    _controllerMemberScore = TextEditingController(
        text: widget.member?.score == null
            ? ''
            : widget.member?.score.toString());
    isAdmin = widget.member?.isAdmin ?? false;
    super.initState();
  }

  @override
  void dispose() {
    _controllerMemberName.dispose();
    _controllerMemberScore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      title: Center(
        child: titleText(
          context: context,
          text: widget.member != null ? 'Update Member' : 'New Member',
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            PopupTextField(
              textFieldName: 'Member Name',
              controller: _controllerMemberName,
              hintText: 'Please enter name...',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            SizedBox(height: context.mqSize.height * 0.016),
            PopupTextField(
              textFieldName: 'Score',
              controller: _controllerMemberScore,
              hintText: 'Please enter score...',
              keyboardType: TextInputType.number,
              validator: (value) {
                // if (value == null || value.isEmpty) {
                //   return 'Please enter a score';
                // }
                return null;
              },
            ),
            SizedBox(height: context.mqSize.height * 0.005),
            Row(
              children: [
                SizedBox(width: context.mqSize.width * 0.0048),
                const Text('Admin'),
                SizedBox(width: context.mqSize.width * 0.03),
                Checkbox(
                  activeColor: Colors.black,
                  value: isAdmin,
                  onChanged: (value) {
                    setState(() {
                      isAdmin = value!;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: MaterialButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final name = _controllerMemberName.text;
                        final score =
                            int.tryParse(_controllerMemberScore.text) ?? 0;
                        final isAdmin = this.isAdmin;
                        final id = widget.member?.id ?? 'null';
                        final member = Member(
                          id: id,
                          name: name,
                          isAdmin: isAdmin,
                          score: score,
                        );
                        widget.onSubmit(member);
                        Navigator.of(context).pop(true);
                      }
                    },
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: context.mqSize.height * 0.018,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
