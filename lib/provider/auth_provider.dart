import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Controller/auth_controller.dart';

class AuthProvider extends ChangeNotifier {
  final AuthController _controller = AuthController();

  User? _user;
  bool _isLoading = false;
  String _errorMessage = '';

  User? get user => _user;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _initAuthListener();
  }

  void _initAuthListener() {
    _user = _controller.getCurrentUser();
    _controller.authStateChanges.listen((User? newUser) {
      _user = newUser;
      notifyListeners();
    });
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      final credential = await _controller.login(email, password);
      _user = credential.user;
      _errorMessage = '';
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    _setLoading(true);
    try {
      final credential = await _controller.register(email, password);
      _user = credential.user;
      _errorMessage = '';
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    await _controller.logout();
    _user = null;
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
