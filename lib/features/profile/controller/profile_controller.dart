import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/domain/auth_repo.dart';
import '../domain/profile_state.dart';

final profileControllerProvider =
StateNotifierProvider.autoDispose<ProfileController, ProfileState>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return ProfileController(authRepo);
});

class ProfileController extends StateNotifier<ProfileState> {
  final AuthRepository _authRepository;

  ProfileController(this._authRepository) : super(ProfileState()) {
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final currentUser = _authRepository.currentUser;
    if (currentUser == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    try {
      final userProfile = await _authRepository.getUserProfile(currentUser.uid);
      if (userProfile != null) {
        state = state.copyWith(
          name: userProfile.name,
          email: userProfile.email,
          dateTime: userProfile.createdAt,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoggingOut: true);
    try {
      await _authRepository.logout();
    } finally {
      state = state.copyWith(isLoggingOut: false);
    }
  }
}