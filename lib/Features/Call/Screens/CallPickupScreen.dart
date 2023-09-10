import 'package:chat_app/Features/Call/Controller/CallController.dart';
import 'package:chat_app/Features/Call/Screens/CallScreen.dart';
import 'package:chat_app/Widgets/Constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CallPickupScreen extends ConsumerStatefulWidget {
  final String profilePic;
  final String senderName;
  final String roomId;
  CallPickupScreen(
      {super.key, required this.profilePic, required this.senderName,required this.roomId});
  static const RouteName = 'CallPickupScreen';

  @override
  ConsumerState<CallPickupScreen> createState() => _CallPickupScreenState();
}

class _CallPickupScreenState extends ConsumerState<CallPickupScreen> {


  FirebaseAuth auth = FirebaseAuth.instance;

  void callDeclined(BuildContext context,WidgetRef ref){
    ref.read(callControllerProvider).updateState(false);
    Navigator.pop(context);
  }



  void callPicked(BuildContext context,WidgetRef ref){
    ref.read(callControllerProvider).updateState(false);
    Navigator.pushReplacementNamed(context, CallScreen.RouteName,arguments: {
      'userName' : widget.senderName,
      'userId' : auth.currentUser!.uid,
      'roomId' : widget.roomId,
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Stack(
              children: [
                SizedBox(
                  width: size.width,
                  height: size.height,
                  child: Opacity(
                    opacity: 0.6,
                    child: Image.network(
                      widget.profilePic,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                    left: size.width * 0.25,
                    top: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.senderName,style: const TextStyle(fontSize: 35),),
                        const SizedBox(height: 10,),
                        const Text(
                          'Incoming Video Call',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    )),
                Positioned(
                  bottom: 40,
                  left: size.width * 0.15,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.red,
                        child: IconButton(
                          alignment: Alignment.center,
                          icon: const Icon(
                            Icons.call_end,
                            size: 35,
                          ),
                          onPressed: () => callDeclined(context,ref),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('Decline'),
                    ],
                  ),
                ),
                Positioned(
                  right: size.width * 0.15,
                  bottom: 40,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.green,
                        child: IconButton(
                          alignment: Alignment.center,
                          icon: const Icon(
                            CupertinoIcons.video_camera_solid,
                            size: 35,
                          ),
                          onPressed: () => callPicked(context,ref),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('Accept'),
                    ],
                  ),
                ),
              ]),
        ));
  }
}

