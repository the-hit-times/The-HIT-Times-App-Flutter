class TeamDetails {
  String teamCode;
  String deptName;
  FootballTeam? football;
  CricketTeam? cricket;

  TeamDetails(
      {required this.teamCode,
      required this.deptName,
      required this.football,
      required this.cricket});

  static const FIELD_TEAM_CODE = "team_code";
  static const FIELD_DEPT_NAME = "dept_name";
  static const FIELD_FOOTBALL = "football";
  static const FIELD_CRICKET = "cricket";

  factory TeamDetails.fromJson(Map<String, dynamic> json) {
    return TeamDetails(
        teamCode: json[FIELD_TEAM_CODE],
        deptName: json[FIELD_DEPT_NAME],
        football: (json.containsKey(FIELD_FOOTBALL))
            ? FootballTeam.fromJson(json[FIELD_FOOTBALL])
            : null,
        cricket: (json.containsKey(FIELD_CRICKET))
            ? CricketTeam.fromJson(json[FIELD_CRICKET])
            : null);
  }
}

class BaseTeamDetails {
  String teamName;
  String teamLogo;
  List<PlayerDetails> players;

  static const FIELD_TEAM_NAME = "team_name";
  static const FIELD_TEAM_LOGO = "team_logo";
  static const FIELD_PLAYERS = "players";

  BaseTeamDetails(
      {required this.teamName, required this.teamLogo, required this.players});

  String? getTeamLogo() {
    if (teamLogo.contains('https://drive.google.com/file')) {
      return _getImageUrlFromDrive(teamLogo);
    }
    return teamLogo;
  }

  String _getImageUrlFromDrive(String driveImageLink) {
    String fileId = driveImageLink.substring(
        driveImageLink.indexOf('/d/') + 3, driveImageLink.indexOf('/view'));
    String newLink = 'https://drive.google.com/uc?export=view&id=$fileId';
    return newLink;
  }
}

class CricketTeam extends BaseTeamDetails {
  CricketTeam(
      {required super.teamName,
      required super.teamLogo,
      required super.players});

  factory CricketTeam.fromJson(Map<String, dynamic> json) {
    return CricketTeam(
        teamName: json[BaseTeamDetails.FIELD_TEAM_NAME],
        teamLogo: json[BaseTeamDetails.FIELD_TEAM_LOGO],
        players: json[BaseTeamDetails.FIELD_PLAYERS]
            .map<PlayerDetails>((player) => PlayerDetails.fromJson(player))
            .toList());
  }
}

class FootballTeam extends BaseTeamDetails {
  FootballTeam(
      {required super.teamName,
      required super.teamLogo,
      required super.players});

  factory FootballTeam.fromJson(Map<String, dynamic> json) {
    return FootballTeam(
        teamName: json[BaseTeamDetails.FIELD_TEAM_NAME],
        teamLogo: json[BaseTeamDetails.FIELD_TEAM_LOGO],
        players: json[BaseTeamDetails.FIELD_PLAYERS]
            .map<PlayerDetails>((player) => PlayerDetails.fromJson(player))
            .toList());
  }
}

class PlayerDetails {
  String playerName;
  String playerDescription;
  String playerImage;

  PlayerDetails(
      {required this.playerName,
      required this.playerDescription,
      required this.playerImage});

  static const FIELD_PLAYER_NAME = "player_name";
  static const FIELD_PLAYER_DESCRIPTION = "player_description";
  static const FIELD_PLAYER_IMAGE = "player_image";

  factory PlayerDetails.fromJson(Map<String, dynamic> json) {
    return PlayerDetails(
        playerName: json[FIELD_PLAYER_NAME],
        playerDescription: json[FIELD_PLAYER_DESCRIPTION],
        playerImage: json[FIELD_PLAYER_IMAGE]);
  }

  String getPlayerImage() {
    if (playerImage.contains('https://drive.google.com/file')) {
      return _getImageUrlFromDrive(playerImage);
    }
    return playerImage;
  }

  String _getImageUrlFromDrive(String driveImageLink) {
    String fileId = driveImageLink.substring(
        driveImageLink.indexOf('/d/') + 3, driveImageLink.indexOf('/view'));
    String newLink = 'https://drive.google.com/uc?export=view&id=$fileId';
    return newLink;
  }
}
