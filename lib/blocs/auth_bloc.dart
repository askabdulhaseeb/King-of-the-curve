import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kings_of_the_curve/services/auth_services.dart';
import 'package:kings_of_the_curve/utils/baseClass.dart';

class AuthBloc with BaseClass {
  final authService = AuthService();
  final fb = FacebookLogin();
  final googleSignIn = GoogleSignIn(scopes: ['email']);

  Stream<User> get currentUser => authService.currentUser;

  loginGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount googleUser =
          await googleSignIn.signIn().catchError((onError) {
        print(onError);
        showError(context, 'Google Authorization Cancelled');
      });
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        print("Show Loader");
        showCircularDialog(context);
        AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

        //Sign in to firebase  (user credential to sign in with firebase)
        final result = await authService.signInWithCredentials(credential);

        // check if user exists

        print(
            "${result.user.providerData.elementAt(0).email} is now logged in");
      } else {
        showError(context, 'Google Authorization Cancelled');
      }
    } catch (error) {
      Navigator.pop(context);
      if (error.toString() ==
          "[firebase_auth/account-exists-with-different-credential] An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.") {
        showError(context,
            "An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.");
      }
      /*showError(context, error.toString());
      print("Google Failed" + error.toString());*/
    }
  }

  loginFacebook(BuildContext context) async {
    print("Starting facebook login");
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email
    ]);

    switch (res.status) {
      case FacebookLoginStatus.success:
        // TODO: Handle this case.
        try {
          showCircularDialog(context);
          // GET TOKEN
          final FacebookAccessToken fbToken = res.accessToken;

          // Convert to Auth Credentials
          AuthCredential credential =
              FacebookAuthProvider.credential(fbToken.token);

          //Sign in to firebase  (user credential to sign in with firebase)
          final result = await authService.signInWithCredentials(credential);

          print("${result.user.displayName} is now logged in");
        } catch (error) {
          Navigator.pop(context);
          if (error.toString() ==
              "[firebase_auth/account-exists-with-different-credential] An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.") {
            showError(context,
                "An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.");
          }
        }
        // check iif user exists

        break;
      case FacebookLoginStatus.cancel:
        // TODO: Handle this case.
        print("FACEBOOK LOGIN CANCELLED by USER");
        break;

        break;
      case FacebookLoginStatus.error:
        // TODO: Handle this case.
        print("FACEBOOK LOGIN AUTHORIZATION ERROR");
        print(res.error.toString());
        break;
        break;
    }
  }

  Future<User> signInApple(BuildContext context) async {
    if (!await AppleSignIn.isAvailable()) {
      showError(context, "This Device is not eligible for Apple Sign in");
      print("This Device is not eligible for Apple Sign in");
      throw "This Device is not eligible for Apple Sign in";
    }
    final res = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    if (res.status == AuthorizationStatus.authorized) {
      try {
        final AppleIdCredential appleIdCredential = res.credential;
        final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken),
            accessToken:
                String.fromCharCodes(appleIdCredential.authorizationCode));
        final result =
            await authService.signInWithCredentialsForApple(credential);
        if (appleIdCredential.fullName.familyName != null &&
            appleIdCredential.fullName.givenName != null) {
         await result.user.updateProfile(
              displayName:
                  '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}');
        }
        print("${result.user.displayName} is now logged in");
        return result.user;
      } on PlatformException catch (error) {
        throw error.message;
        /*Navigator.pop(context);
        showError(context, error.message);*/
      } on FirebaseAuthException catch (error) {
        throw error.message;
        /*Navigator.pop(context);
        showError(context, error.message);*/
      }
    } else if (res.status == AuthorizationStatus.error) {
      throw 'Apple authorization failed';
    } else if (res.status == AuthorizationStatus.cancelled) {
      throw 'Apple authorization cancelled';
    } else {
      return null;
    }
    /* switch (res.status) {
      case AuthorizationStatus.authorized:
        try {
          final AppleIdCredential appleIdCredential = res.credential;
          final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
          final credential = oAuthProvider.credential(
              idToken: String.fromCharCodes(appleIdCredential.identityToken),
              accessToken:
                  String.fromCharCodes(appleIdCredential.authorizationCode));
          final result = await authService.signInWithCredentialsForApple(credential);

          print("${result.user.displayName} is now logged in");
        } on PlatformException catch (error) {
          Navigator.pop(context);
          showError(context, error.message);
        } on FirebaseAuthException catch (error) {
          Navigator.pop(context);
          showError(context, error.message);
        }
        break;
      case AuthorizationStatus.error:
        Navigator.pop(context);
        showError(context, 'Apple authorization failed');
        break;
      case AuthorizationStatus.cancelled:
        Navigator.pop(context);
        break;
    }*/
  }

  logout() async {
    await authService.logout();
  }
}
