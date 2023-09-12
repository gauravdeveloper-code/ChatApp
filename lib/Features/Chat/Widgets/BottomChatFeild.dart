import 'dart:io';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:chat_app/Common/Enums/MessageEnum.dart';
import 'package:chat_app/Common/Provider/MessageReplyProvider.dart';
import 'package:chat_app/Common/Utils/FilePicker.dart';
import 'package:chat_app/Features/Chat/Controller/ChatController.dart';
import 'package:chat_app/Features/Chat/Widgets/MessageReplyPreview.dart';
import 'package:chat_app/Widgets/Constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';

class BottomChatFeild extends ConsumerStatefulWidget {
  final String receiverUserId;
  bool isGroupChat;

  BottomChatFeild(
      {Key? key, required this.receiverUserId, required this.isGroupChat})
      : super(key: key);

  @override
  ConsumerState<BottomChatFeild> createState() => _BottomChatFeildState();
}

class _BottomChatFeildState extends ConsumerState<BottomChatFeild> {
  bool isShowSendButton = false;
  final TextEditingController textController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool isShowEmojiContainer = false;
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
          textController.text.trim(),
          context,
          widget.receiverUserId,
          widget.isGroupChat);
      setState(() {
        textController.text = '';
      });
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(file: File(path), messageEnum: MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
      }

      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage({required File file, required MessageEnum messageEnum}) {
    ref.read(chatControllerProvider).sendFileMessage(
        file, context, widget.receiverUserId, messageEnum, widget.isGroupChat);
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(file: image, messageEnum: MessageEnum.image);
    }
  }

  void selectGif() async {
    final gif = await pickGif(context);
    if (gif != null) {
      ref.read(chatControllerProvider).sendGifMessage(
          gif.url, context, widget.receiverUserId, widget.isGroupChat);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(file: video, messageEnum: MessageEnum.video);
    }
  }

  void showEmojiContainer() => setState(() {
        isShowEmojiContainer = true;
      });

  void hideEmojiContainer() => setState(() {
        isShowEmojiContainer = false;
      });

  void showKeyboard() => focusNode.requestFocus();

  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      hideEmojiContainer();
      showKeyboard();
    } else {
      showEmojiContainer();
      hideKeyboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageProvider);
    final isShowMessageReply = messageReply != null;

    return Column(
      children: [
        isShowMessageReply ? const MessageReplyPreview() : const SizedBox(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(left: 6, bottom: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: searchBarColor,
                ),
                width: MediaQuery.of(context).size.width * 0.80,
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: toggleEmojiKeyboardContainer,
                        icon: const Icon(Icons.emoji_emotions_sharp)),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextFormField(
                        controller: textController,
                        focusNode: focusNode,
                        onChanged: (value) {
                          setState(() {
                            isShowSendButton = value.trim().isNotEmpty;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Message',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: selectVideo,
                            icon: const Icon(CupertinoIcons.paperclip)),
                        IconButton(
                            onPressed: selectImage,
                            icon: const Icon(CupertinoIcons.camera)),
                        IconButton(
                            onPressed: selectGif,
                            icon: const Icon(Icons.gif_box_outlined)),
                      ],
                    )
                  ],
                )),
            Container(
              width: MediaQuery.of(context).size.width * 0.17,
              margin: EdgeInsets.only(bottom: 8),
              child: IconButton(
                  style: const ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        CircleBorder(
                          side: BorderSide(color: Colors.green),
                        ),
                      ),
                      backgroundColor: MaterialStatePropertyAll(Colors.green),
                      fixedSize: MaterialStatePropertyAll(Size.square(50))),
                  onPressed: () {
                    sendTextMessage();
                  },
                  icon: Icon(
                    isShowSendButton
                        ? Icons.send
                        : isRecording
                            ? Icons.close
                            : Icons.mic,
                    color: Colors.white,
                    size: 22,
                  )),
            )
          ],
        ),
        isShowEmojiContainer
            ? SizedBox(
                height: 300,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    if (!isShowSendButton) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    }
                  },
                  textEditingController: textController,
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
