import 'package:chat_app/Features/Call/Repository/CallRepository.dart';
import 'package:chat_app/Models/CallModel.dart';
import 'package:chat_app/Models/CallingStateModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final callControllerProvider = Provider((ref) {
  final callRepository = ref.watch(callRepositoryProvider);
  return CallController(ref: ref, callRepository: callRepository);
});

class CallController{
  final ProviderRef ref;
  final CallRepository callRepository;

  const CallController({
    required this.ref,
    required this.callRepository,
  });

  Future<String> sendCall(String receiverId,BuildContext context){
   var roomId =   ref.read(callRepositoryProvider).sendCall(receiverId, context);
   return roomId;
  }

  void updateState(bool state)
  {
    callRepository.updateState(state);
  }

  Stream<CallingStateModel> callingState() {
    return callRepository.callingState();
  }

  Stream<List<CallModel>> getCallRecords(BuildContext context) {
    return callRepository.getCallRecords(context);
  }

}