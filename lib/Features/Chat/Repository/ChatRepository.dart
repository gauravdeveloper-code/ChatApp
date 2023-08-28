import 'dart:io';
import 'package:chat_app/Common/Enums/MessageEnum.dart';
import 'package:chat_app/Common/Repositiories/Common_Firesbase_Storage_Repositories.dart';
import 'package:chat_app/Common/Utils/SnackBar.dart';
import 'package:chat_app/Models/ChatContactModel.dart';
import 'package:chat_app/Models/MessageModel.dart';
import 'package:chat_app/Models/User_Model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider((ref) {
  final chatRepository = ChatRepository(
      fireStore: FirebaseFirestore.instance, auth: FirebaseAuth.instance);
  return chatRepository;
});

class ChatRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore fireStore;

  ChatRepository({required this.fireStore, required this.auth});

  Stream<List<MessageModel>> getMessages(String receiverUserId) {
    return fireStore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<MessageModel> messages = [];
      for (var document in event.docs) {
        try {
          messages.add(MessageModel.fromMap(document.data()));
        } catch (e) {
          debugPrint('this is from get messages ${e.toString()}');
        }
      }
      return messages;
    });
  }

  Stream<List<ChatContactModel>> getChatContacts() {
    return fireStore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContactModel> contacts = [];
      for (var document in event.docs) {
        try {
          var chatContact = ChatContactModel.fromMap(document.data());
          var userData = await fireStore
              .collection('users')
              .doc(chatContact.contactId)
              .get();
          var user = UserModel.fromMap(userData.data()!);
          contacts.add(ChatContactModel(
              name: user.name,
              lastMessage: chatContact.lastMessage,
              contactId: chatContact.contactId,
              profilePic: user.profilePic,
              sentTime: chatContact.sentTime));
        } catch (e) {
          debugPrint('this is from get contacts ${e.toString()}');
        }
      }
      return contacts;
    });
  }

  void _saveUserdataToContactSubCollection(
      {required UserModel sender,
      required UserModel receiver,
      required String text,
      required DateTime timeSent,
      required String receiverUserId}) async {
    var receiverChatContact = ChatContactModel(
        name: sender.name,
        lastMessage: text,
        contactId: sender.uid,
        profilePic: sender.profilePic,
        sentTime: timeSent);

    await fireStore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(sender.uid)
        .set(receiverChatContact.toMap());

    var senderChatContact = ChatContactModel(
        name: receiver.name,
        lastMessage: text,
        contactId: receiver.uid,
        profilePic: receiver.profilePic,
        sentTime: timeSent);

    await fireStore
        .collection('users')
        .doc(sender.uid)
        .collection('chats')
        .doc(receiverUserId)
        .set(senderChatContact.toMap());
  }

  void _saveMessageToMessageSubCollection(
      {required String text,
      required String receiverUserId,
      required String messageId,
      required String userName,
      required MessageEnum messageType,
      required DateTime timeSent,
      required receiverUsername}) async {
    var message = MessageModel(
        text: text,
        receiverId: receiverUserId,
        senderId: auth.currentUser!.uid,
        messageId: messageId,
        timeSent: timeSent,
        isSeen: false,
        messageType: messageType);

    await fireStore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    await fireStore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextMessage({
    required String text,
    required String receiverUserId,
    required BuildContext context,
    required UserModel senderUser,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? receiverUserData;
      var userDataMap =
          await fireStore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);
      var messageId = const Uuid().v1();

      _saveUserdataToContactSubCollection(
          sender: senderUser,
          receiver: receiverUserData,
          text: text,
          timeSent: timeSent,
          receiverUserId: receiverUserId);

      _saveMessageToMessageSubCollection(
          text: text,
          receiverUserId: receiverUserId,
          messageId: messageId,
          userName: senderUser.name,
          messageType: MessageEnum.text,
          timeSent: timeSent,
          receiverUsername: receiverUserData?.name);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendGifMessage({
    required String gifUrl,
    required String receiverUserId,
    required BuildContext context,
    required UserModel senderUser,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? receiverUserData;
      var userDataMap =
      await fireStore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);
      var messageId = const Uuid().v1();

      _saveUserdataToContactSubCollection(
          sender: senderUser,
          receiver: receiverUserData,
          text: 'Gif',
          timeSent: timeSent,
          receiverUserId: receiverUserId);

      _saveMessageToMessageSubCollection(
          text: gifUrl,
          receiverUserId: receiverUserId,
          messageId: messageId,
          userName: senderUser.name,
          messageType: MessageEnum.gif,
          timeSent: timeSent,
          receiverUsername: receiverUserData?.name);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = Uuid().v1();
      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
              'chat/${messageEnum.type}/${senderUserData.uid}/$receiverUserId/$messageId',
              file);
      UserModel receiverUserData;
      var userDataMap =
          await fireStore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);
      String contactMessage;

      switch (messageEnum) {
        case (MessageEnum.image):
          contactMessage = '📷 Photo';
          break;
        case (MessageEnum.video):
          contactMessage = '📹 Video';
          break;
        case (MessageEnum.audio):
          contactMessage = '🎶 Audio';
          break;
        case (MessageEnum.gif):
          contactMessage = 'Gif';
          break;
        default:
          contactMessage = 'Gif';
      }

      _saveUserdataToContactSubCollection(
          sender: senderUserData,
          receiver: receiverUserData,
          text: contactMessage,
          timeSent: timeSent,
          receiverUserId: receiverUserId);

      _saveMessageToMessageSubCollection(
          text: imageUrl,
          receiverUserId: receiverUserId,
          messageId: messageId,
          userName: senderUserData.name,
          messageType: messageEnum,
          timeSent: timeSent,
          receiverUsername: receiverUserData.name);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
