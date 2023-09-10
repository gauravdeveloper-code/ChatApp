import 'package:chat_app/Common/Enums/MessageEnum.dart';
import 'package:chat_app/Features/Chat/Widgets/ShowFileMessage.dart';
import 'package:chat_app/Widgets/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final String repliedMessage;
  final VoidCallback onLeftSwipe;
  final MessageEnum repliedMessageType;
  final String userName;
  final bool isSeen;

  const MyMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.onLeftSwipe,
    required this.repliedMessage,
    required this.repliedMessageType,
    required this.userName,
    required this.isSeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedMessage.isNotEmpty;
    print(isSeen);

    return SwipeTo(
      onLeftSwipe: onLeftSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: messageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 30,
                    top: 5,
                    bottom: 20,
                  ),
                  child: Column(
                    children: [
                      if (isReplying) ...[
                        Text(
                          userName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: backgroundColor.withOpacity(0.5),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: ShowFileMessage(
                              message: repliedMessage,
                              type: repliedMessageType),
                        ),
                      ],
                      ShowFileMessage(
                        message: message,
                        type: type,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 50,width: 100,),
                Positioned(
                  bottom: 2,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Icon(
                        isSeen ? Icons.done_all : Icons.done,
                        color: isSeen ? Colors.lightBlueAccent : Colors.white60,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.onRightSwipe,
    required this.repliedMessage,
    required this.repliedMessageType,
    required this.userName,
  }) : super(key: key);
  final String message;
  final String date;
  final MessageEnum type;
  final String repliedMessage;
  final VoidCallback onRightSwipe;
  final MessageEnum repliedMessageType;
  final String userName;

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedMessage.isNotEmpty;

    return SwipeTo(
      onRightSwipe: onRightSwipe,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: Colors.blueGrey,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 30,
                    top: 5,
                    bottom: 20,
                  ),
                  child: Column(
                    children: [
                      if (isReplying) ...[
                        Text(
                          userName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: backgroundColor.withOpacity(0.5),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: ShowFileMessage(
                              message: repliedMessage,
                              type: repliedMessageType),
                        ),
                      ],
                      ShowFileMessage(
                        message: message,
                        type: type,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 50,width: 100,),
                Positioned(
                  bottom: 2,
                  right: 10,
                  child: Text(
                    date,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
