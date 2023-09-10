import 'dart:io';
import 'package:chat_app/Common/Utils/FilePicker.dart';
import 'package:chat_app/Features/Call/Screens/CallRecordsScreen.dart';
import 'package:chat_app/Features/Chat/Widgets/Contact_List.dart';
import 'package:chat_app/Features/Select_Contacts/Screens/SelectContactsScreen.dart';
import 'package:chat_app/Features/Status/Screens/ConfirmStatusScreen.dart';
import 'package:chat_app/Features/Status/Screens/StatusScreen.dart';
import 'package:chat_app/Features/UserOnlineState/UserOnlineStateController.dart';
import 'package:chat_app/Features/group/screens/create_group_screen.dart';
import 'package:chat_app/Widgets/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class MobileScreen extends ConsumerStatefulWidget {
  static const RouteName = 'MobileScreen';

  const MobileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends ConsumerState<MobileScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(userStateControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(userStateControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: appBarColor,
              actions: [
                IconButton(
                  icon: const Icon(Icons.camera_alt_outlined),
                  onPressed: () {},
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
                const SizedBox(
                  width: 10,
                ),
                PopupMenuButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.grey,
                  ),
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      child: const Text('Create Group'),
                      onTap: () => Future(() => Navigator.pushNamed(
                          context, CreateGroupScreen.RouteName)),
                    ),
                  ],
                )
              ],
              title: const Text('Whatsapp'),
              bottom: TabBar(
                controller: tabController,
                tabs: const [
                  Text('Chats'),
                  Text('Status'),
                  Text('Calls'),
                ],
                unselectedLabelColor: Colors.white,
                indicatorColor: Colors.green,
                labelColor: Colors.green,
                labelPadding: const EdgeInsets.all(12),
              )),
          body: TabBarView(
            controller: tabController,
            children: [
              Contact_List(),
              const StatusScreen(),
              const CallRecordsScreen(),
            ],
          ),
          floatingActionButton: IconButton(
            onPressed: () async {
              if (tabController.index == 0) {
                Navigator.pushNamed(context, SelectContactsScreen.RouteName);
              } else {
                File? pickedImage = await pickImageFromGallery(context);
                if (pickedImage != null) {
                  Navigator.pushNamed(context, ConfirmStatusScreen.RouteName,
                      arguments: pickedImage);
                }
              }
            },
            icon: tabController.index == 0
                ? const Icon(Icons.message)
                : const Icon(Icons.camera_alt_outlined),
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.green),
                fixedSize: MaterialStatePropertyAll(Size(60, 60)),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))))),
          ),
        ));
  }
}
