import 'package:chat_app/Features/Chat/Widgets/Contact_List.dart';
import 'package:chat_app/Widgets/Constants/Urls.dart';
import 'package:chat_app/Widgets/Constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class web_search_bar extends StatelessWidget {
  const web_search_bar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.3,
      child: const TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          prefixIconConstraints: BoxConstraints(minWidth: 60,minHeight: 20),
          hintText : 'Search or start new chat',
          filled: true,
          fillColor: searchBarColor,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            gapPadding: 30,
            borderRadius: BorderRadius.all(Radius.circular(10))
          )
        ),
      ),
    );
  }
}


class web_appBar extends StatelessWidget {
  const web_appBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appBarColor,
      width: MediaQuery.of(context).size.width*0.3,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: CircleAvatar(
              backgroundImage: NetworkImage('$profile'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                  padding:EdgeInsets.all(10),
                  child: Icon(Icons.people)
              ),
              Padding(
                  padding:EdgeInsets.all(10),
                  child: Icon(Icons.history_toggle_off)
              ),
              Padding(
                  padding:EdgeInsets.all(10),
                  child: Icon(Icons.message)
              ),
              Padding(
                  padding:EdgeInsets.all(10),
                  child: Icon(Icons.menu)
              ),
            ],
          )
        ],
      ),
    );
  }
}


class web_message_appbar extends StatelessWidget {
   web_message_appbar({Key? key}) : super(key: key);
  var name = Contact_List();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.7,
      color: appBarColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 80,
            width: 500,
            child: ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage('$profile'),),
              title: Text(name.toString(),style: TextStyle(fontSize: 15),),
              subtitle: Text('Last seen at ${DateTime.timestamp().hour} : ${DateTime.timestamp().minute}'),
            ),
          ),
          Row(
            children: [
              Icon(Icons.search),
              SizedBox(width: 10,),
              Icon(Icons.menu),
              SizedBox(width: 20,),
            ],
          )
        ],
      )
    );
  }
}


class bottom_messaging_box extends StatelessWidget {
  const bottom_messaging_box({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      color: CupertinoColors.lightBackgroundGray,
      child: Row(
        children: [

        ],
      ),
    );
  }
}

