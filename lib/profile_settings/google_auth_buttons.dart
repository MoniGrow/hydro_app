import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:home_widget/home_widget.dart';

import 'package:hydro_app/authentication.dart';
import 'package:hydro_app/profile_settings/profile_main.dart';

/// Google sign-in button
/// Displays a loading icon while signing in.
class GoogleSignInButton extends StatefulWidget {
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
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ProfileMain(user)));
      HomeWidget.updateWidget(
        name: "StatDisplayWidget",
        androidName: "StatDisplayWidget",
        iOSName: "StatDisplayWidget"
      );
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
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
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
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ProfileMain(null)));
    HomeWidget.updateWidget(
        name: "StatDisplayWidget",
        androidName: "StatDisplayWidget",
        iOSName: "StatDisplayWidget"
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isSigningOut
        ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
          );
  }
}
