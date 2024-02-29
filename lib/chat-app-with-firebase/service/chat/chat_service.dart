import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:module6/chat-app-with-firebase/models/message.dart';

class ChatService{
  //get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //get user stream
  Stream<List<Map<String,dynamic>>> getUsersStream(){
    return _firestore.collection('Users').snapshots().map((snapshot){
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }
  //send message
  Future<void> sendMessage(String receiverID,message)async {
    //get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // Create a new message
    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail:currentUserEmail ,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp,
    );
    // Construct chat room Id for two users

    List<String> ids = [currentUserID,receiverID];
    ids.sort();
    String chatRoomId = ids.join('_');

    // add new message to database
    await _firestore.collection("chat_rooms")
    .doc(chatRoomId)
    .collection('messages')
    .add(newMessage.toMap());
  }
  //Get Message
  Stream<QuerySnapshot> getMessages(String userID,otherUserId) {
    // construct a chatroom ID for the two users
    List<String> ids = [userID,otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp',descending: false)
        .snapshots();
  }
}