import 'package:facebook_results/services/google_app_script/models/member.dart';
import 'package:facebook_results/services/google_app_script/models/sheet.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class GASState {
  final bool isLoading;
  final String? loadingText;

  const GASState({
    required this.isLoading,
    this.loadingText = "Please wait a moment!",
  });
}

class GASStateCreatingResult extends GASState {
  final List<Member> originalMembersList;
  final int? sheetId;
  final Exception? exception;
  final List<Member>? operatedMembersList;

  const GASStateCreatingResult({
    required super.isLoading,
    super.loadingText,
    required this.originalMembersList,
    this.operatedMembersList = const [],
    this.sheetId,
    required this.exception,
  });
}

class GASStateResultReady extends GASState {
  final List<Member> sortedDataList;

  const GASStateResultReady({
    required super.isLoading,
    super.loadingText,
    required this.sortedDataList,
  });
}

class GASStateResultHistory extends GASState {
  final List<Sheet> sheetsList;
  final Exception? exception;

  const GASStateResultHistory({
    required super.isLoading,
    super.loadingText,
    required this.sheetsList,
    required this.exception,
  });
}

class GASStateEmpty extends GASState {
  const GASStateEmpty({
    required super.isLoading,
    super.loadingText,
  });
}
