import 'package:chat_app/Common/Widgets/Loader.dart';
import 'package:chat_app/Features/Chat/Controller/ChatController.dart';
import 'package:chat_app/Features/Chat/Widgets/message_cards.dart';
import 'package:chat_app/Models/MessageModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverUserId;
  const ChatList({super.key,  required this.receiverUserId});
  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {

  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
      stream: ref.read(chatControllerProvider).getMessages(widget.receiverUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        else if(!snapshot.hasData){
          return const Text('Did not have any message to show');
        }
        SchedulerBinding.instance.addPostFrameCallback((_) {
          messageController.jumpTo(messageController.position.maxScrollExtent);
        });

        return ListView.builder(
          controller: messageController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var message = snapshot.data![index];

            if (message.senderId == FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: message.text,
                date: DateFormat.Hm().format(message.timeSent),
                type: message.messageType,
                // other properties
              );
            } else {
              return SenderMessageCard(
                message: message.text,
                date: DateFormat.Hm().format(message.timeSent),
                type: message.messageType,
                // other properties
              );
            }
          },
        );
      },
    );
  }
}

