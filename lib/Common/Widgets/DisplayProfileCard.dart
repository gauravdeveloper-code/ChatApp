import 'package:chat_app/Features/Chat/Screens/MobileChatsScreen.dart';
import 'package:chat_app/Models/ChatContactModel.dart';
import 'package:chat_app/Models/group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayProfileCard extends StatelessWidget {
   const DisplayProfileCard(
      {super.key, required this.isGroup, required this.groupData,required this.userData});
  final bool isGroup;
  final Group? groupData;
  final ChatContactModel? userData;

  @override
  Widget build(BuildContext context) {
    return isGroup ? SizedBox(
      height: 350,
      width: 300,
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                width: 300,
                height: 300,
                child: Image.network(
                  groupData!.groupPic,
                  fit: BoxFit.cover,
                ),
              ),
              Opacity(
                opacity: 0.75,
                child: Positioned(
                    top: 0,
                    child: Container(
                        height: 40,
                        width: 300,
                        padding: const EdgeInsets.only(top: 10, left: 10),
                        color: Colors.grey,
                        child: Text(
                          groupData!.name,
                          style: const TextStyle(color: Colors.white),
                        ))),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10,bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: const Icon(
                    Icons.chat,
                    color: Colors.green,
                    size: 25,
                  ),
                  onTap: () {Navigator.pushReplacementNamed(
                      context, MobileChatScreen.RouteName,
                      arguments: {
                        'name': groupData!.name,
                        'uid': groupData!.groupId,
                        'isGroupChat': true,
                        'profilePic': groupData!.groupPic,
                      });},
                ),
                InkWell(
                  child: const Icon(
                    Icons.call,
                    color: Colors.green,
                    size: 25,
                  ),
                  onTap: () {},
                ),
                InkWell(
                  child: const Icon(
                    CupertinoIcons.video_camera_solid,
                    color: Colors.green,
                    size: 35,
                  ),
                  onTap: () {},
                ),
                InkWell(
                  child: const Icon(
                    CupertinoIcons.info,
                    color: Colors.green,
                    size: 25,
                  ),
                  onTap: () {},
                ),
              ],
            ),
          )
        ],
      ),
    ) :
    SizedBox(
      height: 350,
      width: 300,
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                width: 300,
                height: 300,
                child: Image.network(
                  userData!.profilePic,
                  fit: BoxFit.cover,
                ),
              ),
              Opacity(
                opacity: 0.75,
                child: Positioned(
                    top: 0,
                    child: Container(
                        height: 40,
                        width: 300,
                        padding: const EdgeInsets.only(top: 10, left: 10),
                        color: Colors.grey,
                        child: Text(
                          userData!.name,
                          style: const TextStyle(color: Colors.white),
                        ))),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10,bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: const Icon(
                    Icons.chat,
                    color: Colors.green,
                    size: 25,
                  ),
                  onTap: () {Navigator.pushReplacementNamed(
                      context, MobileChatScreen.RouteName,
                      arguments: {
                        'name': userData!.name,
                        'uid': userData!.contactId,
                        'isGroupChat': false,
                        'profilePic': userData!.profilePic,
                      });},
                ),
                InkWell(
                  child: const Icon(
                    Icons.call,
                    color: Colors.green,
                    size: 25,
                  ),
                  onTap: () {},
                ),
                InkWell(
                  child: const Icon(
                    CupertinoIcons.video_camera_solid,
                    color: Colors.green,
                    size: 35,
                  ),
                  onTap: () {},
                ),
                InkWell(
                  child: const Icon(
                    CupertinoIcons.info,
                    color: Colors.green,
                    size: 25,
                  ),
                  onTap: () {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
