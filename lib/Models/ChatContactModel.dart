class ChatContactModel {
  final String name;
  final String lastMessage;
  final String contactId;
  final String profilePic;
  final DateTime sentTime;

  ChatContactModel({
    required this.name,
    required this.lastMessage,
    required this.contactId,
    required this.profilePic,
    required this.sentTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastMessage': lastMessage,
      'contactId': contactId,
      'profilePic': profilePic,
      'sentTime': sentTime.millisecondsSinceEpoch,
    };
  }

  factory ChatContactModel.fromMap(Map<String, dynamic> map) {
    return ChatContactModel(
      name: map['name'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      contactId: map['contactId'] ?? '',
      profilePic: map['profilePic'] ?? '',
      sentTime: DateTime.fromMillisecondsSinceEpoch(map['sentTime']),
    );
  }
}
