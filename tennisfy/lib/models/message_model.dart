class Message {
  String senderUID;
  String revieverUID;
  String message;
  bool isRead;
  DateTime timeSent;
  Message(
      {required this.senderUID,
      required this.revieverUID,
      required this.message,
      required this.isRead,
      required this.timeSent});

  Map<String, dynamic> toJson() => {
        'SenderUID': senderUID,
        'RecieverUID': revieverUID,
        'Message': message,
        'IsRead': isRead,
        'TimeSent': dateAndTimeToFirebase(timeSent)
      };

  static fromJson(Map<String, dynamic> json) {
    return Message(
        senderUID: json['SenderUID'],
        revieverUID: json['RecieverUID'],
        message: json['Message'],
        isRead: json['IsRead'],
        timeSent: dateAndTimeFromFirebase(json['TimeSent']));
  }
}

Map dateAndTimeToFirebase(DateTime date) {
  return {
    'Second': date.second,
    'Minute': date.minute,
    'Hour': date.hour,
    'Day': date.day,
    'Month': date.month,
    'Year': date.year,
  };
}

DateTime dateAndTimeFromFirebase(Map<String, dynamic> encoded) {
  var second = encoded['Second'];
  var minute = encoded['Minute'];
  var hour = encoded['Hour'];
  var day = encoded['Day'];
  var month = encoded['Month'];
  var year = encoded['Year'];
  DateTime dateTime = DateTime(year, month, day, hour, minute, second);

  return dateTime;
}
