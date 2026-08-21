class HomeState {
  final String selectedLevel;
  final List<String> levels;
  final List<Map<String, String>> featuredWorkouts;
  final String userName;

  const HomeState({
    this.selectedLevel = 'Beginner',
    this.levels = const ['Beginner', 'Intermediate', 'Advanced'],
    this.featuredWorkouts = const [
      {
        'image': 'assets/images/classes_card.png',
        'title': 'Morning Yoga Flow',
        'duration': '20 mins',
        'level': 'Beginner',
      },
      {
        'image': 'assets/images/classes_card.png',
        'title': 'Full Body HIIT',
        'duration': '35 mins',
        'level': 'Intermediate',
      },
    ],
    this.userName = 'Tanvir',
  });

  HomeState copyWith({
    String? selectedLevel,
    List<String>? levels,
    List<Map<String, String>>? featuredWorkouts,
    String? userName,
  }) {
    return HomeState(
      selectedLevel: selectedLevel ?? this.selectedLevel,
      levels: levels ?? this.levels,
      featuredWorkouts: featuredWorkouts ?? this.featuredWorkouts,
      userName: userName ?? this.userName,
    );
  }
}