import 'package:chat_app/ErrorPage.dart';
import 'package:chat_app/Features/Auth/Screens/Login_Screen.dart';
import 'package:chat_app/Features/Auth/Screens/Otp_Screen.dart';
import 'package:chat_app/Features/Auth/Screens/User_Info_Screen.dart';
import 'package:chat_app/Features/Chat/Screens/MobileChatsScreen.dart';
import 'package:chat_app/Features/Screens/Moblie_Screen.dart';
import 'package:chat_app/Features/Select_Contacts/Screens/SelectContactsScreen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.RouteName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());

    case MobileScreen.RouteName:
      return MaterialPageRoute(builder: (context) => const MobileScreen());

    case UserInfoScreen.RouteName:
      return MaterialPageRoute(builder: (context) => const UserInfoScreen());

    case SelectContactsScreen.RouteName:
      return MaterialPageRoute(
          builder: (context) => const SelectContactsScreen());

    case MobileChatScreen.RouteName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      return MaterialPageRoute(
          builder: (context) => MobileChatScreen(
                name: name,
                uid: uid,
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
