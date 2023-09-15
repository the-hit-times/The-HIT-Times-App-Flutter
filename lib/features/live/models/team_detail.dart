class TeamDetails {
  String teamCode;
  String deptName;
  FootballTeam football;

  TeamDetails({required this.teamCode, required this.deptName, required this.football});

  static const FIELD_TEAM_CODE = "team_code";
  static const FIELD_DEPT_NAME = "dept_name";
  static const FIELD_FOOTBALL = "football";

  factory TeamDetails.fromJson(Map<String, dynamic> json) {
    return TeamDetails(
      teamCode: json[FIELD_TEAM_CODE],
      deptName: json[FIELD_DEPT_NAME],
      football: FootballTeam.fromJson(json[FIELD_FOOTBALL])
    );
  }

}

class FootballTeam {
  String teamName;
  String teamLogo;
  List<PlayerDetails> players;

  FootballTeam({required this.teamName, required this.teamLogo, required this.players});


  static const FIELD_TEAM_NAME = "team_name";
  static const FIELD_TEAM_LOGO = "team_logo";
  static const FIELD_PLAYERS = "players";

  factory FootballTeam.fromJson(Map<String, dynamic> json) {
    return FootballTeam(
      teamName: json[FIELD_TEAM_NAME],
      teamLogo: json[FIELD_TEAM_LOGO],
      players: json[FIELD_PLAYERS].map<PlayerDetails>((player) => PlayerDetails.fromJson(player)).toList()
    );
  }

  String? getTeamLogo() {
    if (teamLogo.contains('https://drive.google.com/file')) {
      return _getImageUrlFromDrive(teamLogo);
    }
    return teamLogo;
  }


  String _getImageUrlFromDrive(String driveImageLink) {
    String fileId = driveImageLink.substring(driveImageLink.indexOf('/d/') + 3, driveImageLink.indexOf('/view'));
    String newLink = 'https://drive.google.com/uc?export=view&id=$fileId';
    return newLink;
  }

}

class PlayerDetails {
  String playerName;
  String playerDescription;
  String playerImage;

  PlayerDetails({required this.playerName, required this.playerDescription, required this.playerImage});

  static const FIELD_PLAYER_NAME = "player_name";
  static const FIELD_PLAYER_DESCRIPTION = "player_description";
  static const FIELD_PLAYER_IMAGE = "player_image";

  factory PlayerDetails.fromJson(Map<String, dynamic> json) {
    return PlayerDetails(
      playerName: json[FIELD_PLAYER_NAME],
      playerDescription: json[FIELD_PLAYER_DESCRIPTION],
      playerImage: json[FIELD_PLAYER_IMAGE]
    );
  }

  String getPlayerImage() {
    if (playerImage.contains('https://drive.google.com/file')) {
      return _getImageUrlFromDrive(playerImage);
    }
    return playerImage;
  }

  String _getImageUrlFromDrive(String driveImageLink) {
    String fileId = driveImageLink.substring(driveImageLink.indexOf('/d/') + 3, driveImageLink.indexOf('/view'));
    String newLink = 'https://drive.google.com/uc?export=view&id=$fileId';
    return newLink;
  }

}