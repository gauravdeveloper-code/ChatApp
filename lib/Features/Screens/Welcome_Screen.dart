import 'package:chat_app/Common/Widgets/custom_button.dart';
import 'package:chat_app/Features/Auth/Screens/Login_Screen.dart';
import 'package:chat_app/Widgets/Constants/colors.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  void navigateToLogin(BuildContext context) {
    Navigator.pushNamed(context, (LoginScreen.RouteName));
  }

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('Assets/Images/bg.png'),
              backgroundColor: messageColor,
              radius: 100,
            ),
            const Text(
              'Welcome To Whatsapp',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            CustomButton(
                onPress: () => navigateToLogin(context),
                text: 'Agree and Continue')
          ],
        ),
      )),
    );
  }
}
