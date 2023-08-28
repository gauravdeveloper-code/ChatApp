import 'package:chat_app/Common/Utils/SnackBar.dart';
import 'package:chat_app/Common/Widgets/custom_button.dart';
import 'package:chat_app/Features/Auth/Controller/Auth_Controller.dart';
import 'package:chat_app/Widgets/Constants/colors.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const RouteName = 'LoginScreen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends ConsumerState<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  String? country;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (country) {
          setState(() {
            this.country = country.phoneCode;
          });
        });
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();

    if (country != null && phoneNumber != '') {
      ref.read(authControllerProvider).signInWithPhone(
          context, '+${country!.toString()}${phoneNumber.toString()}');
    } else {
      showSnackBar(context: context, content: 'Please Enter All The Fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Your Phone Number'),
        centerTitle: true,
        backgroundColor: backgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text(
                        'Whatsapp Will Need to Verify Your Phone Number'),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: pickCountry,
                        child: const Text('Pick Country',
                            style: TextStyle(color: Colors.blue))),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        if (country != null) Text('+$country'),
                        const SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextField(
                            controller: phoneController,
                            decoration: const InputDecoration(
                              hintText: 'Phone Number',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.55,
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.6,
                  child: CustomButton(
                    text: 'Next',
                    onPress: sendPhoneNumber,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
