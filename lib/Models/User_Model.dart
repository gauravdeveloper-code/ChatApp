
class UserModel {
  final String name;
  final String profilePic;
  final bool isOnline;
  final String uid;
  final String number;
  final List<String> groupId;

  UserModel({
    required this.profilePic,
    required this.name,
    required this.uid,
    required this.number,
    required this.isOnline,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilePic,
      'uid': uid,
      'number': number,
      'isOnline': isOnline,
      'groupId': groupId
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        profilePic: map['profilePic'] ?? '',
        name: map['name'] ?? '',
        uid: map['uid'] ?? '',
        number: map['number'] ?? '',
        isOnline: map['isOnline'] ?? false,
        groupId: List<String>.from(map['groupId']));
  }
}
