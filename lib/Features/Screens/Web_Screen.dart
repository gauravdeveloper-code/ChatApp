import 'package:chat_app/Features/Chat/Widgets/message_cards.dart';
import 'package:chat_app/Widgets/web_page_utils.dart';
import 'package:flutter/material.dart';

class WebScreen extends StatelessWidget {
  const WebScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.3,
          child: Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const web_appBar(),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: web_search_bar(),
                  ),
                 // Contact_List()
                ],
              ),
            ),
          ),
        ),
        Container(
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('Assets/Images/ChatBg.jpg'),
                    fit: BoxFit.cover)),
            child: Expanded(
              child: Column(
                children: [
                  web_message_appbar(),
                  // MyMessageCard(
                  //     message: 'message',
                  //     date: 'date',
                  //     // onLeftSwipe: () {},
                  //     // repliedText: "repliedText",
                  //     // username: "Gaurav",
                  //     // isSeen: true
                  // ),
                  // SenderMessageCard(
                  //     message: "message",
                  //     date: "date",
                  //     // onRightSwipe: () {},
                  //     // repliedText: "repliedText",
                  //     // username: "username"
                  // )
                ],
              ),
            ))
      ],
    ));
  }
}
