import 'dart:io';
import 'package:chat_app/Common/Repositiories/Common_Firesbase_Storage_Repositories.dart';
import 'package:chat_app/Common/Utils/SnackBar.dart';
import 'package:chat_app/Models/StatusModel.dart';
import 'package:chat_app/Models/User_Model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final statusRepositoryProvider = Provider((ref) => StatusRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref));

class StatusRepository {

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final ProviderRef ref;

  StatusRepository(
      {required this.firestore, required this.auth, required this.ref});

  void uploadStatus({
    required BuildContext context,
    required String userName,
    required String phoneNumber,
    required String profilePic,
    required File statusImage,
    required String caption,
  }) async {
    try {
      var statusId = const Uuid().v1();
      String userId = auth.currentUser!.uid;
      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase('status/$statusId$userId', statusImage);


      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }


      List<String> whoCanSee = [];

      for (int i = 0; i < contacts.length; i++) {
        var userContactData = await firestore
            .collection('users')
            .where(
          'number',
          isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''),
        ).get();

        if (userContactData.docs.isNotEmpty) {
          var userData = UserModel.fromMap(userContactData.docs[0].data());
          whoCanSee.add(userData.uid);
        }
      }


      List<String> statusImageUrls = [];
      List<String> statusCaptions = [];

      var statusSnapShots = await firestore
          .collection('status')
          .where('uid', isEqualTo: auth.currentUser!.uid)
          .get();

      if (statusSnapShots.docs.isNotEmpty) {
        StatusModel status =
        StatusModel.fromMap(statusSnapShots.docs[0].data());

        statusImageUrls = status.photoUrls;
        statusCaptions = status.statusCaption;
        statusCaptions.add(caption);
        statusImageUrls.add(imageUrl);

        await firestore
            .collection('status')
            .doc(statusSnapShots.docs[0].id)
            .update({
          'photoUrls': statusImageUrls,
          'statusCaption': statusCaptions
        });
        return;
      } else {
        statusImageUrls = [imageUrl];
        statusCaptions = [caption];

        StatusModel status = StatusModel(
          uid: userId,
          userName: userName,
          phoneNumber: phoneNumber,
          profilePic: profilePic,
          statusId: statusId,
          statusCaption: statusCaptions,
          photoUrls: statusImageUrls,
          whoCanSee: whoCanSee,
          createdAt: DateTime.now(),
        );

        await firestore.collection('status').doc(statusId).set(status.toMap());
        return;
      }

    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<List<StatusModel>> getStatus(BuildContext context) async {
    List<StatusModel> status = [];
    try {
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      for (int i = 0; i < contacts.length; i++) {
        var statusSnapShot = await firestore
            .collection('status')
            .where(
              'phoneNumber',
              isEqualTo: contacts[i].phones[0].number.replaceAll(' ',''),
            )
            .where('createdAt',
                isGreaterThan: DateTime.now()
                    .subtract(
                      const Duration(hours: 24),
                    )
                    .millisecondsSinceEpoch)
            .get();


        for (var tempData in statusSnapShot.docs) {
          StatusModel tempStatus = StatusModel.fromMap(tempData.data());
          if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {
            status.add(tempStatus);
          }
        }
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return status;
  }

}
