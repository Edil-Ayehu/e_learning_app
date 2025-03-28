import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_learning_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      
      // Get user data from Firestore
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    });
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.updateDisplayName(fullName);

      final user = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        fullName: fullName,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        role: role,
      );

      // Save user data to Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(user.toFirestore());

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get user data from Firestore
      final doc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!doc.exists) {
        throw Exception('User data not found');
      }

      final user = UserModel.fromFirestore(doc);

      // Update last login time
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({'lastLoginAt': Timestamp.now()});

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> updateProfile({
    String? fullName,
    String? photoUrl,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('User not found');

      if (fullName != null) {
        await user.updateDisplayName(fullName);
      }
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
    case 'weak-password':
      return 'Password should be at least 6 characters long';
    case 'email-already-in-use':
      return 'An account already exists with this email';
    case 'user-not-found':
      return 'No account found with this email';
    case 'wrong-password':
      return 'Incorrect password';
    case 'invalid-email':
      return 'Please enter a valid email address';
    case 'user-disabled':
      return 'This account has been disabled';
    case 'operation-not-allowed':
      return 'Email & Password sign-in is not enabled';
    case 'too-many-requests':
      return 'Too many attempts. Please try again later';
    case 'network-request-failed':
      return 'Network error. Please check your connection';
    case 'invalid-credential':
      return 'Invalid login credentials';
    case 'account-exists-with-different-credential':
      return 'An account already exists with a different sign-in method';
    default:
      return e.message ?? 'An unexpected error occurred';
    }
  }
}
