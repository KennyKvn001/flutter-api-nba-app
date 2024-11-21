import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_api_app/models/players.dart';
import 'package:flutter_api_app/models/team.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PlayersPage extends StatelessWidget {
  PlayersPage({super.key});

  final List<Players> players = [];

  Future getPlayers() async {
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
          players.add(player);
        }

        print('Loaded ${players.length} players');
      }
    } catch (e) {
      print('Error fetching players: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'NBA Players',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 60, 93, 163),
      ),
      body: FutureBuilder(
        future: getPlayers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (players.isEmpty) {
              return const Center(
                child: Text('No players found'),
              );
            }

            return ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 60, 93, 163),
                        child: Text(
                          player.position,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Row(
                        children: [
                          Text(
                            player.first_name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            player.last_name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Icon(Icons.sports_basketball,
                              size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${player.team.full_name} (${player.team.abbreviation})',
                            style: TextStyle(color: Colors.grey[700]),
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
