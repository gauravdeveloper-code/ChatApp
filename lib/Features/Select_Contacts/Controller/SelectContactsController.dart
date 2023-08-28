import 'package:chat_app/Features/Select_Contacts/Repository/SelectContactsRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getContactsProvider = FutureProvider((ref) {
  final selectContactsRepository = ref.watch(selectContactsRepositoryProvider);
  return selectContactsRepository.getContacts();
});

final selectContactControllerProvider = Provider((ref) {
  final selectContactRepository = ref.watch(selectContactsRepositoryProvider);
  return SelectContactController(
      ref: ref, selectContactRepository: selectContactRepository);
});

class SelectContactController {
  final ProviderRef ref;
  final selectContactRepository;

  SelectContactController(
      {required this.ref, required this.selectContactRepository});

  void selectContact(Contact selectedContact, BuildContext context) async {
    await selectContactRepository.selectContact(selectedContact, context);
  }
}
