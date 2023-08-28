import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Features/Chat/Widgets/VideoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/Common/Enums/MessageEnum.dart';

class ShowFileMessage extends StatelessWidget {
  final String message;
  final MessageEnum type;

  ShowFileMessage({required this.message, required this.type, super.key});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width * 0.65;
    switch(type)
    {
      case(MessageEnum.text) : return Text(message);
      case(MessageEnum.image) : return CachedNetworkImage(imageUrl: message,fit: BoxFit.contain,width: size,);
      case(MessageEnum.gif) : return CachedNetworkImage(imageUrl: message,fit: BoxFit.contain,width: size,);
      case(MessageEnum.video) : return VideoPlayer(videoUrl: message);
      case(MessageEnum.audio) : return Text(message);
    }
  }
}
