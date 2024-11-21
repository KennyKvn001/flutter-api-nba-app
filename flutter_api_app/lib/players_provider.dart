import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/players.dart';
import '../models/team.dart';

class PlayersProvider with ChangeNotifier {
  List<Players> _players = [];
  bool _isLoading = false;
  String _error = '';

  // Getters
  List<Players> get players => _players;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Method to fetch players
  Future<void> fetchPlayers() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // API key from .env
      final apiKey = dotenv.env['API_KEY'] ?? '';

      // Api calling
      var response = await http.get(
        Uri.https('api.balldontlie.io', '/v1/players'),
        headers: {
          'Authorization': '$apiKey',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        // Clear previous players
        _players.clear();

        for (var eachPlayer in jsonData['data']) {
          // Creating Team object first
          final team = Team(
            abbreviation: eachPlayer['team']['abbreviation'],
            full_name: eachPlayer['team']['full_name'],
          );

          // Creating Player object with the team
          final player = Players(
            first_name: eachPlayer['first_name'],
            last_name: eachPlayer['last_name'],
            position: eachPlayer['position'],
            team: team,
          );
          _players.add(player);
        }

        _isLoading = false;
        notifyListeners();
      } else {
        _error = 'Error: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error fetching players: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
}
