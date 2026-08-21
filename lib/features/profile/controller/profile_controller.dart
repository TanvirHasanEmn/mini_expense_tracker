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

  ProfileController(this._authRepository) : super(ProfileState());

  // Future<void> logout() async {
  //   state = state.copyWith(isLoggingOut: true);
  //   try {
  //     await _authRepository.signOut();
  //   } finally {
  //     state = state.copyWith(isLoggingOut: false);
  //   }
  // }
}