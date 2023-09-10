import 'package:chat_app/Common/Provider/MessageReplyProvider.dart';
import 'package:chat_app/Features/Chat/Widgets/ShowFileMessage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({super.key});

  void cancelReply(WidgetRef ref)
  {
    ref.read(messageProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageProvider);
    return Container(
      width: 350,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                messageReply!.isme ? 'Me' : 'OtherPerson',
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
              GestureDetector(
                child: const Icon(
                  Icons.close,
                  size: 16,
                ),
                onTap: ()=>cancelReply(ref),
              )
            ],
          ),
          const SizedBox(height: 10,),
          ShowFileMessage(message: messageReply.message, type: messageReply.messageEnum)
        ],
      ),
    );
  }
}
