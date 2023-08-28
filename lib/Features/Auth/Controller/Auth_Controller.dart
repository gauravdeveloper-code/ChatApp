import 'dart:io';
import 'package:chat_app/Features/Auth/Repositories/Auth_Repository.dart';
import 'package:chat_app/Models/User_Model.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod/riverpod.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final ProviderRef ref;
  final AuthRepository authRepository;

  AuthController({required this.ref, required this.authRepository});

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOtp(BuildContext context, String verificationId, String otp) {
    authRepository.verifyOtp(
        otp: otp, context: context, verificationId: verificationId);
  }

  void saveUserDataToFirebase(
      String name, File? profilePic, BuildContext context) {
    authRepository.saveUserDataToFirebase(
        userName: name, profilePic: profilePic, context: context, ref: ref);
  }

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  Stream<UserModel> userDataById(String userId) {
    return authRepository.userData(userId);
  }
}
