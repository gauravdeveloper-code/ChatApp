import 'package:chat_app/Features/Call/Controller/CallController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallScreen extends ConsumerWidget {
  static const RouteName = 'CallScreen';
  FirebaseAuth auth = FirebaseAuth.instance;

  CallScreen({Key? key, required this.callId,required this.userName, required this.userId}) : super(key: key);
  final String callId;
  final String userName;
  final String userId;

  void updateState(BuildContext context ,WidgetRef ref)
  {
    ref.read(callControllerProvider).updateState(false);
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return ZegoUIKitPrebuiltCall(
      appID: 1423252455,
      appSign: 'f22ca4e56cd8ddb85c8fa44ff4ee51f174fe3a0afc5331500fff97ecd435ce18',
      userID: userId,
      userName: userName,
      callID: callId,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        ..onOnlySelfInRoom = (context) {
        updateState(context,ref);
        Navigator.of(context).pop();
        },
    );
  }
}