import 'dart:async';
import 'package:chat_app/Common/Utils/SnackBar.dart';
import 'package:chat_app/Models/CallModel.dart';
import 'package:chat_app/Models/CallingStateModel.dart';
import 'package:chat_app/Models/User_Model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final callRepositoryProvider = Provider((ref) {
  final callRepository = CallRepository(
      auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance);
  return callRepository;
});

class CallRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  CallRepository({required this.auth, required this.firestore});

  Future<String> sendCall(String receiverId, BuildContext context) async {
    DateTime calledTime = DateTime.now();
    String roomId = const Uuid().v1();

    try {
      var receiverState =
          await firestore.collection('callingState').doc(receiverId).get();
      var receiverUserData =
          await firestore.collection('users').doc(receiverId).get();

      UserModel user = UserModel.fromMap(receiverUserData.data()!);

      if (!receiverState.exists) {
        await firestore.collection('callingState').doc(receiverId).set({
          'request': true,
          'callerId': auth.currentUser!.uid,
          'roomId': roomId,
          'profilePic': user.profilePic,
          'callerName': user.name,
        });
      } else {
        await firestore.collection('callingState').doc(receiverId).update({
          'request': true,
          'callerId': auth.currentUser!.uid,
          'roomId': roomId,
          'profilePic': user.profilePic,
          'callerName': user.name,
        });
      }

      CallModel callDetails = CallModel(
        callerId: auth.currentUser!.uid,
        receiverId: user.name,
        callUid: roomId,
        duration: 0,
        timeCalled: calledTime,
        profilePic: user.profilePic,
      );

      await firestore
          .collection('callRecords')
          .doc(auth.currentUser!.uid)
          .collection('videoCalls')
          .doc(roomId)
          .set(callDetails.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return roomId;
  }

  Stream<List<CallModel>> getCallRecords(BuildContext context) {
    StreamController<List<CallModel>> controller =
        StreamController<List<CallModel>>();
    try {
      firestore
          .collection('callRecords')
          .doc(auth.currentUser!.uid)
          .collection('videoCalls')
          .snapshots()
          .listen((querySnapshot) {
        List<CallModel> newCallRecords = [];
        for (var doc in querySnapshot.docs) {
          CallModel model = CallModel.fromMap(doc.data());
          newCallRecords.add(model);
        }
        controller.add(newCallRecords);
      });
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return controller.stream;
  }

  void updateState(bool state) async {
    await firestore
        .collection('callingState')
        .doc(auth.currentUser!.uid)
        .update({
      'request': state,
    });
  }

  Stream<CallingStateModel> callingState() {
    return firestore
        .collection('callingState')
        .doc(auth.currentUser!.uid)
        .snapshots()
        .map((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        final Map<String, dynamic> data =
            snapshot.data() as Map<String, dynamic>;

        return CallingStateModel.fromMap(data);
      } else {
        return const CallingStateModel(
            callerId: '',
            request: false,
            roomId: '',
            profilePic: '',
            callerName: '');
      }
    });
  }
}
