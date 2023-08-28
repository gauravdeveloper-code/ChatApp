import 'package:chat_app/Widgets/Constants/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;

  final VoidCallback onPress;

  const CustomButton({Key? key, required this.onPress, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPress,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(messageColor)),
        child: Text(
          text.toString(),
          style: const TextStyle(color: Colors.white),
        ));
  }
}
