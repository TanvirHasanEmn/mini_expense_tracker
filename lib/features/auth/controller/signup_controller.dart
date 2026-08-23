import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/validators.dart';
import '../domain/auth_repo.dart';
import 'signup_state.dart';

final signupControllerProvider =
StateNotifierProvider.autoDispose<SignupController, SignupState>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return SignupController(authRepo);
});

class SignupController extends StateNotifier<SignupState> {
  final AuthRepository _authRepository;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignupController(this._authRepository) : super(const SignupState());

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordHidden: !state.isPasswordHidden);
  }

  void toggleRememberMe(bool? value) {
    state = state.copyWith(rememberMe: value ?? false);
  }

  Future<void> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    final nameError = AppValidators.validateName(name);
    final emailError = AppValidators.validateEmail(email);
    final passwordError = AppValidators.validateStrongPassword(password);

    if (nameError != null || emailError != null || passwordError != null) {
      state = state.copyWith(
        nameError: nameError,
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
      await _authRepository.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        generalError: 'Registration failed. This email may already be in use.',
        isSuccess: false,
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}