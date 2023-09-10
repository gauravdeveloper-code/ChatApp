import 'dart:io';
import 'package:chat_app/ErrorPage.dart';
import 'package:chat_app/Features/Auth/Screens/Login_Screen.dart';
import 'package:chat_app/Features/Auth/Screens/Otp_Screen.dart';
import 'package:chat_app/Features/Auth/Screens/User_Info_Screen.dart';
import 'package:chat_app/Features/Call/Screens/CallPickupScreen.dart';
import 'package:chat_app/Features/Call/Screens/CallScreen.dart';
import 'package:chat_app/Features/Chat/Screens/MobileChatsScreen.dart';
import 'package:chat_app/Features/Screens/Moblie_Screen.dart';
import 'package:chat_app/Features/Select_Contacts/Screens/SelectContactsScreen.dart';
import 'package:chat_app/Features/Status/Screens/ConfirmStatusScreen.dart';
import 'package:chat_app/Features/group/screens/create_group_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.RouteName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());

    case MobileScreen.RouteName:
      return MaterialPageRoute(builder: (context) => const MobileScreen());

    case UserInfoScreen.RouteName:
      return MaterialPageRoute(builder: (context) => const UserInfoScreen());

    case CreateGroupScreen.RouteName:
      return MaterialPageRoute(builder: (context) => const CreateGroupScreen());

    case SelectContactsScreen.RouteName:
      return MaterialPageRoute(
          builder: (context) => const SelectContactsScreen());

    case MobileChatScreen.RouteName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      final isGroupChat = arguments['isGroupChat'];
      final profilePic = arguments['profilePic'];
      return MaterialPageRoute(
          builder: (context) => MobileChatScreen(
                name: name,
                uid: uid,
                isGroupChat: isGroupChat,
                profilePic: profilePic,
              ));

    case CallScreen.RouteName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final userName = arguments['userName'];
      final roomId = arguments['roomId'];
      final userId = arguments['userId'];
      return MaterialPageRoute(
          builder: (context) =>
              CallScreen(callId: roomId, userName: userName, userId: userId));

    case CallPickupScreen.RouteName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final profilePic = arguments['profilePic'];
      final roomId = arguments['roomId'];
      final senderName = arguments['senderName'];
      return MaterialPageRoute(
          builder: (context) => CallPickupScreen(
                profilePic: profilePic,
                senderName: senderName,
                roomId: roomId,
              ));

    case ConfirmStatusScreen.RouteName:
      final file = settings.arguments as File;
      return MaterialPageRoute(
          builder: (context) => ConfirmStatusScreen(
                file: file,
              ));

    case Otp_Screen.RouteName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => Otp_Screen(
                verificationId: verificationId,
              ));

    default:
      return MaterialPageRoute(
        builder: (context) => const ErrorPage(
          error: 'Something Went Wrong',
        ),
      );
  }
}
