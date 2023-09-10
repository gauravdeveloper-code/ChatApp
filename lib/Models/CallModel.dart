class CallModel
{
  String callerId;
  String receiverId;
  String callUid;
  String profilePic;
  int duration;
  DateTime timeCalled;

  CallModel({
    required this.callerId,
    required this.receiverId,
    required this.callUid,
    required this.duration,
    required this.timeCalled,
    required this.profilePic,
  });

  Map<String, dynamic> toMap() {
    return {
      'callerId': callerId,
      'receiverId': receiverId,
      'callUid': callUid,
      'duration': duration,
      'timeCalled': timeCalled.millisecondsSinceEpoch,
      'profilePic' : profilePic,
    };
  }

  factory CallModel.fromMap(Map<String, dynamic> map) {
    return CallModel(
      callerId: map['callerId'] as String,
      receiverId: map['receiverId'] as String,
      callUid: map['callUid'] as String,
      duration: map['duration'] as int,
      timeCalled: DateTime.fromMillisecondsSinceEpoch(map['timeCalled']),
      profilePic: map['profilePic'] as String,
    );
  }
}