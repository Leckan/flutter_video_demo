import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../services/email_auth_service.dart';
import '../services/facebook_auth_service.dart';
import '../services/google_auth_service.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRegister = false;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                appState.setLoading(true);
                final user = await GoogleAuthService().signInWithGoogle();
                if (user != null) {
                  appState.setUser(user);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                  );
                }
                appState.setLoading(false);
              },
              child: Text('Sign in with Google'),
            ),
            ElevatedButton(
              onPressed: () async {
                appState.setLoading(true);
                final user = await FacebookAuthService().signInWithFacebook();
                if (user != null) {
                  appState.setUser(user);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                  );
                }
                appState.setLoading(false);
              },
              child: Text('Sign in with Facebook'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                appState.setLoading(true);
                final email = _emailController.text;
                final password = _passwordController.text;
                final authService = EmailAuthService();
                final user = _isRegister
                    ? await authService.registerWithEmail(email, password)
                    : await authService.signInWithEmail(email, password);
                if (user != null) {
                  appState.setUser(user);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                  );
                }
                appState.setLoading(false);
              },
              child: Text(_isRegister ? 'Register' : 'Login'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isRegister = !_isRegister;
                });
              },
              child: Text(_isRegister ? 'Switch to Login' : 'Switch to Register'),
            ),
            if (appState.isLoading) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}