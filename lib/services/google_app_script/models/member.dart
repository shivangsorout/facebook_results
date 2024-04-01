import 'package:facebook_results/services/google_app_script/json_constants.dart';

class Member {
  final String id;
  final String name;
  final bool isAdmin;
  final int? score;

  Member({
    required this.id,
    required this.name,
    required this.isAdmin,
    this.score,
  });

  Member.fromJSON(Map<String, dynamic> json)
      : id = json[keyMemberId].toString(),
        name = json[keyMemberName] as String,
        isAdmin = json[keyIsAdmin] as bool,
        score = json[keyScore] as int?;

  Map<String, dynamic> toJSON() => {
        keyMemberId: id,
        keyMemberName: name,
        keyIsAdmin: isAdmin,
        keyScore: score,
      };

  @override
  bool operator ==(covariant Member other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Member Details =>  Member Id: $id, Member Name: $name, Member IsAdmin: $isAdmin, Member Score: $score';
}
