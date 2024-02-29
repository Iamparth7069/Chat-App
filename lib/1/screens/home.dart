import 'package:flutter/material.dart';

import '../firebase/firebase.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void logout() {
    final _auth = FirebaseService();
    _auth.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Home'),
        actions: [
          //Logout button
          IconButton(onPressed: logout, icon: Icon(Icons.logout))
        ],
      ),
      drawer: Drawer(),
    );
  }
}