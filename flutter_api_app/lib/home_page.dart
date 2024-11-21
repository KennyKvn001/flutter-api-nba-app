import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_api_app/models/team.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Team> teams = [];

  // get teams
  Future getTeams() async {
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

        // Creating Team object
        for (var eachTeam in jsonData['data']) {
          final team = Team(
            abbreviation: eachTeam['abbreviation'],
            full_name: eachTeam['full_name'],
          );
          teams.add(team);
        }

        print(teams.length);
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching teams: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'NBA teams',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 60, 93, 163),
      ),
      body: FutureBuilder(
          future: getTeams(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: teams.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.red[800],
                          child: Text(
                            teams[index].abbreviation,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          teams[index].full_name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(teams[index].abbreviation),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
