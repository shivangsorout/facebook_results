import 'package:facebook_results/constants/constants.dart';
import 'package:facebook_results/constants/routes.dart';
import 'package:facebook_results/extensions/buildcontext/media_query_size.dart';
import 'package:facebook_results/services/google_app_script/bloc/gas_bloc.dart';
import 'package:facebook_results/services/google_app_script/bloc/gas_event.dart';
import 'package:facebook_results/services/google_app_script/bloc/gas_state.dart';
import 'package:facebook_results/services/google_app_script/models/sheet.dart';
import 'package:facebook_results/utility/generics/edit_and_copy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'dart:developer' as devtools show log;

import 'package:intl/intl.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  List<Sheet> historySheets = [];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GASBloc, GASState>(
      builder: (context, state) {
        if (state is GASStateResultHistory) {
          if (historySheets.isEmpty) {
            historySheets = List.from(state.sheetsList);
            historySheets.sort((a, b) =>
                int.tryParse(b.name)!.compareTo(int.tryParse(a.name)!));
          }
        }
        return PopScope(
          canPop: !state.isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('History'),
              centerTitle: true,
            ),
            body: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: context.mqSize.width * 0.044,
                vertical: context.mqSize.height * 0.011,
              ),
              itemBuilder: (context, index) {
                final Sheet historySheet = historySheets[index];

                // Getting time in epoch
                int epochTime = int.parse(historySheet.name) * 1000;

                // Getting time in DateTime
                DateTime dateTime =
                    DateTime.fromMillisecondsSinceEpoch(epochTime);

                // Format the date and time
                String formattedDate = DateFormat('d MMM, yyyy')
                    .format(dateTime); // Format for date
                String formattedTime =
                    DateFormat('hh:mm a').format(dateTime); // Format for time

                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: context.mqSize.height * 0.007),
                  child: Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 4,
                    child: ListTile(
                      onTap: () {
                        showEditAndCopyDialog(context).then((value) {
                          if (value == 'Edit') {
                            context.read<GASBloc>().add(
                                  GASEventGetSheetData(
                                    sheetId: int.parse(historySheet.id),
                                  ),
                                );
                            Navigator.of(context).pushNamed(
                              createResultRoute,
                              arguments: {
                                argKeyIsUpdating: true,
                              },
                            );
                          } else if (value == 'Copy') {
                            context.read<GASBloc>().add(
                                  GASEventUpdateScoredata(
                                    sheetId: int.parse(historySheet.id),
                                    scoreList: const [],
                                    isCopy: true,
                                  ),
                                );
                            Navigator.of(context).pushNamed(resultReadyRoute);
                          }
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: context.mqSize.width * 0.05,
                        vertical: context.mqSize.height * 0.012,
                      ),
                      tileColor: Colors.white,
                      leading: SvgPicture.asset(
                        'assets/icons/calendar.svg',
                        height: context.mqSize.height * 0.041,
                      ),
                      title: Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: context.mqSize.height * 0.021,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Text(
                        formattedTime,
                        style: TextStyle(
                          fontSize: context.mqSize.height * 0.021,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffA4A4A4),
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: historySheets.length,
            ),
          ),
        );
      },
    );
  }
}
