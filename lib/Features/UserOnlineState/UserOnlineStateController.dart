import 'package:chat_app/Features/UserOnlineState/UserOnlineStateRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userStateControllerProvider = Provider((ref) {
  final userStateRepository = ref.watch(userStateProvider);
  return UserOnlineStateController(userOnlineStateRepository: userStateRepository);
});

class UserOnlineStateController{
  final UserOnlineStateRepository userOnlineStateRepository;
  UserOnlineStateController({required this.userOnlineStateRepository});
  void setUserState(bool isOnline)
  {
    userOnlineStateRepository.setUserState(isOnline);
  }
}