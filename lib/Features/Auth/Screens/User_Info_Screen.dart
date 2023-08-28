import 'dart:io';
import 'package:chat_app/Common/Utils/FilePicker.dart';
import 'package:chat_app/Features/Auth/Controller/Auth_Controller.dart';
import 'package:chat_app/Widgets/Constants/Urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  static const RouteName = 'UserInfoScreen';

  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInfoScreen> createState() => _User_Info_ScreenState();
}

class _User_Info_ScreenState extends ConsumerState<UserInfoScreen> {
  TextEditingController nameController = TextEditingController();
  File? image;

  void pickImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void saveUserData() async {
    String name = nameController.text.trim().toString();
    if (name.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .saveUserDataToFirebase(name, image, context);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
            child: Column(
          children: [
            Stack(
              children: [
                image == null
                    ? const CircleAvatar(
                        radius: 65, backgroundImage: NetworkImage(profile))
                    : CircleAvatar(
                        radius: 65,
                        backgroundImage: FileImage(image!),
                      ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: pickImage,
                    icon: const Icon(
                      Icons.add_a_photo,
                      size: 40,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Enter Your Name',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    controller: nameController,
                  ),
                ),
                IconButton(
                    onPressed: saveUserData, icon: const Icon(Icons.check))
              ],
            )
          ],
        )),
      ),
    );
  }
}
