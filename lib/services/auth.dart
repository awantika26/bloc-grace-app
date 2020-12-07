import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grace_app_project/model/user.dart';
import 'package:grace_app_project/services/database.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future getCurrentID() async {
    try {
      return (await _firebaseAuth.currentUser()).uid;
    } catch (e) {
      return e.message;
    }
  }

  Future getCurrentuser() async {
    try {
      return await _firebaseAuth.currentUser();
    } catch (e) {
      return e.message;
    }
  }

  Future getJournal() async {
    try {
      var id = (await _firebaseAuth.currentUser()).uid;
      return await Firestore.instance
          .collection('journal')
          .document(id)
          .collection('user_journal')
          .getDocuments();
    } catch (e) {
      return e.message;
    }
  }

  getUsername(String username) async {
    try {
      return await Firestore.instance
          .collection('grace')
          .where('username', isEqualTo: username)
          .getDocuments();
    } catch (e) {
      return e.message;
    }
  }

  Future getUser() async {
    try {
      return await Firestore.instance.collection('grace').getDocuments();
    } catch (e) {
      return e.message;
    }
  }

  Future getMessage() async {
    try {
      return await Firestore.instance.collection('messages').getDocuments();
    } catch (e) {
      return e.message;
    }
  }

  Future getProfile() async {
    try {
      return await Firestore.instance.collection('profile').getDocuments();
    } catch (e) {
      return e.message;
    }
  }

  Future getdata() async {
    try {
      return Firestore.instance.collection('journal').snapshots();
    } catch (e) {
      return e.message;
    }
  }

  Future<String> signin(String email, String password) async {
    try {
      return (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .uid;
    } catch (e) {
      return e.message;
    }
  }

  Future<String> signUp(
      String email, String password, String name, String url) async {
    try {
      var user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user.sendEmailVerification();
      FirebaseUser users = user;
      await DatabaseService().createUserData(name, users.uid, email, url);
      var userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = name;
      userUpdateInfo.photoUrl = url;
      await user.updateProfile(userUpdateInfo);

      await user.reload();

      return user.uid;
    } catch (e) {
      return e.message;
    }
  }

  Future<String> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return "reset email sent ";
    } catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      return e.message;
    }
  }

  Future resendverifyemail() async {
    try {
      final FirebaseUser user = await _firebaseAuth.currentUser();
      user.sendEmailVerification();
      return user?.uid;
    } catch (e) {
      return e.message;
    }
  }
}
