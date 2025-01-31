import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_learning_app/models/user_model.dart';
import 'package:e_learning_app/routes/app_routes.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  final Rx<User?> _firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> _userModel = Rx<UserModel?>(null);
  
  User? get firebaseUser => _firebaseUser.value;
  UserModel? get userModel => _userModel.value;
  
  @override
  void onReady() {
    super.onReady();
    _firebaseUser.bindStream(_auth.authStateChanges());
    ever(_firebaseUser, _setInitialScreen);
  }
  
  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAllNamed(AppRoutes.login);
    } else {
      _loadUserModel(user.uid);
      Get.offAllNamed(AppRoutes.home);
    }
  }
  
  Future<void> _loadUserModel(String uid) async {
    // TODO: Load user data from Firestore
  }
  
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      // Will implement in next step
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
  
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      // Will implement in next step
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
  
  Future<void> forgotPassword(String email) async {
    try {
      // Will implement in next step
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
  
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
  
  Future<void> updateProfile({
    String? fullName,
    String? photoUrl,
  }) async {
    try {
      // Will implement in next step
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
