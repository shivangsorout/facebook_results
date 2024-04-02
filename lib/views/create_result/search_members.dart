import 'package:facebook_results/extensions/buildcontext/media_query_size.dart';
import 'package:facebook_results/helpers/custom_widgets/result_list_tile.dart';
import 'package:facebook_results/services/google_app_script/models/member.dart';
import 'package:facebook_results/views/create_result/create_result_view.dart';
import 'package:flutter/material.dart';

class SearchMembersView extends StatefulWidget {
  // final List<Member> scoreList;
  // final void Function(Member) onScoreChange;

  const SearchMembersView({
    super.key,
    // required this.scoreList,
  });

  @override
  State<SearchMembersView> createState() => _SearchMembersViewState();
}

class _SearchMembersViewState extends State<SearchMembersView> {
  late final TextEditingController _searchController;
  late List<Member> _filteredMembers;
  late void Function(Member) onScoreChange;
  late List<Member> myList;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    myList = args['scoreList'];
    onScoreChange = args['callback'];
    _filteredMembers = myList;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onSubmitted: (value) {
            _searchController.clear();
          },
          autofocus: true,
          controller: _searchController,
          onChanged: (query) {
            setState(() {
              _filteredMembers = _filterMembers(query);
            });
          },
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(
              color: const Color(0xff686868),
              fontSize: context.mqSize.height * 0.019,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.mqSize.width * 0.06,
              vertical: context.mqSize.height * 0.014,
            ),
            filled: true,
            fillColor: const Color(0xffEFEFEF),
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      body: _filteredMembers.isEmpty
          ? Padding(
              padding: EdgeInsets.all(context.mqSize.height * 0.016),
              child: Text(
                'No member exist with this name!',
                style: TextStyle(
                  fontSize: context.mqSize.height * 0.023,
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(context.mqSize.height * 0.016),
              itemCount: _filteredMembers.length,
              itemBuilder: (context, index) {
                return ResultListTile(
                  member: _filteredMembers[index],
                  onChanged: onScoreChange,
                  onLongTap: (member) {
                    showBottomMenu(
                      context: context,
                      selectedMember: member,
                      index: index,
                    );
                  },
                );
              },
            ),
    );
  }

  List<Member> _filterMembers(String query) {
    query = query.toLowerCase();
    return myList
        .where((member) => member.name.toLowerCase().contains(query))
        .toList();
  }
}
