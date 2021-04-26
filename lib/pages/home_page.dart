import 'package:flutter/material.dart';
import 'package:kava_journal/services/shared_preferences_service.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Journal"),
        elevation: 0,
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onPressed: () {
              SharedPreferencesService.logout(context);
            },
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Text("Dashboard"),
      ),
    );
  }
}
