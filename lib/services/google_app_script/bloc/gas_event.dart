import 'package:facebook_results/services/google_app_script/models/member.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class GASEvent {
  const GASEvent();
}

class GASEventPrepareResultSheet extends GASEvent {
  const GASEventPrepareResultSheet();
}

class GASEventDeleteSheet extends GASEvent {
  final int sheetId;

  const GASEventDeleteSheet({required this.sheetId});
}

class GASEventAddMember extends GASEvent {
  final String memberName;
  final bool isAdmin;
  final int score;
  final List<Member> scoreList;

  const GASEventAddMember({
    required this.memberName,
    this.isAdmin = false,
    this.score = 0,
    required this.scoreList,
  });
}

class GASEventUpdateMember extends GASEvent {
  final Member member;
  final List<Member> scoreList;

  const GASEventUpdateMember({
    required this.member,
    required this.scoreList,
  });
}

class GASEventDeleteMember extends GASEvent {
  final Member member;
  final int? sheetId;
  final List<Member> scoreList;

  const GASEventDeleteMember({
    required this.member,
    this.sheetId,
    required this.scoreList,
  });
}

class GASEventGetSheetData extends GASEvent {
  final int sheetId;

  const GASEventGetSheetData({required this.sheetId});
}

class GASEventHistorySheets extends GASEvent {
  const GASEventHistorySheets();
}

class GASEventUpdateScoredata extends GASEvent {
  final int sheetId;
  final List<Member> scoreList;
  final bool isUpdating;
  final bool isCopy;

  const GASEventUpdateScoredata({
    required this.sheetId,
    required this.scoreList,
    this.isUpdating = false,
    this.isCopy = false,
  });
}

class GASEventResetState extends GASEvent {
  const GASEventResetState();
}
