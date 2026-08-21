import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/home_state.dart';

final homeControllerProvider =
StateNotifierProvider.autoDispose<HomeController, HomeState>((ref) {
  return HomeController();
});

class HomeController extends StateNotifier<HomeState> {
  HomeController() : super(const HomeState());

  void selectLevel(String level) {
    state = state.copyWith(selectedLevel: level);
  }
}