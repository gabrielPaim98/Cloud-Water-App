import 'package:cloud_water/instances.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginService {
  Future<LoginResult> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential? user;
    LoginResult result = LoginResult.WRONG_CREDENTIAL;
    try {
      user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      result = LoginResult.SUCCESS;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        result = LoginResult.WRONG_CREDENTIAL;
        user = null;
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        result = LoginResult.WRONG_CREDENTIAL;
        user = null;
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      user = null;
      result = LoginResult.WRONG_CREDENTIAL;
      print('Error sign in with email and password: $e');
    }
    Instances.user = user?.user;
    print('user: ${user?.user?.uid}');
    return result;
  }

  Future<LoginResult> signInAnonymously() async {
    LoginResult result = LoginResult.WRONG_CREDENTIAL;
    try {
      UserCredential user = await Instances.firebaseAuth.signInAnonymously();
      Instances.user = user.user;
      print('user: ${user.user?.uid}');

      if (user.user != null) {
        result = LoginResult.SUCCESS;
      }
    } catch (e) {
      print('Error logging in anonymously: $e');
      result = LoginResult.WRONG_CREDENTIAL;
    }

    return result;
  }

  Future<LoginResult> createUserWithEmailAndPassword(
      String email, String password) async {
    LoginResult result = LoginResult.WRONG_CREDENTIAL;
    UserCredential? user;
    try {
      user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      result = LoginResult.SUCCESS;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        result = LoginResult.WEAK_PASSWORD;
        user = null;
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        result = LoginResult.EMAIL_IN_USE;
        user = null;
        print('The account already exists for that email.');
      }
    } catch (e) {
      result = LoginResult.WRONG_CREDENTIAL;
      user = null;
      print('Error creating user with email and password: $e');
    }
    Instances.user = user?.user;
    print('user: ${user?.user?.uid}');
    return result;
  }

  Future<User?> currentUser() async {
    User? user;
    try {
      user = FirebaseAuth.instance.currentUser;
    } catch (e) {
      print('failed to get current user: $e');
      user = null;
    }
    Instances.user = user;
    print('user: ${user?.uid}');
    return user;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Instances.user = null;
  }
}

enum LoginResult { SUCCESS, WRONG_CREDENTIAL, WEAK_PASSWORD, EMAIL_IN_USE }
