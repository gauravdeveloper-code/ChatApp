import 'package:chat_app/Common/Widgets/Loader.dart';
import 'package:chat_app/Features/Chat/Controller/ChatController.dart';
import 'package:chat_app/Features/Chat/Screens/MobileChatsScreen.dart';
import 'package:chat_app/Models/ChatContactModel.dart';
import 'package:chat_app/Widgets/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Contact_List extends ConsumerWidget {
  Contact_List({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: StreamBuilder<List<ChatContactModel>>(
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
                        Navigator.pushNamed(context, MobileChatScreen.RouteName,
                            arguments: {
                              'name': chatContactData.name,
                              'uid': chatContactData.contactId
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: InkWell(
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(chatContactData.profilePic),
                              radius: 30,
                            ),
                            onTap: () {},
                          ),
                          trailing: Text(
                              DateFormat.Hm().format(chatContactData.sentTime),
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
    );
  }
}
