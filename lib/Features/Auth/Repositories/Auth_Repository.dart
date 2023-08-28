import 'dart:io';
import 'package:chat_app/Common/Repositiories/Common_Firesbase_Storage_Repositories.dart';
import 'package:chat_app/Common/Utils/SnackBar.dart';
import 'package:chat_app/Features/Auth/Screens/Otp_Screen.dart';
import 'package:chat_app/Features/Auth/Screens/User_Info_Screen.dart';
import 'package:chat_app/Features/Screens/Moblie_Screen.dart';
import 'package:chat_app/Models/User_Model.dart';
import 'package:chat_app/Widgets/Constants/Urls.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod/riverpod.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class AuthRepository {
  final FirebaseAuth auth;

  final FirebaseFirestore firestore;

  AuthRepository({required this.auth, required this.firestore});

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await auth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (FirebaseAuthException error) {
            showSnackBar(context: context, content: error.message.toString());
          },
          codeSent: (String verificationId, int? forceResendingToken) async {
            await Navigator.pushNamed(context, Otp_Screen.RouteName,
                arguments: verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message.toString());
    }
  }

  void verifyOtp(
      {required String otp,
      required BuildContext context,
      required String verificationId}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(
          context, UserInfoScreen.RouteName, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void saveUserDataToFirebase({
    required String userName,
    required File? profilePic,
    required BuildContext context,
    required ProviderRef ref,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl = profile;
      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase('Profile/$uid', profilePic);
      }
      var user = UserModel(
          profilePic: photoUrl,
          name: userName,
          uid: uid,
          number: auth.currentUser!.phoneNumber.toString(),
          isOnline: true,
          groupId: []);
      await firestore.collection('users').doc(uid).set(user.toMap());
      Navigator.pushNamedAndRemoveUntil(
          context, MobileScreen.RouteName, (route) => false);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  Stream<UserModel> userData(String userId) {
    final stream = firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
    return stream;
  }
}
