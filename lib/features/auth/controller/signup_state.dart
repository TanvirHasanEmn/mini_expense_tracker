class SignupState {
  final bool isLoading;
  final bool isPasswordHidden;
  final bool rememberMe;
  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final String? generalError;
  final bool isSuccess;

  const SignupState({
    this.isLoading = false,
    this.isPasswordHidden = true,
    this.rememberMe = false,
    this.nameError,
    this.emailError,
    this.passwordError,
    this.generalError,
    this.isSuccess = false,
  });

  SignupState copyWith({
    bool? isLoading,
    bool? isPasswordHidden,
    bool? rememberMe,
    String? nameError,
    String? emailError,
    String? passwordError,
    String? generalError,
    bool? isSuccess,
    bool clearErrors = false,
  }) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      rememberMe: rememberMe ?? this.rememberMe,
      nameError: clearErrors ? null : (nameError ?? this.nameError),
      emailError: clearErrors ? null : (emailError ?? this.emailError),
      passwordError: clearErrors ? null : (passwordError ?? this.passwordError),
      generalError: clearErrors ? null : (generalError ?? this.generalError),
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}