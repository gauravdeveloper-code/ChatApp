import 'package:chat_app/Common/Utils/SnackBar.dart';
import 'package:chat_app/Features/Chat/Screens/MobileChatsScreen.dart';
import 'package:chat_app/Models/User_Model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectContactsRepositoryProvider = Provider(
    (ref) => SelectContactsRepository(fireStore: FirebaseFirestore.instance));

class SelectContactsRepository {
  final FirebaseFirestore fireStore;

  SelectContactsRepository({required this.fireStore});

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      final collection = await fireStore.collection('users').get();
      bool isFound = false;
      for (var document in collection.docs) {
        var userdata = UserModel.fromMap(document.data());
        var selectedPhoneNum =
            selectedContact.phones[0].number.replaceAll(' ', '');
        if (userdata.number == selectedPhoneNum) {
          isFound = true;
          Navigator.pushNamed(context, MobileChatScreen.RouteName,
              arguments: {'name': userdata.name, 'uid': userdata.uid});
        }
      }
      if (!isFound) {
        showSnackBar(
            context: context,
            content: 'This Number Does not Exist on this App');
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
