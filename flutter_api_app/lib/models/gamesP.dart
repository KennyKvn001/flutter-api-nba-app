import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_api_app/models/games.dart';
import 'package:flutter_api_app/models/team.dart';
import 'package:http/http.dart' as http;

// This page is reserved if the api works

class GamesPage extends StatelessWidget {
  GamesPage({super.key});

  final List<Game> games = [];

  Future getGame() async {
    try {
      var apiKey = "14ddd068-214e-443f-aade-e142bbdf98b3";
      var response = await http.get(
        Uri.https('api.balldontlie.io', '/v1/games'),
        headers: {
          'Authorization': '$apiKey',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        games.clear(); // Clear existing games before adding new ones

        for (var eachGame in jsonData['data']) {
          // Create home team
          final homeTeam = Team(
            abbreviation: eachGame['home_team']['abbreviation'],
            full_name: eachGame['home_team']['full_name'],
          );

          // Create visitor team
          final visitorTeam = Team(
            abbreviation: eachGame['visitor_team']['abbreviation'],
            full_name: eachGame['visitor_team']['full_name'],
          );

          // Create Games object
          final game = Game(
            season: eachGame['season'],
            status: eachGame['status'],
            homeTeamScore: eachGame['home_team_score'],
            visitorTeamScore: eachGame['visitor_team_score'],
            homeTeam: homeTeam,
            visitorTeam: visitorTeam,
          );
          games.add(game);
        }

        print('Loaded ${games.length} games');
      }
    } catch (e) {
      print('Error fetching games: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'NBA Games',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 60, 93, 163),
      ),
      body: FutureBuilder(
        future: getGame(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (games.isEmpty) {
              return const Center(
                child: Text('No games found'),
              );
            }

            return ListView.builder(
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
                                      ? Colors.green[100]
                                      : Colors.orange[100],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  game.status,
                                  style: TextStyle(
                                    color: game.status == 'Final'
                                        ? Colors.green[700]
                                        : Colors.orange[700],
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
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
