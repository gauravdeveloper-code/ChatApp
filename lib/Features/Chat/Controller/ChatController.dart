import 'dart:io';
import 'package:chat_app/Common/Enums/MessageEnum.dart';
import 'package:chat_app/Common/Provider/MessageReplyProvider.dart';
import 'package:chat_app/Features/Auth/Controller/Auth_Controller.dart';
import 'package:chat_app/Features/Chat/Repository/ChatRepository.dart';
import 'package:chat_app/Models/ChatContactModel.dart';
import 'package:chat_app/Models/MessageModel.dart';
import 'package:chat_app/Models/group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  void sendTextMessage(String text, BuildContext context, String receiverUserId,
      bool isGroupChat) {
    final messageReply = ref.read(messageProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
              text: text,
              receiverUserId: receiverUserId,
              context: context,
              senderUser: value!,
              messageReply: messageReply,
              isGroupChat: isGroupChat),
        );
    ref.read(messageProvider.notifier).update((state) => null);
  }

  void sendGifMessage(String gifUrl, BuildContext context,
      String receiverUserId, bool isGroupChat) {
    var index = gifUrl.lastIndexOf('-') + 1;
    var substr = gifUrl.substring(index);
    gifUrl = 'https://i.giphy.com/media/' + substr + '/200.gif';
    final messageReply = ref.read(messageProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendGifMessage(
            gifUrl: gifUrl,
            receiverUserId: receiverUserId,
            context: context,
            senderUser: value!,
            messageReply: messageReply,
            isGroupChat: isGroupChat,
          ),
        );
    ref.read(messageProvider.notifier).update((state) => null);
  }

  void sendFileMessage(File file, BuildContext context, String receiverUserId,
      MessageEnum messageEnum, bool isGroupChat) {
    final messageReply = ref.read(messageProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendFileMessage(
              file: file,
              receiverUserId: receiverUserId,
              context: context,
              senderUserData: value!,
              ref: ref,
              messageEnum: messageEnum,
              messageReply: messageReply,
              isGroupChat: isGroupChat),
        );
    ref.read(messageProvider.notifier).update((state) => null);
  }

  Stream<List<ChatContactModel>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Group>> chatGroups() {
    return chatRepository.getChatGroups();
  }

  Stream<List<MessageModel>> getMessages(String receiverUsedId) {
    return chatRepository.getMessages(receiverUsedId);
  }

  Stream<List<MessageModel>> getGroupMessages(String groupId) {
    return chatRepository.getGroupMessages(groupId);
  }

  void setIsSeen(
      {required String messageId,
      required String receiverUserId,
      required BuildContext context}) {
    chatRepository.setIsSeen(
        messageId: messageId, receiverUserId: receiverUserId, context: context);
  }
}
