import 'package:chat_app/Common/Widgets/Loader.dart';
import 'package:chat_app/Features/Call/Controller/CallController.dart';
import 'package:chat_app/Features/Chat/Screens/MobileChatsScreen.dart';
import 'package:chat_app/Models/CallModel.dart';
import 'package:chat_app/Widgets/Constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CallRecordsScreen extends ConsumerStatefulWidget {
  const CallRecordsScreen({super.key});

  @override
  ConsumerState<CallRecordsScreen> createState() => _CallRecordsScreenState();
}

class _CallRecordsScreenState extends ConsumerState<CallRecordsScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<CallModel>>(
              stream: ref.watch(callControllerProvider).getCallRecords(context),
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
                                    'name': chatContactData.callerId,
                                    'uid': chatContactData.callerId,
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
                                trailing: const Icon(
                                  CupertinoIcons.video_camera,
                                  color: Colors.green,
                                ),
                                title: IgnorePointer(
                                  child: Text(
                                    chatContactData.receiverId,
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: (chatContactData.callerId ==
                                          auth.currentUser!.uid)
                                      ? Row(
                                          children: [
                                            const Text(
                                              'Outgoing',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.green),
                                            ),
                                            const Icon(
                                              CupertinoIcons.arrow_up_right,
                                              color: Colors.green,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                                DateFormat.Hm().format(
                                                    chatContactData.timeCalled),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white)),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            const Text(
                                              'Incoming',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.green),
                                            ),
                                            const Icon(
                                              CupertinoIcons.arrow_down_left,
                                              color: Colors.green,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                                DateFormat.Hm().format(
                                                    chatContactData.timeCalled),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                ),
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
