import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthController {
  final AuthRepository _authRepository = AuthRepository();

  Future<UserModel?> signInWithGoogle(BuildContext context) async {
    try {
      final user = await _authRepository.signInWithGoogle();
      if (user != null && user.email!.endsWith('@ufba.br')) {
        return UserModel(
          uid: user.uid,
          displayName: user.displayName,
          email: user.email,
          photoURL: user.photoURL,
        );
      } else {
        await _authRepository.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Apenas e-mails da UFBA são permitidos.')),
        );
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer login: $e')),
      );
      return null;
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  UserModel? getCurrentUser() {
    final user = _authRepository.getCurrentUser();
    return user != null
        ? UserModel(
            uid: user.uid,
            displayName: user.displayName,
            email: user.email,
            photoURL: user.photoURL,
          )
        : null;
  }
}