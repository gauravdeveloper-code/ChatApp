class StatusModel{
  final String userName;
  final String uid;
  final String phoneNumber;
  final String profilePic;
  final String statusId;
  final List<String> statusCaption;
  final List<String>photoUrls;
  final List<String>whoCanSee;
  final DateTime createdAt;

  StatusModel({
    required this.uid,
    required this.userName,
    required this.phoneNumber,
    required this.profilePic,
    required this.statusId,
    required this.statusCaption,
    required this.photoUrls,
    required this.whoCanSee,
    required this.createdAt,
});

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'uid': uid,
      'phoneNumber': phoneNumber,
      'profilePic': profilePic,
      'statusId': statusId,
      'statusCaption': statusCaption,
      'photoUrls': photoUrls,
      'whoCanSee': whoCanSee,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory StatusModel.fromMap(Map<String, dynamic> map) {

    return StatusModel(
      uid: map['uid'] ?? '',
      userName: map['username'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      photoUrls: List<String>.from(map['photoUrl']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      profilePic: map['profilePic'] ?? '',
      statusId: map['statusId'] ?? '',
      whoCanSee: List<String>.from(map['whoCanSee']),
      statusCaption: List<String>.from(map['whoCanSee']),
    );
  }
}