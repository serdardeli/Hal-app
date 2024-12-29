import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class TimeService {
  static TimeService? _instance;

  static TimeService get instance => _instance ??= TimeService._init();

  TimeService._init();
  Future<DateTime?> getTime() async {
    try {
      var url = Uri.parse(
          'https://timeapi.io/api/Time/current/zone?timeZone=Etc/GMT-3');
      var response = await http.get(url);


      if (response.statusCode == 200) {
        Map valueMap = json.decode(response.body);
        return DateTime.parse(valueMap["dateTime"]);
      }
    } catch (e) {

    }
    return null;
  }
}
