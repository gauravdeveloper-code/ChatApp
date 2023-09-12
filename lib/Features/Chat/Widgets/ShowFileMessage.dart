import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Features/Chat/Widgets/VideoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/Common/Enums/MessageEnum.dart';

class ShowFileMessage extends StatelessWidget {
  final String message;
  final MessageEnum type;

  const ShowFileMessage({required this.message, required this.type, super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width * 0.5;
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();

    switch (type) {
      case (MessageEnum.text):
        return Container(
            margin: const EdgeInsets.only(top: 2,bottom: 8),
            child: Text(message,style: const TextStyle(fontSize: 16),));
      case (MessageEnum.image):
        return InkWell(
          onTap: () => showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: CachedNetworkImage(
                    imageUrl: message,
                    fit: BoxFit.cover,
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height,
                  ),
                );
              }),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10,top: 6,left: 6),
            child: CachedNetworkImage(
              imageUrl: message,
              fit: BoxFit.contain,
              width: size,
            ),
          ),
        );
      case (MessageEnum.gif):
        return CachedNetworkImage(
          imageUrl: message,
          fit: BoxFit.contain,
          width: size,
        );
      case (MessageEnum.video):
        return Container(
            margin: const EdgeInsets.only(left: 10,top: 12,bottom: 16),
            child: VideoPlayer(videoUrl: message));
      case (MessageEnum.audio):
        return Column(
          children: [
            StatefulBuilder(
              builder: (BuildContext context, setState) {
                return IconButton(
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.pause();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      await audioPlayer.play(UrlSource(message));
                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                  icon: isPlaying
                      ? const Icon(
                          Icons.pause_circle_outline_rounded,
                          size: 40,
                        )
                      : const Icon(
                          Icons.play_circle,
                          size: 40,
                        ),
                  constraints:
                      const BoxConstraints(minWidth: 100, minHeight: 50),
                );
              },
            ),
            Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(8.0),
              child: const Text('Recording'),
            ),
          ],
        );
    }
  }
}
