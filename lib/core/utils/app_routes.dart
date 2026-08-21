import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_expense_tracker/features/profile/presentation/profile.dart';
import '../../../features/auth/presentation/signin.dart';
import '../../../features/auth/presentation/signup.dart';
import '../../features/expense/presentation/add_expense.dart';
import '../../features/expense/presentation/edit_expenses.dart';
import '../../features/home/presentation/homepage.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String add_expense = '/add_expense';
  static const String profile = '/profile';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.signin,
    routes: [
      // GoRoute(
      //   path: AppRoutes.splash,
      //   name: 'splash',
      //   builder: (context, state) => const SplashScreen(),
      // ),
      GoRoute(
        path: AppRoutes.signin,
        name: 'signin',
        builder: (context, state) => const SigninPage(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        builder: (context, state) => const SignupPage(),
      ),

      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomePage()
      ),

      GoRoute(
          path: AppRoutes.add_expense,
          name: 'add_expense',
          builder: (context, state) => const EditExpensePage(expenseData: {},)
      ),

      GoRoute(
          path: AppRoutes.profile,
          name: 'profile',
          builder: (context, state) => const ProfilePage()
      ),
    ],
  );
});