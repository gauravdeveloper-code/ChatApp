import 'package:chat_app/Common/Enums/MessageEnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageProvider =  StateProvider<MessageReply?>((ref) => null);

class MessageReply {
  final String message;
  final MessageEnum messageEnum;
  final bool isme;

  MessageReply(
      {required this.messageEnum, required this.message, required this.isme});
}
