import 'package:facebook_results/services/google_app_script/json_constants.dart';

class Sheet {
  final String id;
  final String name;

  Sheet(this.id, this.name);

  Sheet.fromJSON(Map<String, dynamic> json)
      : id = json[keySheetId].toString(),
        name = json[keySheetName] as String;
}
