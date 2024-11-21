import 'package:flutter/material.dart';
import 'package:flutter_api_app/players_provider.dart';
import 'package:provider/provider.dart';

class PlayersPage extends StatefulWidget {
  const PlayersPage({super.key});

  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  @override
  void initState() {
    super.initState();
    // Fetch players when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlayersProvider>().fetchPlayers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'NBA Players',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 60, 93, 163),
      ),
      body: Consumer<PlayersProvider>(
        builder: (context, playersProvider, child) {
          // Check loading state
          if (playersProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Check for errors
          if (playersProvider.error.isNotEmpty) {
            return Center(
              child: Text(
                'Error: ${playersProvider.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // Check if players list is empty
          if (playersProvider.players.isEmpty) {
            return const Center(
              child: Text('No players found'),
            );
          }

          // Build list of players
          return ListView.builder(
            itemCount: playersProvider.players.length,
            itemBuilder: (context, index) {
              final player = playersProvider.players[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 60, 93, 163),
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
        },
      ),
    );
  }
}
