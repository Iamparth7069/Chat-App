import 'package:flutter/material.dart';
import 'package:module6/chat-app-with-firebase/components/my_drawer.dart';
import 'package:module6/chat-app-with-firebase/service/auth/auth_service.dart';
import 'package:module6/chat-app-with-firebase/service/chat/chat_service.dart';

import '../components/user_tile.dart';
import 'chat_page.dart';

class HomePage extends StatelessWidget {
   HomePage({super.key});

  //chat and auth service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: const Text('Home'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }
  //Build a list of users except for the current logged in user
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
        builder: (context,snapshot){
        //error
          if(snapshot.hasError) {
            return Text('Error');
          }
          //loading
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading...');
          }
          return ListView(
            children: snapshot.data!.map<Widget>((userData)=>_buildUserListItem(userData, context)).toList(),
          );
        },
    );
  }

  //build individual list tile for user
  Widget _buildUserListItem(
      Map<String,dynamic> userData,BuildContext context){
    if(userData['email'] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData['email'].toString(),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder:    (context)=>ChatPage(
            receiverEmail: userData['email'],
            receiverID: userData['uid'],
          ),));
        },
      );
    } else {
      return Container();
    }
  }

}
