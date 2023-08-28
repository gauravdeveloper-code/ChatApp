import 'package:chat_app/Features/Auth/Controller/Auth_Controller.dart';
import 'package:chat_app/Widgets/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Otp_Screen extends ConsumerWidget {
  Otp_Screen({super.key, required this.verificationId});

  static const RouteName = 'OtpScreen';
  String verificationId;

  void verifyOtp(
      {required String otp,
      required WidgetRef ref,
      required BuildContext context}) {
    ref.read(authControllerProvider).verifyOtp(context, verificationId, otp);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Verifying Your Number'),
          centerTitle: true,
          backgroundColor: backgroundColor,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30, left: 60, right: 60),
                child: Column(
                  children: [
                    const Text('We Have Sent a SMS with a Code'),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: '-    -    -    -    -    -',
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 30),
                      onChanged: (value) {
                        if (value.length == 6) {
                          verifyOtp(
                              otp: value.trim(), ref: ref, context: context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
