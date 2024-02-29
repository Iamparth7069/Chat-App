import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:module6/chat-app-with-firebase/components/chat_bubble.dart';
import 'package:module6/chat-app-with-firebase/components/my_textfield.dart';
import 'package:module6/chat-app-with-firebase/service/auth/auth_service.dart';
import 'package:module6/chat-app-with-firebase/service/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
   ChatPage({
     super.key,
     required this.receiverEmail,
     required this.receiverID
   });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
   final TextEditingController _messageController = TextEditingController();

   //chat & auth services
  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();

  FocusNode myFocusNode = FocusNode();

  @override
  void initState(){
    super.initState();
    //add listener to focus node

    myFocusNode.addListener((){
      if(myFocusNode.hasFocus){
        Future.delayed(
          Duration(milliseconds: 500),
            () => scrollDown(),
        );
      }
    });
    //wait a bit for listview to be build,then scroll to bottom
    Future.delayed(
      Duration(milliseconds: 500),
        () => scrollDown(),
    );
  }

  @override
  void dispose(){
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }
//scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown(){
    _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(seconds:1),
    curve: Curves.fastOutSlowIn,
    );
  }
  //send message
  void sendMessage() async {
    //if there is something inside the textfeild
    if(_messageController.text.isNotEmpty){
      //send message
      await _chatService.sendMessage(
      widget.receiverID, _messageController.text);
      //clear text controller
    _messageController.clear();

    //clear text controller
      _messageController.clear();
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          //display all message
          Expanded(
              child: _buildMessageList(),
          ),
          //user input
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderId),
        builder: (context,snapshot) {
        //errors
          if(snapshot.hasError) {
            return const Text('Error');
          }
          //Loading
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }
          //return listview
          return ListView(
            controller: _scrollController,
            children:
            snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
          );
        },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String,dynamic> data = doc.data() as Map<String,dynamic>;
    //is current user
  bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
  //align message to the right if sender is current user,otherwise left
  var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(alignment: alignment,
        child: Column(
          crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children:[
               ChatBubble(message: data['message'], isCurrentUser: isCurrentUser),
          ],
        ));
  }

  // build message input
  Widget _buildUserInput(){
    return Padding(
      padding: EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          //Textfeild should take up most of the space
          Expanded(
              child: MyTextField(
                controller: _messageController,
                hintText: 'Type a message',
                obscureText: false,
                focusNode: myFocusNode,
              ),
          ),
          //send button
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.only(right: 25),
            child: IconButton(
                onPressed: sendMessage,
                icon: const Icon(Icons.arrow_upward,
                  color: Colors.white,
                ),
            ),
          ),
        ],
      ),
    );
  }
}