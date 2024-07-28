import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/utils/snack_bar.dart';
import '../../../models/user_model.dart';
import '../providers/user_provider.dart';
import '../repository/auth_repository.dart';
import 'package:provider/provider.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _authRepository;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  Future<void> signInWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    final user = await _authRepository.signInWithEmailAndPassword(
        email: email, password: password);
    _setLoading(false);
    user.fold(
      (failure) => showSnackBar(context: context, text: failure.message),
      (userModel) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.updateUser(userModel);
      },
    );
  }

  Future<void> signUpWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
    required String userName,
  }) async {
    _setLoading(true);
    final user = await _authRepository.signUpWithEmailAndPassword(
      email: email,
      password: password,
      userName: userName,
    );
    _setLoading(false);
    user.fold(
      (failure) => showSnackBar(context: context, text: failure.message),
      (userModel) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.updateUser(userModel);
      },
    );
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid: uid);
  }

  void logout(BuildContext context) {
    _authRepository.logOut();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.clearUser();
  }

  void _setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}
