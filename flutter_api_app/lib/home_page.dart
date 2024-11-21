import 'package:flutter/material.dart';
import 'package:flutter_api_app/team_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Fetch teams when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeamProvider>().fetchTeams();
    });
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
      body: Consumer<TeamProvider>(
        builder: (context, teamProvider, child) {
          // Check loading state
          if (teamProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Check for errors
          if (teamProvider.error.isNotEmpty) {
            return Center(
              child: Text(
                'Error: ${teamProvider.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // Build list of teams
          return ListView.builder(
            itemCount: teamProvider.teams.length,
            itemBuilder: (context, index) {
              final team = teamProvider.teams[index];
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
                        team.abbreviation,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      team.full_name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(team.abbreviation),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
