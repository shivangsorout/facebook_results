import 'package:facebook_results/services/google_app_script/models/member.dart';
import 'package:facebook_results/services/google_app_script/models/sheet.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class GASState {
  final bool isLoading;
  final String? loadingText;
  final Exception? exception;
  final String successMessage;

  const GASState({
    required this.isLoading,
    this.loadingText = "Please wait a moment!",
    this.exception,
    this.successMessage = '',
  });
}

class GASStateCreatingResult extends GASState {
  final List<Member> originalMembersList;
  final int? sheetId;
  final List<Member>? operatedMembersList;

  const GASStateCreatingResult({
    required super.isLoading,
    super.loadingText,
    required this.originalMembersList,
    this.operatedMembersList = const [],
    this.sheetId,
    required super.exception,
    super.successMessage,
  });
}

class GASStateResultReady extends GASState {
  final List<Member> sortedDataList;

  const GASStateResultReady({
    required super.isLoading,
    super.loadingText,
    required this.sortedDataList,
    super.exception,
    super.successMessage,
  });
}

class GASStateResultHistory extends GASState {
  final List<Sheet> sheetsList;

  const GASStateResultHistory({
    required super.isLoading,
    super.loadingText,
    required this.sheetsList,
    required super.exception,
    super.successMessage,
  });
}

class GASStateEmpty extends GASState {
  const GASStateEmpty({
    required super.isLoading,
    super.loadingText,
    super.exception,
    super.successMessage,
  });
}
