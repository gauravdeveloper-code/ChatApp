import 'package:chat_app/Common/Widgets/Loader.dart';
import 'package:chat_app/ErrorPage.dart';
import 'package:chat_app/Features/Select_Contacts/Controller/SelectContactsController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectContactsScreen extends ConsumerWidget {
  static const RouteName = 'SelectContactsScreen';

  const SelectContactsScreen({Key? key}) : super(key: key);

  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
        title: const Text('Select Contact'),
      ),
      body: ref.watch(getContactsProvider).when(data: (contactList) {
        return ListView.builder(
            itemCount: contactList.length,
            itemBuilder: (context, index) {
              final contact = contactList[index];
              return InkWell(
                onTap: () => selectContact(ref, contact, context),
                child: ListTile(
                  title: Text(contact.displayName),
                  subtitle: Text(contact.phones[0].number),
                  leading: contact.photo == null
                      ? null
                      : CircleAvatar(
                          backgroundImage: MemoryImage(contact.photo!),
                        ),
                ),
              );
            });
      }, error: (err, stacktrace) {
        return ErrorPage(
          error: err.toString(),
        );
      }, loading: () {
        return const Loader();
      }),
    );
  }
}
