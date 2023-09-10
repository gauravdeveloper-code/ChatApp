import 'dart:io';
import 'package:chat_app/Features/Status/Controller/StatusController.dart';
import 'package:chat_app/Widgets/Constants/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class ConfirmStatusScreen extends ConsumerStatefulWidget {
  static const RouteName = 'ConfirmStatusScreen';
  final File? file;
  const ConfirmStatusScreen({super.key,this.file});

  @override
  ConsumerState<ConfirmStatusScreen> createState() => _ConfirmStatusScreenState();
}

class _ConfirmStatusScreenState extends ConsumerState<ConfirmStatusScreen> {

  final TextEditingController captionTextController = TextEditingController();

  void addStatus(BuildContext context, WidgetRef ref) {
    String caption = captionTextController.text.trim().toString();
    ref.read(statusControllerProvider).addStatus(widget.file!, context,caption);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 9 / 16,
                    child: Image.file(widget.file!),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(left: 20),
                          width: 300,
                          child:  TextField(
                            controller: captionTextController,
                            decoration: const InputDecoration(
                                hintText: 'Write a Caption',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20),),
                                )
                            ),)),
                      InkWell(
                        child: const CircleAvatar(
                          backgroundColor: messageColor,
                          child: Icon(
                              Icons.check,
                          ),
                        ),
                        onTap: (){
                          addStatus(context, ref);
                        },
                      )
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}



