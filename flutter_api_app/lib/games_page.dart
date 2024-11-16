import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_api_app/models/games.dart';
import 'package:flutter_api_app/models/team.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({super.key});

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  List<Game> games = [];

  Future<void> loadGames() async {
    try {
      // Load the JSON file from the assets
      final String jsonString =
          await rootBundle.loadString('lib/images/mock_games.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      setState(() {
        games = (jsonData['data'] as List).map((gameData) {
          return Game(
            season: gameData['season'],
            status: gameData['status'],
            homeTeamScore: gameData['home_team_score'],
            visitorTeamScore: gameData['visitor_team_score'],
            homeTeam: Team(
              abbreviation: gameData['home_team']['abbreviation'],
              full_name: gameData['home_team']['full_name'],
            ),
            visitorTeam: Team(
              abbreviation: gameData['visitor_team']['abbreviation'],
              full_name: gameData['visitor_team']['full_name'],
            ),
          );
        }).toList();
      });
    } catch (e) {
      print('Error loading games: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'NBA Games',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 60, 93, 163),
      ),
      body: games.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Season ${game.season}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: game.status == 'Final'
                                      ? Color.fromARGB(255, 60, 93, 163)
                                      : Color.fromARGB(255, 60, 93, 163),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  game.status,
                                  style: TextStyle(
                                    color: game.status == 'Final'
                                        ? Colors.white
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Home Team
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  game.homeTeam.full_name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Text(
                                '${game.homeTeamScore}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Visitor Team
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  game.visitorTeam.full_name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Text(
                                '${game.visitorTeamScore}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
