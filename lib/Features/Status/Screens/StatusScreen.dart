import 'package:chat_app/Common/Widgets/Loader.dart';
import 'package:chat_app/Features/Status/Controller/StatusController.dart';
import 'package:chat_app/Models/StatusModel.dart';
import 'package:chat_app/Widgets/Constants/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class StatusScreen extends ConsumerWidget {
  const StatusScreen({super.key});
  static const RouteName = 'StatusScreen';
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return FutureBuilder<List<StatusModel>>(
      future: ref.read(statusControllerProvider).getStatus(context),
      builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting)
          {
            return const Loader();
          }
        return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context,index){
              var statusData = snapshot.data![index];
              return Column(
                children: [
                  InkWell(
                    onTap: () {

                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: InkWell(
                          child: CircleAvatar(
                            backgroundImage:
                            NetworkImage(statusData.profilePic),
                            radius: 30,
                          ),
                          onTap: () {},
                        ),
                        title: IgnorePointer(
                          child: Text(
                            statusData.userName,
                            style: const TextStyle(fontSize: 22),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    color: dividerColor,
                    indent: 85,
                  )
                ],
              );
        });
      },
    );
  }
}
