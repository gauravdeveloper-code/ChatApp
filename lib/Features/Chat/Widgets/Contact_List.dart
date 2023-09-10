import 'package:chat_app/Common/Widgets/Loader.dart';
import 'package:chat_app/Features/Call/Controller/CallController.dart';
import 'package:chat_app/Features/Call/Screens/CallPickupScreen.dart';
import 'package:chat_app/Features/Chat/Controller/ChatController.dart';
import 'package:chat_app/Features/Chat/Screens/MobileChatsScreen.dart';
import 'package:chat_app/Models/CallingStateModel.dart';
import 'package:chat_app/Models/ChatContactModel.dart';
import 'package:chat_app/Models/User_Model.dart';
import 'package:chat_app/Models/group.dart';
import 'package:chat_app/Widgets/Constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Contact_List extends ConsumerWidget {
  Contact_List({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<CallingStateModel>(
                stream: ref.watch(callControllerProvider).callingState(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if(snapshot.data!.request)
                      {
                        return InkWell(
                              onTap: ()=>Navigator.pushNamed(context,CallPickupScreen.RouteName,arguments: {
                                'profilePic' : snapshot.data!.profilePic,
                                'roomId' : snapshot.data!.roomId,
                                'senderName' : snapshot.data!.callerName,
                              }),
                              child: Container(
                                  height: 40,
                                  margin: EdgeInsets.only(bottom: 10,top: 10),
                                  alignment: Alignment.center,
                                  width: MediaQuery.sizeOf(context).width,
                                  color: Colors.green,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Incoming Call'),
                                      SizedBox(width: 10,),
                                      Icon(CupertinoIcons.video_camera)
                                    ],
                                  )),
                            );
                      }
                    return Container();
                      }
                  return Container();
                }),
            StreamBuilder<List<ChatContactModel>>(
              stream: ref.watch(chatControllerProvider).chatContacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader(); // or any loading indicator
                } else {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      var chatContactData = snapshot.data![index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, MobileChatScreen.RouteName,
                                  arguments: {
                                    'name': chatContactData.name,
                                    'uid': chatContactData.contactId,
                                    'isGroupChat': false,
                                    'profilePic': chatContactData.profilePic,
                                  });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: InkWell(
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        chatContactData.profilePic),
                                    radius: 30,
                                  ),
                                  onTap: () {},
                                ),
                                trailing: Text(
                                    DateFormat.Hm()
                                        .format(chatContactData.sentTime),
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey)),
                                title: IgnorePointer(
                                  child: Text(
                                    chatContactData.name,
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                ),
                                subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(chatContactData.lastMessage,
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.grey))),
                              ),
                            ),
                          ),
                          const Divider(
                            thickness: 1,
                            color: dividerColor,
                            indent: 85,
                          )
                        ],
                      );
                    },
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                  );
                }
              },
            ),
            StreamBuilder<List<Group>>(
              stream: ref.watch(chatControllerProvider).chatGroups(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader(); // or any loading indicator
                } else {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      var groupData = snapshot.data![index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, MobileChatScreen.RouteName,
                                  arguments: {
                                    'name': groupData.name,
                                    'uid': groupData.groupId,
                                    'isGroupChat': true,
                                    'profilePic': groupData.groupPic,
                                  });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: InkWell(
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(groupData.groupPic),
                                    radius: 30,
                                  ),
                                  onTap: () {},
                                ),
                                trailing: Text(
                                    DateFormat.Hm().format(groupData.timeSent),
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey)),
                                title: IgnorePointer(
                                  child: Text(
                                    groupData.name,
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                ),
                                subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(groupData.lastMessage,
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.grey))),
                              ),
                            ),
                          ),
                          const Divider(
                            thickness: 1,
                            color: dividerColor,
                            indent: 85,
                          )
                        ],
                      );
                    },
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
