import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final CollectionReference _collectionReference =
      Firestore.instance.collection('grace');
  final CollectionReference _collectionReferencejournal =
      Firestore.instance.collection('journal');
  final CollectionReference _collectionReferenceprofile =
      Firestore.instance.collection('profile');

  Future<void> createUserData(
      String username, String uid, String email, String url) async {
    DocumentReference documentReference = _collectionReference.document(uid);
    return await documentReference.setData({
      'username': username,
      'email': email,
      'url': url,
      'id': documentReference.documentID
    });
  }

  Future<void> createJournal(
      String title, String description, String uid) async {
    DocumentReference documentReference = _collectionReferencejournal
        .document(uid)
        .collection('user_journal')
        .document();
    return await documentReference.setData({
      'title': title,
      'description': description,
      'id': documentReference.documentID,
      'created': DateTime.now(),
    }, merge: true);
  }

  Future<void> createProfile(
    String university,
    String email,
    String dorm,
    String location,
    String mobile,
  ) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    var userid = (await _firebaseAuth.currentUser()).uid;
    DocumentReference documentReference = _collectionReferenceprofile
        .document(userid)
        .collection('user_profile')
        .document();
    return await documentReference.setData({
      'university': university,
      'email': email,
      'dorm': dorm,
      'location': location,
      'mobile': mobile,
      'id': documentReference.documentID
    });
  }

  Future<void> updateimageandusername(
    String url,
    String username,
  ) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    var id = (await _firebaseAuth.currentUser()).uid;
    return await _collectionReference.document(id).updateData({
      'username': username,
      'url': url,
    });
  }

  Future<void> updateProfile(
    String id,
    String university,
    String email,
    String dorm,
    String location,
    String mobile,
  ) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    var userid = (await _firebaseAuth.currentUser()).uid;
    return await Firestore.instance
        .collection('profile')
        .document(userid)
        .collection('user_profile')
        .document(id)
        .updateData({
      'university': university,
      'email': email,
      'dorm': dorm,
      'location': location,
      'mobile': mobile,
    });
  }

  Future<void> updateJournal(id, description) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    var userid = (await _firebaseAuth.currentUser()).uid;
    return await Firestore.instance
        .collection('journal')
        .document(userid)
        .collection('user_journal')
        .document(id)
        .updateData({
      'description': description,
    });
  }

  deleteJournal(uid) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    var userid = (await _firebaseAuth.currentUser()).uid;
    return await Firestore.instance
        .collection('journal')
        .document(userid)
        .collection('user_journal')
        .document(uid)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

  Stream<QuerySnapshot> get grace {
    return _collectionReference.snapshots();
  }
}
