import 'package:bloc/bloc.dart';
import 'package:facebook_results/services/google_app_script/bloc/gas_event.dart';
import 'package:facebook_results/services/google_app_script/bloc/gas_state.dart';
import 'package:facebook_results/services/google_app_script/google_app_script_service.dart';
import 'package:facebook_results/services/google_app_script/json_constants.dart';
import 'dart:developer' as devtools show log;

import 'package:facebook_results/services/google_app_script/models/member.dart';

class GASBloc extends Bloc<GASEvent, GASState> {
  GASBloc(GoogleAppScriptService service)
      : super(const GASStateEmpty(isLoading: false)) {
    on<GASEventPrepareResultSheet>(
      (event, emit) async {
        int? sheetId;
        try {
          emit(
            const GASStateCreatingResult(
              isLoading: true,
              loadingText:
                  'Please wait a moment while we prepare result sheet!',
              originalMembersList: [],
              exception: null,
            ),
          );
          sheetId = await service.createNewSheet();
          final membersList = await service.getAllMembersData();
          emit(
            GASStateCreatingResult(
              isLoading: false,
              originalMembersList: membersList,
              operatedMembersList: List.from(membersList),
              sheetId: sheetId,
              exception: null,
            ),
          );
        } catch (error) {
          emit(
            GASStateCreatingResult(
              isLoading: false,
              originalMembersList: const [],
              exception: Exception(error),
              sheetId: sheetId,
            ),
          );
          devtools.log('Error: $error');
          rethrow;
        }
      },
    );

    on<GASEventDeleteSheet>(
      (event, emit) async {
        try {
          emit(const GASStateEmpty(
            isLoading: true,
            loadingText: 'Please wait while we delete sheet!',
          ));
          await service.deleteSheet(sheetId: event.sheetId);
          emit(const GASStateEmpty(
            isLoading: false,
            successMessage: 'Result deleted successfully!',
          ));
        } catch (error) {
          emit(GASStateEmpty(
            isLoading: false,
            exception: Exception(error),
          ));
          devtools.log('Error: $error');
          rethrow;
        }
      },
    );

    on<GASEventAddMember>(
      (event, emit) async {
        late final GASStateCreatingResult currentState;
        if (state is GASStateCreatingResult) {
          currentState = state as GASStateCreatingResult;
        }
        try {
          emit(
            GASStateCreatingResult(
              isLoading: true,
              loadingText: 'Please wait while member is adding!',
              sheetId: currentState.sheetId,
              originalMembersList: currentState.originalMembersList,
              exception: null,
            ),
          );
          final memberName = event.memberName;
          final memberScore = event.score;
          final isAdmin = event.isAdmin;
          final scoreList = event.scoreList;

          // Adding new member!
          final memberId = await service.addNewMember(
            memberName: memberName,
            isAdmin: isAdmin,
          );
          final member = Member(
            id: memberId,
            name: memberName,
            isAdmin: isAdmin,
            score: memberScore,
          );
          scoreList.add(member);
          emit(
            GASStateCreatingResult(
              isLoading: false,
              originalMembersList: currentState.originalMembersList,
              sheetId: currentState.sheetId,
              operatedMembersList: scoreList,
              exception: null,
              successMessage: 'Member added successfully!',
            ),
          );
        } catch (error) {
          devtools.log('Error: $error');
          emit(GASStateCreatingResult(
            isLoading: false,
            originalMembersList: currentState.originalMembersList,
            operatedMembersList: currentState.operatedMembersList,
            sheetId: currentState.sheetId,
            exception: Exception(error),
          ));
          rethrow;
        }
      },
    );

    on<GASEventUpdateMember>(
      (event, emit) async {
        late final GASStateCreatingResult currentState;
        if (state is GASStateCreatingResult) {
          currentState = state as GASStateCreatingResult;
        }
        try {
          emit(
            GASStateCreatingResult(
              isLoading: true,
              loadingText: 'Please wait while member details is updating!',
              sheetId: currentState.sheetId,
              originalMembersList: currentState.originalMembersList,
              operatedMembersList: currentState.operatedMembersList,
              exception: null,
            ),
          );
          final member = event.member;
          final scoreList = event.scoreList;

          // Updating member details
          await service.updateMemberDetails(member: member);

          final updateIndex =
              scoreList.indexWhere((listmember) => listmember == member);
          if (updateIndex > -1) {
            scoreList[updateIndex] = member;
          } else {
            throw Exception(
              'The member you are trying to update doesn\'t exist!',
            );
          }
          emit(
            GASStateCreatingResult(
              isLoading: false,
              originalMembersList: currentState.originalMembersList,
              sheetId: currentState.sheetId,
              operatedMembersList: scoreList,
              exception: null,
              successMessage: 'Member updated successfully!',
            ),
          );
        } catch (error) {
          devtools.log('Error: $error');
          emit(GASStateCreatingResult(
            isLoading: false,
            originalMembersList: currentState.originalMembersList,
            operatedMembersList: currentState.operatedMembersList,
            sheetId: currentState.sheetId,
            exception: Exception(error),
          ));
          rethrow;
        }
      },
    );

    on<GASEventDeleteMember>(
      (event, emit) async {
        late final GASStateCreatingResult currentState;
        if (state is GASStateCreatingResult) {
          currentState = state as GASStateCreatingResult;
        }
        try {
          final memberToBeDeleted = event.member;
          final scoreList = event.scoreList;
          final sheetId = event.sheetId;
          emit(
            GASStateCreatingResult(
              isLoading: true,
              loadingText: 'Please wait while we delete',
              originalMembersList: currentState.originalMembersList,
              operatedMembersList: currentState.operatedMembersList,
              sheetId: currentState.sheetId,
              exception: null,
            ),
          );
          await service.deleteMember(
            memberId: memberToBeDeleted.id,
            sheetId: sheetId,
          );
          final indexToBeDeleted = scoreList.indexWhere(
            (listMember) => listMember == memberToBeDeleted,
          );
          if (indexToBeDeleted > -1) {
            scoreList.removeAt(indexToBeDeleted);
          } else {
            throw Exception('The member does not exist in the score list!');
          }
          emit(
            GASStateCreatingResult(
              isLoading: false,
              originalMembersList: currentState.originalMembersList,
              operatedMembersList: scoreList,
              sheetId: currentState.sheetId,
              exception: null,
              successMessage: 'Member deleted successfully!',
            ),
          );
        } catch (error) {
          devtools.log('Error: $error');
          emit(GASStateCreatingResult(
            isLoading: false,
            originalMembersList: currentState.originalMembersList,
            operatedMembersList: currentState.operatedMembersList,
            sheetId: currentState.sheetId,
            exception: Exception(error),
          ));
          rethrow;
        }
      },
    );

    on<GASEventGetSheetData>(
      (event, emit) async {
        try {
          final sheetId = event.sheetId;
          emit(
            GASStateCreatingResult(
              isLoading: true,
              loadingText: 'Please wait while we are fetching data!',
              originalMembersList: const [],
              sheetId: sheetId,
              exception: null,
            ),
          );
          final dataList = await service.getAllMembersData(sheetId: sheetId);
          emit(
            GASStateCreatingResult(
              isLoading: false,
              originalMembersList: dataList,
              operatedMembersList: List.from(dataList),
              sheetId: sheetId,
              exception: null,
            ),
          );
        } catch (error) {
          devtools.log('Error: $error');
          rethrow;
        }
      },
    );

    on<GASEventHistorySheets>(
      (event, emit) async {
        try {
          emit(
            const GASStateResultHistory(
              isLoading: true,
              loadingText: 'Please wait while we fetch the history!',
              sheetsList: [],
              exception: null,
            ),
          );
          final sheetsList = await service.getAllSheetsData();
          emit(
            GASStateResultHistory(
              isLoading: false,
              sheetsList: sheetsList,
              exception: null,
            ),
          );
        } catch (error) {
          devtools.log('Error: $error');
          rethrow;
        }
      },
    );

    on<GASEventUpdateScoredata>(
      (event, emit) async {
        List<Member> oldScoreList = [];
        if (state is GASStateCreatingResult) {
          final currentState = state as GASStateCreatingResult;
          oldScoreList = currentState.originalMembersList;
        } else if (state is GASStateResultReady) {
          final currentState = state as GASStateResultReady;
          oldScoreList = currentState.originalDataList;
        }
        final isCopy = event.isCopy;
        List<Member> updatedScoreList = isCopy ? [] : event.scoreList;
        try {
          final isUpdating = event.isUpdating;
          final sheetId = event.sheetId;
          final Map<String, dynamic> scoredata = {};

          emit(
            GASStateResultReady(
              isLoading: true,
              loadingText:
                  'Please wait while your result is ${isUpdating ? 'updating' : 'adding'}!',
              sortedDataList: const [],
              originalDataList: const [],
            ),
          );

          if (!isCopy) {
            if (isUpdating) {
              for (var updatedMember in updatedScoreList) {
                final exist = oldScoreList.contains(updatedMember);

                if (exist) {
                  final oldData = oldScoreList.firstWhere(
                    (listMember) => listMember == updatedMember,
                  );

                  if (oldData.isAdmin != updatedMember.isAdmin ||
                      oldData.score != updatedMember.score ||
                      oldData.name != updatedMember.name) {
                    scoredataEntryForUpdateCall(scoredata, updatedMember);
                  }
                }
                // This is for the new member added case.
                else {
                  scoredataEntryForUpdateCall(scoredata, updatedMember);
                }
              }
            } else {
              for (var updatedMember in updatedScoreList) {
                scoredataEntryForUpdateCall(scoredata, updatedMember);
              }
            }

            updatedScoreList
                .sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));

            if (scoredata.isNotEmpty) {
              await service.updateScoreData(
                sheetId: sheetId,
                scoredata: scoredata,
              );
            }
          } else {
            updatedScoreList =
                await service.getAllMembersData(sheetId: sheetId);
            updatedScoreList
                .sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));
          }
          emit(GASStateResultReady(
            isLoading: false,
            sortedDataList: updatedScoreList,
            originalDataList: oldScoreList,
            successMessage: 'Result added successfully!',
          ));
        } catch (error) {
          devtools.log('Error: $error');
          emit(GASStateResultReady(
            isLoading: false,
            sortedDataList: updatedScoreList,
            originalDataList: oldScoreList,
            exception: Exception(error),
          ));
          rethrow;
        }
      },
    );

    on<GASEventResetState>(
      (event, emit) {
        final shouldEmptyState = event.shouldEmptyState;

        if (!shouldEmptyState) {
          if (state is GASStateCreatingResult) {
            final currentState = state as GASStateCreatingResult;
            emit(GASStateCreatingResult(
              isLoading: currentState.isLoading,
              originalMembersList: currentState.originalMembersList,
              exception: null,
              loadingText: currentState.loadingText,
              operatedMembersList: currentState.operatedMembersList,
              sheetId: currentState.sheetId,
              successMessage: currentState.successMessage,
            ));
          } else if (state is GASStateEmpty) {
            final currentState = state as GASStateEmpty;
            emit(GASStateEmpty(
              isLoading: currentState.isLoading,
              exception: null,
              loadingText: currentState.loadingText,
              successMessage: currentState.successMessage,
            ));
          } else if (state is GASStateResultHistory) {
            final currentState = state as GASStateResultHistory;
            emit(GASStateResultHistory(
              isLoading: currentState.isLoading,
              sheetsList: currentState.sheetsList,
              exception: null,
              loadingText: currentState.loadingText,
              successMessage: currentState.successMessage,
            ));
          } else if (state is GASStateResultReady) {
            final currentState = state as GASStateResultReady;
            emit(GASStateResultReady(
              isLoading: currentState.isLoading,
              sortedDataList: currentState.sortedDataList,
              originalDataList: currentState.originalDataList,
              exception: null,
              loadingText: currentState.loadingText,
              successMessage: currentState.successMessage,
            ));
          }
        } else {
          emit(const GASStateEmpty(
            isLoading: false,
          ));
        }
      },
    );
  }
}

void scoredataEntryForUpdateCall(Map<String, dynamic> map, Member member) {
  map[member.id] = {
    keyMemberName: member.name,
    keyIsAdmin: member.isAdmin,
    keyScore: member.score,
  };
}
