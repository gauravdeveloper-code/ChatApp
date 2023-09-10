class CallingStateModel{
  final String callerId;
  final bool request;
  final String roomId;
  final String profilePic;
  final String callerName;

  const CallingStateModel({
    required this.callerId,
    required this.request,
    required this.roomId,
    required this.profilePic,
    required this.callerName,
  });

  Map<String, dynamic> toMap() {
    return {
      'callerId': callerId,
      'request': request,
      'roomId': roomId,
      'profilePic':profilePic,
      'callerName':callerName,
    };
  }

  factory CallingStateModel.fromMap(Map<String, dynamic> map) {
    return CallingStateModel(
      callerId: map['callerId'] as String,
      request: map['request'] as bool,
      roomId: map['roomId'] as String,
      profilePic: map['profilePic'] as String,
      callerName: map['callerName'] as String,
    );
  }
}
