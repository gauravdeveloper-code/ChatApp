import 'package:chat_app/Common/Enums/MessageEnum.dart';

class MessageModel {
  final String text;
  final String repliedTo;
  final String repliedMessage;
  final String receiverId;
  final String senderId;
  final String messageId;
  final DateTime timeSent;
  final bool isSeen;
  final MessageEnum messageType;
  final MessageEnum repliedMessageType;

  MessageModel({
    required this.text,
    required this.receiverId,
    required this.senderId,
    required this.messageId,
    required this.timeSent,
    required this.isSeen,
    required this.messageType,
    required this.repliedMessageType,
    required this.repliedMessage,
    required this.repliedTo,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'receiverId': receiverId,
      'senderId': senderId,
      'messageId': messageId,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'isSeen': isSeen,
      'messageType': messageType.type,
      'repliedMessageType': repliedMessageType.type,
      'repliedTo' : repliedTo,
      'repliedMessage' : repliedMessage,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      text: map['text'] ?? '',
      receiverId: map['receiverId'] ?? '',
      senderId: map['senderId'] ?? '',
      messageId: map['messageId'] ?? '',
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      isSeen: map['isSeen'] ?? false,
      messageType: (map['messageType'] as String).toEnum(),
      repliedMessageType: (map['repliedMessageType'] as String).toEnum(),
      repliedMessage: map['repliedMessage']??'',
      repliedTo: map['repliedTo'] ?? '',
    );
  }
}
