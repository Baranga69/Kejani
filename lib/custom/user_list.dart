import 'package:another_nav_bar/models/details.dart';
import 'package:another_nav_bar/utilities/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  const UserList({ Key? key }) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {

    final uData = Provider.of<List<Details>>(context);
    
    return ListView.builder(
      itemCount: uData.length,
      itemBuilder: (context, index){
        return UserTile(details: uData[index],);
      },

    );
  }
}