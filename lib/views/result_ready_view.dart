import 'package:facebook_results/constants/routes.dart';
import 'package:facebook_results/extensions/buildcontext/media_query_size.dart';
import 'package:facebook_results/helpers/custom_widgets/popup_text_field.dart';
import 'package:facebook_results/services/google_app_script/bloc/gas_bloc.dart';
import 'package:facebook_results/services/google_app_script/bloc/gas_event.dart';
import 'package:facebook_results/services/google_app_script/bloc/gas_state.dart';
import 'package:facebook_results/services/google_app_script/models/member.dart';
import 'package:facebook_results/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'dart:developer' as devtools show log;

class ResultReadyView extends StatefulWidget {
  const ResultReadyView({super.key});

  @override
  State<ResultReadyView> createState() => _ResultReadyViewState();
}

class _ResultReadyViewState extends State<ResultReadyView> {
  late final TextEditingController _textController;
  late final TextEditingController _characterController;
  List<Member> sortedMembers = [];

  @override
  void initState() {
    _textController = TextEditingController();
    _characterController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _characterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GASBloc, GASState>(
      builder: (context, state) {
        if (state is GASStateResultReady) {
          sortedMembers = List.from(state.sortedDataList);
          if (_textController.text.isEmpty) {
            _textController.text = generateScoreText(
              sortedMembers: sortedMembers,
            );
          }
        }
        return PopScope(
          canPop: !state.isLoading,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Result Ready'),
              actions: [
                IconButton(
                  onPressed: () {
                    showCharacterPopup(
                      context: context,
                      textController: _characterController,
                      sortedMembers: sortedMembers,
                    ).then((value) {
                      if (value != null && value.isNotEmpty) {
                        _textController.text = value;
                      }
                      _characterController.clear();
                    });
                  },
                  icon: Icon(
                    Icons.emoji_emotions_outlined,
                    size: context.mqSize.height * 0.0274,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<GASBloc>().add(const GASEventResetState(
                          shouldEmptyState: true,
                        ));
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      homeRoute,
                      (route) => false,
                    );
                  },
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.grey[400]),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.blue[600],
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            body: state.isLoading
                ? Container()
                : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: context.mqSize.height * 0.019,
                        horizontal: context.mqSize.width * 0.04,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Your result is ready!',
                                  style: TextStyle(
                                    fontSize: context.mqSize.height * 0.044,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: context.mqSize.height * 0.0168,
                                  ),
                                  child: TextField(
                                    controller: _textController,
                                    maxLines: 16,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: context.mqSize.width * 0.04,
                                        vertical: context.mqSize.height * 0.014,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xffEDEFF5),
                                      isDense: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(11),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: context.mqSize.height * 0.017),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              context.mqSize.width * 0.08,
                                        ),
                                        child: MaterialButton(
                                          onPressed: () {
                                            copyToClipboard(
                                              text: _textController.text,
                                              context: context,
                                            );
                                          },
                                          color: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical:
                                                context.mqSize.height * 0.014,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'COPY',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      context.mqSize.height *
                                                          0.02,
                                                ),
                                              ),
                                              SizedBox(
                                                width: context.mqSize.width *
                                                    0.008,
                                              ),
                                              Icon(
                                                Icons.copy,
                                                color: Colors.white,
                                                size: context.mqSize.height *
                                                    0.02,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class AddCharacterPopup extends StatefulWidget {
  final TextEditingController textController;
  const AddCharacterPopup({
    super.key,
    required this.textController,
  });

  @override
  State<AddCharacterPopup> createState() => _AddCharacterPopupState();
}

class _AddCharacterPopupState extends State<AddCharacterPopup> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      title: Center(
        child: titleText(
          context: context,
          text: 'Add characters',
        ),
      ),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PopupTextField(
              textFieldName: 'Characters',
              controller: widget.textController,
              hintText: 'Add your characters...',
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter a character!';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        MaterialButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              Navigator.of(context).pop(true);
            }
          },
          color: Colors.black,
          shape: RoundedRectangleBorder(
            side: const BorderSide(),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            'Add',
            style: TextStyle(
              color: Colors.white,
              fontSize: context.mqSize.height * 0.019,
            ),
          ),
        ),
      ],
    );
  }
}

Future<String?> showCharacterPopup({
  required BuildContext context,
  required TextEditingController textController,
  required List<Member> sortedMembers,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AddCharacterPopup(textController: textController);
    },
  ).then((value) {
    if (value ?? false) {
      return generateScoreText(
        sortedMembers: sortedMembers,
        dots: textController.text,
      );
    } else {
      return null;
    }
  });
}
