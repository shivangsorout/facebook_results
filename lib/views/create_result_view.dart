import 'package:facebook_results/extensions/buildcontext/media_query_size.dart';
import 'package:facebook_results/helpers/custom_widgets/form_alert_dialog.dart';
import 'package:facebook_results/helpers/custom_widgets/bottom_sheet_icon_button.dart';
import 'package:facebook_results/helpers/custom_widgets/icon_svg_button.dart';
import 'package:facebook_results/helpers/custom_widgets/result_list_tile.dart';
import 'package:facebook_results/services/google_app_script/models/member.dart';
import 'package:facebook_results/utility/generics/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class CreateResultView extends StatefulWidget {
  final bool isUpdating;
  const CreateResultView({
    super.key,
    this.isUpdating = false,
  });

  @override
  State<CreateResultView> createState() => _CreateResultViewState();
}

class _CreateResultViewState extends State<CreateResultView> {
  Member? _selectedMember;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Result'),
        actions: [
          IconSVGButton(
            iconName: 'add',
            onPress: () async {
              // devtools.log(_selectedMember.toString());
              await showAlertDialog(
                context,
                onSubmit: (memberS) {
                  devtools.log(memberS.toString());
                  // Navigator.of(context).pop(true);
                },
              );
            },
          ),
          SizedBox(
            width: context.mqSize.width * 0.02,
          ),
          IconSVGButton(
            iconName: 'search',
            onPress: () {},
          ),
          SizedBox(
            width: context.mqSize.width * 0.02,
          ),
          SizedBox(
            width: context.mqSize.width * 0.14,
            child: TextButton(
              onPressed: () {},
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.grey[400]),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
              child: const Text(
                'NEXT',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(context.mqSize.height * 0.016),
        itemCount: 1,
        itemBuilder: (context, index) {
          return ResultListTile(
            member: Member(id: '23232', name: "Rafi Ahmed", isAdmin: true),
            onChanged: (newScore) {},
            onLongTap: (member) {
              _showBottomMenu(member, index);
            },
          );
        },
      ),
    );
  }

  void _showBottomMenu(Member member, int index) {
    _selectedMember = member;

    showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Make the corners non-rounded
      ),
      builder: (context) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottomSheetIconButton(
                onPress: () {
                  devtools.log(member.toString());
                  showDeleteDialog(context).then((value) {
                    if (value) {
                      // Add event here
                    }
                    _disposingSelectedMember();
                  });
                },
                buttonName: 'Delete',
                iconName: 'delete',
              ),
              BottomSheetIconButton(
                iconName: 'edit',
                buttonName: 'Edit',
                sizeFactor: 0.028,
                onPress: () {
                  // devtools.log(member.toString());
                  showAlertDialog(
                    context,
                    member: member,
                    onSubmit: (memberS) {
                      devtools.log(memberS.toString());
                      // Navigator.of(context).pop(true);
                    },
                  ).then((value) {
                    _disposingSelectedMember();
                  });
                },
              ),
              BottomSheetIconButton(
                buttonName: 'Cancel',
                isIcon: true,
                icon: Icons.cancel,
                onPress: () {
                  _disposingSelectedMember();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _disposingSelectedMember() {
    _selectedMember = null;
    Navigator.of(context).pop(true);
  }
}

Future<void> showAlertDialog(
  BuildContext context, {
  Member? member,
  required SubmitCallback onSubmit,
}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return FormAlertDialog(
        member: member,
        onSubmit: onSubmit,
      );
    },
  );
}
