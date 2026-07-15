import 'dart:convert';
import 'package:http/http.dart' as http;

/// API integration (Module 3): fetches upcoming public holidays from the
/// free Nager.Date API (no API key required) so the planner can show
/// days off alongside the user's own tasks.
/// Docs: https://date.nager.at/Api
class Holiday {
  Holiday({required this.date, required this.name});
  final DateTime date;
  final String name;

  factory Holiday.fromJson(Map<String, dynamic> j) => Holiday(
        date: DateTime.parse(j['date'] as String),
        name: (j['localName'] ?? j['name']) as String,
      );
}

class ApiService {
  static const _base = 'https://date.nager.at/api/v3';

  /// Returns the next public holidays for [countryCode] (ISO 3166-1
  /// alpha-2, e.g. 'SA', 'US', 'IN'), soonest first.
  static Future<List<Holiday>> fetchUpcomingHolidays(
      {String countryCode = 'US', int limit = 3}) async {
    final uri = Uri.parse('$_base/NextPublicHolidays/$countryCode');
    final response =
        await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception(
          'Holiday API returned status ${response.statusCode}');
    }
    final list = jsonDecode(response.body) as List;
    return list
        .map((e) => Holiday.fromJson(e as Map<String, dynamic>))
        .take(limit)
        .toList();
  }
}
