import 'package:flutter_api_app/models/team.dart';

class Game {
  final int season;
  final String status;
  final int homeTeamScore;
  final int visitorTeamScore;
  final Team homeTeam;
  final Team visitorTeam;

  Game({
    required this.season,
    required this.status,
    required this.homeTeamScore,
    required this.visitorTeamScore,
    required this.homeTeam,
    required this.visitorTeam,
  });
}
