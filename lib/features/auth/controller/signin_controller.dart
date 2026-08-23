import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/validators.dart';
import '../domain/auth_repo.dart';
import 'signin_state.dart';

final signinControllerProvider =
StateNotifierProvider.autoDispose<SigninController, SigninState>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return SigninController(authRepo);
});

class SigninController extends StateNotifier<SigninState> {
  final AuthRepository _authRepository;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SigninController(this._authRepository) : super(const SigninState());

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordHidden: !state.isPasswordHidden);
  }

  void toggleRememberMe(bool? value) {
    state = state.copyWith(rememberMe: value ?? false);
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    final emailError = AppValidators.validateEmail(email);
    final passwordError = AppValidators.validateStrongPassword(password);

    if (emailError != null || passwordError != null) {
      state = state.copyWith(
        emailError: emailError,
        passwordError: passwordError,
        generalError: null,
      );
      return;
    }

    state = state.copyWith(
      isLoading: true,
      clearErrors: true,
      isSuccess: false,
    );

    try {
      await _authRepository.signInWithEmailPassword(
        email: email,
        password: password,
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        generalError: 'Invalid email or password.',
        isSuccess: false,
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}