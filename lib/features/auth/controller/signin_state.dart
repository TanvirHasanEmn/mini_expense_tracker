class SigninState {
  final bool isLoading;
  final bool isPasswordHidden;
  final bool rememberMe;
  final String? emailError;
  final String? passwordError;
  final String? generalError;
  final bool isSuccess;

  const SigninState({
    this.isLoading = false,
    this.isPasswordHidden = true,
    this.rememberMe = false,
    this.emailError,
    this.passwordError,
    this.generalError,
    this.isSuccess = false,
  });

  SigninState copyWith({
    bool? isLoading,
    bool? isPasswordHidden,
    bool? rememberMe,
    String? emailError,
    String? passwordError,
    String? generalError,
    bool? isSuccess,
    bool clearErrors = false,
  }) {
    return SigninState(
      isLoading: isLoading ?? this.isLoading,
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      rememberMe: rememberMe ?? this.rememberMe,
      emailError: clearErrors ? null : (emailError ?? this.emailError),
      passwordError: clearErrors ? null : (passwordError ?? this.passwordError),
      generalError: clearErrors ? null : (generalError ?? this.generalError),
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}