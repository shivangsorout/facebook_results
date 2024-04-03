import 'dart:math';

import 'package:facebook_results/extensions/buildcontext/media_query_size.dart';
import 'package:facebook_results/services/google_app_script/models/member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

typedef OnMemberCallback = void Function(Member);

class ResultListTile extends StatefulWidget {
  final Member member;
  final OnMemberCallback onChanged;
  final OnMemberCallback onLongTap;
  const ResultListTile({
    super.key,
    required this.member,
    required this.onChanged,
    required this.onLongTap,
  });

  @override
  State<ResultListTile> createState() => _ResultListTileState();
}

class _ResultListTileState extends State<ResultListTile>
    with AutomaticKeepAliveClientMixin {
  late final int randomNumber;
  late Member member;
  TextEditingController? _textController;

  @override
  void initState() {
    randomNumber = Random().nextInt(11);
    _textController =
        TextEditingController(text: widget.member.score?.toString() ?? '');
    super.initState();
  }

  @override
  void dispose() {
    _textController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _textController?.text = widget.member.score?.toString() ?? '';
    member = widget.member;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: context.mqSize.height * 0.007,
      ),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(9)),
        elevation: 2,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(9)),
          child: Material(
            color: Colors.white,
            child: InkWell(
              onLongPress: () {
                widget.onLongTap(member);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.mqSize.width * 0.03,
                  vertical: context.mqSize.height * 0.014,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: context.mqSize.height * 0.028,
                          backgroundImage: AssetImage(
                            'assets/images/profile_picture$randomNumber.jpg',
                          ),
                        ),
                        SizedBox(
                          width: context.mqSize.width * 0.044,
                        ),
                        SizedBox(
                          width: context.mqSize.width * 0.42,
                          child: Text(
                            member.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: context.mqSize.height * 0.023,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Visibility(
                          visible: member.isAdmin,
                          child: SvgPicture.asset(
                            'assets/icons/crown.svg',
                            height: context.mqSize.height * 0.025,
                          ),
                        ),
                        SizedBox(
                          width: context.mqSize.width * 0.044,
                        ),
                        SizedBox(
                          width: context.mqSize.width * 0.085,
                          child: TextField(
                            onChanged: (newScore) {
                              final member = widget.member;
                              final updatedMember = Member(
                                id: member.id,
                                name: member.name,
                                isAdmin: member.isAdmin,
                                score: int.tryParse(newScore),
                              );
                              widget.onChanged(updatedMember);
                            },
                            autocorrect: false,
                            controller: _textController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: '0',
                              fillColor: const Color(0xffF1F2F6),
                              filled: true,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: context.mqSize.height * 0.008,
                                horizontal: context.mqSize.width * 0.008,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
