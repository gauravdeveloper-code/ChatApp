import 'package:chat_app/Features/Chat/Widgets/Contact_List.dart';
import 'package:chat_app/Features/Select_Contacts/Screens/SelectContactsScreen.dart';
import 'package:chat_app/Features/UserOnlineState/UserOnlineStateController.dart';
import 'package:chat_app/Widgets/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileScreen extends ConsumerStatefulWidget {
  static const RouteName = 'MobileScreen';

  const MobileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends ConsumerState<MobileScreen>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
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
          body: SafeArea(child: Contact_List()),
          floatingActionButton: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SelectContactsScreen.RouteName);
            },
            icon: const Icon(Icons.message),
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.green),
                fixedSize: MaterialStatePropertyAll(Size(60, 60)),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))))),
          ),
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
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                )
              ],
              title: const Text('Whatsapp'),
              bottom: const TabBar(
                tabs: [
                  Text('Chats'),
                  Text('Status'),
                  Text('Calls'),
                ],
                unselectedLabelColor: Colors.white,
                indicatorColor: Colors.green,
                labelColor: Colors.green,
                labelPadding: EdgeInsets.all(12),
              )),
        ));
  }
}
