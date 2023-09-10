import 'dart:io';
import 'package:chat_app/Common/Utils/SnackBar.dart';
import 'package:chat_app/Features/Auth/Controller/Auth_Controller.dart';
import 'package:chat_app/Features/Status/Repository/StatusRepository.dart';
import 'package:chat_app/Models/StatusModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final statusControllerProvider = Provider((ref) {
  final statusRepository = ref.read(statusRepositoryProvider);
  return StatusController(statusRepository: statusRepository, ref: ref);
});

class StatusController {
  final StatusRepository statusRepository;
  final ProviderRef ref;

  StatusController({required this.statusRepository, required this.ref});

  void addStatus(File file, BuildContext context,String caption) {
    ref.watch(userDataAuthProvider).whenData((value) {
      statusRepository.uploadStatus(
          context: context,
          userName: value!.name,
          phoneNumber: value.number,
          profilePic: value.profilePic,
          statusImage: file,
          caption: caption,
      );
    });
  }

  Future<List<StatusModel>> getStatus(BuildContext context)
  async{
    List<StatusModel>statuses = [];
    try{
      statuses = await ref.read(statusRepositoryProvider).getStatus(context);
    }
    catch(e){
      showSnackBar(context: context, content: e.toString());
    }
    return statuses;
  }

}
