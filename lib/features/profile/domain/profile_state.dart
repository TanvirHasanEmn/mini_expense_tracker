class ProfileState {
  final String name;
  final String email;
  final DateTime dateTime;
  final bool isLoggingOut;

  ProfileState({
    this.name = 'Tanvir',
    this.email = 'tanvirhasanemn@gmail.com',
    DateTime? dateTime,
    this.isLoggingOut = false,
  }) : dateTime = dateTime ?? DateTime(2026, 6, 2);

  ProfileState copyWith({
    String? name,
    String? email,
    DateTime? dateTime,
    bool? isLoggingOut,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      dateTime: dateTime ?? this.dateTime,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
    );
  }
}