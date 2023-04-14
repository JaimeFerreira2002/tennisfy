import '../helpers/helper_methods.dart';

class Comment {
  String authorUID;
  DateTime datePosted;
  double reputaion;
  String content;
  Comment(
      {required this.authorUID,
      required this.datePosted,
      required this.reputaion,
      required this.content});

  Map<String, dynamic> toJson() => {
        'AuthorUID': authorUID,
        'DatePosted': dateToFirebase(datePosted),
        'Reputation': reputaion,
        'Content': content,
      };

  static fromJson(Map<String, dynamic> json) {
    return Comment(
        authorUID: json['AuthorUID'],
        datePosted: dateFromFirebase(json['DatePosted']),
        reputaion: json['Reputation'],
        content: json['Content']);
  }
}
