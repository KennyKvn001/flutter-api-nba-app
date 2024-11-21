import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/team.dart';

class TeamProvider with ChangeNotifier {
  List<Team> _teams = [];
  bool _isLoading = false;
  String _error = '';

  // Getters
  List<Team> get teams => _teams;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Method to fetch teams
  Future<void> fetchTeams() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // API key from .env
      final apiKey = dotenv.env['API_KEY'] ?? '';

      // Api calling
      var response = await http.get(
        Uri.https('api.balldontlie.io', '/v1/teams/'),
        headers: {
          'Authorization': apiKey,
        },
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        // Clear previous teams
        _teams.clear();

        // Creating Team objects
        for (var eachTeam in jsonData['data']) {
          final team = Team(
            abbreviation: eachTeam['abbreviation'],
            full_name: eachTeam['full_name'],
          );
          _teams.add(team);
        }

        _isLoading = false;
        notifyListeners();
      } else {
        _error = 'Error: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error fetching teams: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
}
