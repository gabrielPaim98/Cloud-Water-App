import 'package:cloud_water/instances.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginService {
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential? user;
    try {
      user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        user = null;
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        user = null;
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      user = null;
      print(e);
    }
    Instances.user = user?.user;
    print('user: ${user?.user?.uid}');
    return user;
  }

  Future<UserCredential?> signInAnonymously() async {
    UserCredential user = await Instances.firebaseAuth.signInAnonymously();
    Instances.user = user.user;
    print('user: ${user.user?.uid}');
    return user;
  }

  Future<UserCredential?> createUserWithEmailAndPassword(
      String email, String password) async {
    UserCredential? user;
    try {
      user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        user = null;
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        user = null;
        print('The account already exists for that email.');
      }
    } catch (e) {
      user = null;
      print(e);
    }
    Instances.user = user?.user;
    print('user: ${user?.user?.uid}');
    return user;
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
