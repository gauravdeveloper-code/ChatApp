import 'package:chat_app/Common/Widgets/Loader.dart';
import 'package:chat_app/Features/Auth/Controller/Auth_Controller.dart';
import 'package:chat_app/Features/Chat/Widgets/BottomChatFeild.dart';
import 'package:chat_app/Features/Chat/Widgets/ChatList.dart';
import 'package:chat_app/Models/User_Model.dart';
import 'package:chat_app/Widgets/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileChatScreen extends ConsumerWidget {
  static const RouteName = 'MobileChatScreen';
  final String name;
  final String uid;

  const MobileChatScreen({Key? key, required this.name, required this.uid})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
          stream: ref.read(authControllerProvider).userDataById(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader(); // Return the Loader widget here
            }
            return Column(
              children: [
                Text(name),
                Text(snapshot.data!.isOnline ? 'Online' : 'Offline',style: const TextStyle(fontSize: 10),),
              ],
            );
          },
        ),
        centerTitle: false,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body:  Column(
        children: [
          Expanded(
            child: ChatList(
              receiverUserId: uid,
            ),
          ),
          BottomChatFeild(
            receiverUserId: uid,
          ),
        ],
      ),
    );
  }
}

