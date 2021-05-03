import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:hydro_app/authentication.dart';
import 'package:hydro_app/profile_settings/profile_main.dart';

/// Google sign-in button
/// Displays a loading icon while signing in.
class GoogleSignInButton extends StatefulWidget {
  final ProfileMainState parent;

  GoogleSignInButton(this.parent);

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  void _signIn() async {
    setState(() {
      _isSigningIn = true;
    });

    User user = await Authentication.signInWithGoogle(context: context);

    setState(() {
      _isSigningIn = false;
    });

    if (user != null) {
      widget.parent.updateUser();
    }

    setState(() {
      _isSigningIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: _signIn,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign in with Google',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

/// Google sign-out button
/// Displays a loading icon while signing out.
class GoogleSignOutButton extends StatefulWidget {
  final ProfileMainState parent;

  GoogleSignOutButton(this.parent);

  @override
  _GoogleSignOutButtonState createState() => _GoogleSignOutButtonState();
}

class _GoogleSignOutButtonState extends State<GoogleSignOutButton> {
  bool _isSigningOut = false;

  void _signOut() async {
    setState(() {
      _isSigningOut = true;
    });
    await Authentication.signOut(context: context);
    setState(() {
      _isSigningOut = false;
    });
    widget.parent.updateUser();
  }

  @override
  Widget build(BuildContext context) {
    return _isSigningOut
        ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          )
        : ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Colors.redAccent,
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onPressed: _signOut,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
          );
  }
}
