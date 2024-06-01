import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_model.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      log("Error creating user: ${e.message}");
    } catch (e) {
      log("Unexpected error creating user: $e");
    }
    return null;
  }

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      log("Error logging in: ${e.message}");
    } catch (e) {
      log("Unexpected error logging in: $e");
    }
    return null;
  }

  Future<UserModel?> fetchUserDetails(String userId) async {
    try {
      final doc = await _firestore.collection('User').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }
    } catch (e) {
      log("Error fetching user details: $e");
    }
    return null;
  }

  Future<void> updateUserProfilePicture(String userId, String imageUrl) async {
    try {
      await _firestore
          .collection('User')
          .doc(userId)
          .update({'imageUrl': imageUrl});
    } catch (e) {
      log("Error updating profile picture: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Error signing out: $e");
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
