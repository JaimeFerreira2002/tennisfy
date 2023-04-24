class GameInvite {
  String senderUID;
  bool isCompetitive;
  String? inviteMessage;

  GameInvite(
      {required this.senderUID,
      required this.isCompetitive,
      this.inviteMessage});

  Map<String, dynamic> toJson() => {
        'SenderUID': senderUID,
        'IsCompetitive': isCompetitive,
        'InviteMessage': inviteMessage
      };

  static fromJson(Map<String, dynamic> json) {
    return GameInvite(
        senderUID: json['SenderUID'],
        isCompetitive: json['IsCompetitive'],
        inviteMessage: json['InviteMessage'] ??
            json['InviteMessage']); //simplify this code
  }
}
