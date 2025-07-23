import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../models/user.dart';
import '../services/app_state.dart';
import 'upload_screen.dart';
import 'auth_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final user = appState.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (user != null) ...[
              Text('Welcome, ${user.name ?? user.email}'),
              Text('Provider: ${user.provider.toString().split('.').last}'),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UploadScreen()),
                  );
                },
                child: Text('Upload Video'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: appState.uploads.length,
                  itemBuilder: (context, index) {
                    final upload = appState.uploads[index];
                    return ListTile(
                      title: Text(upload.filename),
                      subtitle: Text('Status: ${upload.status.toString().split('.').last}'),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await fb.FirebaseAuth.instance.signOut();
                  appState.setUser(null as User);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => AuthScreen()),
                  );
                },
                child: Text('Logout'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}