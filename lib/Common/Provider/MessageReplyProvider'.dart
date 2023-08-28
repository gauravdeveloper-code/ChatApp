import 'package:chat_app/Common/Enums/MessageEnum.dart';

class MessageReply {
  final String message;
  final MessageEnum messageEnum;
  final bool isme;

  MessageReply(
      {required this.messageEnum, required this.message, required this.isme})

}