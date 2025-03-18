import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../util/notifications_helper.dart';
import '../models/app_user.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firebaseFireStore;

  AppUser? _currentUser;

  AuthProvider(this._auth, this._firebaseFireStore);

  User? get firebaseUser => _auth.currentUser;

  AppUser? get currentUser => _currentUser;

  bool get isLoggedIn => currentUser != null;

  Future<void> init() async {
    if (_auth.currentUser != null) {
      await _fetchCurrentUserData();
    }
  }

  Future<void> _fetchCurrentUserData() async {
    final userDoc = await _firebaseFireStore.collection('users').doc(_auth.currentUser?.uid).get();

    if (!userDoc.exists) {
      await _denyAccess('${_auth.currentUser!.email} is not registered as a member.');
      return;
    }

    try {
      _initializeNewSession(
        AppUser.fromJson(userDoc.data()!),
      );
    } catch (e, s) {
      NotificationsHelper().printIfDebugMode('AppUser Init error: $e $s');
      await _denyAccess('There seems to be a problem with your account. Please contact support or try again later.');
    }
  }

  Future<void> _denyAccess(String message) async {
    NotificationsHelper().showError('Permission denied. $message');
  }

  void _initializeNewSession(AppUser user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _fetchCurrentUserData();
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            throw 'No user found with this email.';
          case 'wrong-password':
            throw 'Wrong password provided.';
          case 'invalid-email':
            throw 'Invalid email address.';
          case 'user-disabled':
            throw 'This account has been disabled.';
          default:
            throw 'Authentication failed: ${e.message}';
        }
      }
      rethrow;
    }
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final user = AppUser.fromJson(
        {
          'firebaseUid': userCredential.user!.uid,
          'firstName': '',
          'lastName': '',
          'email': email,
          'registrationDate': DateTime.now().millisecondsSinceEpoch,
        }
      );
      await _firebaseFireStore.collection('users').doc(userCredential.user!.uid).set(user.toJson());
      _initializeNewSession(user);
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'weak-password':
            throw 'The password provided is too weak.';
          case 'email-already-in-use':
            throw 'An account already exists for this email.';
          case 'invalid-email':
            throw 'Invalid email address.';
          default:
            throw 'Registration failed: ${e.message}';
        }
      }
      rethrow;
    }
  }

  Future<void> updateCurrentUser(AppUser newUser, {bool localOnly = true}) async {
    _currentUser = newUser;
    if (!localOnly) {
      await _firebaseFireStore.collection('users').doc(_auth.currentUser!.uid).set(newUser.toJson());
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
    notifyListeners();
  }
}
