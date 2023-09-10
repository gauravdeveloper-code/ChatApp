import 'package:chat_app/Common/Widgets/Loader.dart';
import 'package:chat_app/Features/Auth/Controller/Auth_Controller.dart';
import 'package:chat_app/Features/Call/Controller/CallController.dart';
import 'package:chat_app/Features/Call/Screens/CallScreen.dart';
import 'package:chat_app/Features/Chat/Widgets/BottomChatFeild.dart';
import 'package:chat_app/Features/Chat/Widgets/ChatList.dart';
import 'package:chat_app/Models/User_Model.dart';
import 'package:chat_app/Widgets/Constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileChatScreen extends ConsumerWidget {
  static const RouteName = 'MobileChatScreen';
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;

  const MobileChatScreen({Key? key, required this.name, required this.uid,required this.isGroupChat,required this.profilePic})
      : super(key: key);


  void call(BuildContext context ,WidgetRef ref)
  async{
    FirebaseAuth auth =  await FirebaseAuth.instance;

    var roomid = await ref.read(callControllerProvider).sendCall(uid, context);

    ref.read(callControllerProvider).updateState(false);

    Navigator.pushNamed(context, CallScreen.RouteName,arguments: {
      'userId': auth.currentUser!.uid,
      'userName': auth.currentUser!.uid,
      'roomId': roomid,
    });

  }
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: isGroupChat ? Text(name) :StreamBuilder<UserModel>(
          stream: ref.read(authControllerProvider).userDataById(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader(); // Return the Loader widget here
            }
            return Column(
              children: [
                Text(name),
                const SizedBox(height: 6,),
                snapshot.data!.isOnline ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                       'Online',
                      style: TextStyle(fontSize: 10),
                    ),
                    SizedBox(width:5,),
                    CircleAvatar(backgroundColor: Colors.lightGreen,radius: 3,)
                  ],
                ) :
                const Text(
                  'Offline',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            );
          },
        ),
        centerTitle: false,
        actions: [
          IconButton(onPressed: ()=> call(context,ref), icon: const Icon(Icons.video_call),),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'Assets/Images/ChatBg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ChatList(
                  receiverUserId: uid,
                    isGroupChat : isGroupChat,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              BottomChatFeild(
                receiverUserId: uid,
                isGroupChat: isGroupChat,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
