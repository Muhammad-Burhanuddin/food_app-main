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
      if (cred.user != null) {
        await saveUserInfo(cred.user!);
      }
      return cred.user;
    } on FirebaseAuthException catch (e) {
      log("Error creating user: ${e.message}");
    } catch (e) {
      log("Unexpected error creating user: $e");
    }
    return null;
  }

  Future<void> saveUserInfo(User user) async {
    final userDoc = _firestore.collection('User').doc(user.uid);

    final userSnapshot = await userDoc.get();

    if (!userSnapshot.exists) {
      await userDoc.set({
        'userId': user.uid,
        'email': user.email,
        'name': user.displayName,
        'createdAt': FieldValue.serverTimestamp(),
        'signInMethod': user.providerData[0].providerId,
      });
    }
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
      } else {
        log("No such document found for userId: $userId");
      }
    } catch (e) {
      log("Error fetching user details: $e");
    }
    return null;
  }

  Future<UserModel?> fetchUserDetailsByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('User')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return UserModel.fromJson(querySnapshot.docs.first.data());
      } else {
        log("No document found for email: $email");
      }
    } catch (e) {
      log("Error fetching user details by email: $e");
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

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      log("Password reset email sent");
    } on FirebaseAuthException catch (e) {
      log("Error sending password reset email: ${e.message}");
    } catch (e) {
      log("Unexpected error sending password reset email: $e");
    }
  }
}
