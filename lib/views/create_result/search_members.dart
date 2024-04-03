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
  final FocusNode _searchFocusNode = FocusNode();
  String _currentSearchQuery = '';

  @override
  void initState() {
    _searchController = TextEditingController();
    _filteredMembers = [];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    myList = args['scoreList'];
    onScoreChange = args['callback'];
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentSearchQuery.isEmpty) {
      _filteredMembers = myList;
    } else {
      _filterMembers(_currentSearchQuery);
    }
    return Scaffold(
      appBar: AppBar(
        title: Listener(
          onPointerDown: (_) {
            _searchFocusNode.requestFocus();
          },
          child: TextField(
            focusNode: _searchFocusNode,
            onSubmitted: (value) {
              setState(() {
                _currentSearchQuery = value;
              });
              // _searchController.clear();
            },
            autofocus: true,
            controller: _searchController,
            onChanged: _filterMembers,
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

  void _filterMembers(String query) {
    query = query.toLowerCase();
    setState(() {
      _currentSearchQuery = query;
      _filteredMembers = myList
          .where((member) =>
              member.name.toLowerCase().contains(_currentSearchQuery))
          .toList();
    });
  }
}
