import 'package:facebook_results/constants/routes.dart';
import 'package:facebook_results/extensions/buildcontext/media_query_size.dart';
import 'package:facebook_results/helpers/custom_widgets/form_alert_dialog.dart';
import 'package:facebook_results/helpers/custom_widgets/bottom_sheet_icon_button.dart';
import 'package:facebook_results/helpers/custom_widgets/icon_svg_button.dart';
import 'package:facebook_results/helpers/custom_widgets/result_list_tile.dart';
import 'package:facebook_results/services/google_app_script/bloc/gas_bloc.dart';
import 'package:facebook_results/services/google_app_script/bloc/gas_event.dart';
import 'package:facebook_results/services/google_app_script/bloc/gas_state.dart';
import 'package:facebook_results/services/google_app_script/models/member.dart';
import 'package:facebook_results/utility/generics/delete_dialog.dart';
import 'package:facebook_results/utility/utility.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:flutter_bloc/flutter_bloc.dart';

class CreateResultView extends StatefulWidget {
  final bool isUpdating;
  const CreateResultView({
    super.key,
    this.isUpdating = false,
  });

  @override
  State<CreateResultView> createState() => _CreateResultViewState();
}

class _CreateResultViewState extends State<CreateResultView> with RouteAware {
  // Member? _selectedMember;
  List<Member> scoreList = [];
  List<Member> originalList = [];
  int? sheetId;
  bool isLoading = true;

  @override
  void didPop() {
    if (sheetId != null) {
      context.read<GASBloc>().add(GASEventDeleteSheet(sheetId: sheetId!));
    }
    super.didPop();
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GASBloc, GASState>(
      builder: (context, state) {
        if (state is GASStateCreatingResult) {
          if (scoreList.isEmpty && originalList.isEmpty) {
            scoreList = state.operatedMembersList!;
            originalList = state.originalMembersList;
          }
          sheetId = state.sheetId;
          isLoading = state.isLoading;
        }
        return PopScope(
          canPop: !isLoading && areListsEqual(scoreList, originalList),
          onPopInvoked: (didPop) {
            if (!isLoading && !didPop) {
              showDeleteDialog(
                context: context,
                content:
                    'Are you sure that you want to go back to home page and delete this result?',
              ).then((value) {
                if (value) {
                  Navigator.of(context).pop(true);
                }
              });
            }
          },
          child: Scaffold(
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
                  onPress: () {
                    Navigator.of(context).pushNamed(
                      searchMembersRoute,
                      arguments: {
                        'scoreList': scoreList,
                        // <Member>[
                        //   Member(id: '23232', name: "Rafi Ahmed", isAdmin: true),
                        //   Member(id: '23233', name: "Ravi Singh", isAdmin: false)
                        // ],
                        'callback': onScoreChange,
                      },
                    );
                  },
                ),
                SizedBox(
                  width: context.mqSize.width * 0.02,
                ),
                SizedBox(
                  width: context.mqSize.width * 0.14,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(homeRoute, (route) => false);
                      Navigator.of(context).pushNamed(resultReadyRoute);
                    },
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
              itemCount: scoreList.length,
              // itemCount: 1,
              itemBuilder: (context, index) {
                return ResultListTile(
                  member: scoreList[index],
                  // Member(
                  //     id: '23232',
                  //     name: "Rafi Ahmed sadasdasdasd sadasdasd asdasd asdas",
                  //     isAdmin: true),
                  onChanged: onScoreChange,
                  onLongTap: (member) {
                    showBottomMenu(
                      context: context,
                      selectedMember: member,
                      // globalMember: _selectedMember,
                      index: index,
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void onScoreChange(Member member) {
    devtools.log(member.toString());
    setState(() {
      final updatedIndex =
          scoreList.indexWhere((listMember) => listMember == member);
      scoreList[updatedIndex] = member;
    });
  }
}

void showBottomMenu({
  required Member selectedMember,
  required int index,
  // required Member? globalMember,
  required BuildContext context,
}) {
  // globalMember = selectedMember;

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
                devtools.log(selectedMember.toString());
                showDeleteDialog(
                  context: context,
                  content: 'Are you sure you want to delete this member?',
                ).then((value) {
                  if (value) {
                    // Add event here
                  }
                  _disposingSelectedMember(
                    context: context,
                    // member: globalMember,
                  );
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
                  member: selectedMember,
                  onSubmit: (memberS) {
                    devtools.log(memberS.toString());
                    // Navigator.of(context).pop(true);
                  },
                ).then((value) {
                  _disposingSelectedMember(
                    context: context,
                    // member: globalMember,
                  );
                });
              },
            ),
            BottomSheetIconButton(
              buttonName: 'Cancel',
              isIcon: true,
              icon: Icons.cancel,
              onPress: () {
                _disposingSelectedMember(
                  context: context,
                  // member: globalMember,
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

void _disposingSelectedMember({
  // required Member? member,
  required BuildContext context,
}) {
  // member = null;
  Navigator.of(context).pop(true);
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
