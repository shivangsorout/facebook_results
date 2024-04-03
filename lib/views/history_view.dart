import 'package:facebook_results/constants/routes.dart';
import 'package:facebook_results/extensions/buildcontext/media_query_size.dart';
import 'package:facebook_results/utility/generics/edit_and_copy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          return Padding(
            padding:
                EdgeInsets.symmetric(vertical: context.mqSize.height * 0.007),
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 4,
              child: ListTile(
                onTap: () {
                  showEditAndCopyDialog(context).then((value) {
                    if (value == 'Edit') {
                      Navigator.of(context)
                          .pushNamed(createResultRoute, arguments: {
                        'isUpdating': true,
                      });
                    } else if (value == 'Copy') {
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
                  '19th July, 2023',
                  style: TextStyle(
                    fontSize: context.mqSize.height * 0.021,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                trailing: Text(
                  '08:00 AM',
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
        itemCount: 2,
      ),
    );
  }
}
