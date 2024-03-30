import 'package:facebook_results/services/google_app_script/dio_calls.dart';
import 'package:facebook_results/services/google_app_script/json_constants.dart';
import 'package:facebook_results/services/google_app_script/models/member.dart';
import 'dart:developer' as devtools show log;

import 'package:facebook_results/services/google_app_script/models/sheet.dart';

class GoogleAppScriptService {
  // Making this class a singleton
  factory GoogleAppScriptService() => _shared;
  static final GoogleAppScriptService _shared =
      GoogleAppScriptService._sharedInstance();
  GoogleAppScriptService._sharedInstance();

  // Get operations
  /// Get request for getting member's data.
  Future<List<Member>> getAllMembersData({int? sheetId}) async {
    try {
      final query = {
        keyAction: actionGetMembersData,
      };
      if (sheetId != null) {
        query[keySheetId] = sheetId.toString();
      }
      final response = await getRequest(queryParams: query);
      final membersList = (response[keyData] as List)
          .map((member) => Member.fromJSON(member))
          .toList();
      return membersList;
    } catch (error) {
      devtools.log('Error: $error');
      rethrow;
    }
  }

  /// Get request for getting sheet's data.
  Future<List<Sheet>> getAllSheetsData() async {
    try {
      final query = {
        keyAction: actionGetSheetInfo,
      };
      final response = await getRequest(queryParams: query);
      final sheetsList = (response.containsKey(keyData))
          ? (response[keyData] as List)
              .map((sheet) => Sheet.fromJSON(sheet))
              .toList()
          : <Sheet>[];
      return sheetsList;
    } catch (error) {
      devtools.log('Error: $error');
      rethrow;
    }
  }

  // Post operations
  /// Post request for creating new sheet.
  Future<int> createNewSheet() async {
    try {
      final query = {
        keyAction: actionPostCreateNewSheet,
      };
      final response = await postRequest(data: query);
      return response[keySheetId];
    } catch (error) {
      devtools.log('Error: $error');
      rethrow;
    }
  }

  /// Post request for deleting sheet.
  Future<void> deleteSheet({required int sheetId}) async {
    try {
      final query = {
        keyAction: actionPostDeleteSheet,
        keySheetId: sheetId.toString(),
      };
      final response = await postRequest(data: query);
      devtools.log(response[keyMessage].toString());
    } catch (error) {
      devtools.log('Error: $error');
      rethrow;
    }
  }

  /// Post request for updating scores in the sheet.
  Future<void> updateScoreData({
    required int sheetId,
    required Map<String, dynamic> scoredata,
  }) async {
    try {
      final query = {
        keyAction: actionPostUpdateScoredata,
        keySheetId: sheetId.toString(),
        keyScoredata: scoredata,
      };
      final response = await postRequest(data: query);
      devtools.log(response.toString());
    } catch (error) {
      devtools.log('Error: $error');
      rethrow;
    }
  }

  /// Post request for adding a new member in the main sheet.
  Future<String> addNewMember({
    required String memberName,
    required bool isAdmin,
  }) async {
    try {
      final query = {
        keyAction: actionPostAddNewMember,
        keyMemberName: memberName,
        keyIsAdmin: isAdmin,
      };
      final response = await postRequest(data: query);
      devtools.log(response.toString());
      return response[keyMemberId].toString();
    } catch (error) {
      devtools.log('Error: $error');
      rethrow;
    }
  }

  /// Post request for updating a member details in the main sheet.
  Future<void> updateMemberDetails({required Member member}) async {
    try {
      final query = {
        keyAction: actionPostUpdateMember,
        ...member.toJSON(),
      };
      final response = await postRequest(data: query);
      devtools.log(response.toString());
    } catch (error) {
      devtools.log('Error: $error');
      rethrow;
    }
  }

  /// Post request for deleting a member details from the main sheet.
  Future<void> deleteMember({
    required String memberId,
    int? sheetId,
  }) async {
    try {
      final query = {
        keyAction: actionPostDeleteMember,
        keyMemberId: memberId,
      };
      if (sheetId != null) {
        query[keySheetId] = sheetId.toString();
      }
      final response = await postRequest(data: query);
      devtools.log(response.toString());
    } catch (error) {
      devtools.log('Error: $error');
      rethrow;
    }
  }
}
