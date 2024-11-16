import 'package:flutter_api_app/models/team.dart';

class Players {
  final String first_name;
  final String last_name;
  final String position;
  final Team team;

  Players({
    required this.first_name,
    required this.last_name,
    required this.position,
    required this.team,
  });
}
