class ProfileState {
  final String name;
  final String email;
  final DateTime? dateTime;
  final bool isLoggingOut;
  final bool isLoading;

  ProfileState({
    this.name = '',
    this.email = '',
    this.dateTime,
    this.isLoggingOut = false,
    this.isLoading = true, // Start as true while fetching from Firebase
  });

  ProfileState copyWith({
    String? name,
    String? email,
    DateTime? dateTime,
    bool? isLoggingOut,
    bool? isLoading,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      dateTime: dateTime ?? this.dateTime,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}