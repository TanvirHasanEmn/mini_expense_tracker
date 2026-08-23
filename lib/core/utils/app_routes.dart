import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_expense_tracker/features/profile/presentation/profile.dart';
import '../../../features/auth/presentation/signin.dart';
import '../../../features/auth/presentation/signup.dart';
import '../../features/expense/presentation/add_expense.dart';
import '../../features/expense/presentation/edit_expenses.dart';
import '../../features/expense/presentation/expense_list.dart';
import '../../features/home/presentation/homepage.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String add_expense = '/add_expense';
  static const String edit_expense = '/edit_expense';
  static const String expense_list = '/expense_list';
  static const String profile = '/profile';
}

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      if (authState.isLoading || authState.hasError) return null;

      final bool isLoggedIn = authState.value != null;
      final String currentPath = state.uri.path;
      final bool isAuthRoute = currentPath == AppRoutes.signin || currentPath == AppRoutes.signup;

      if (!isLoggedIn && !isAuthRoute) {
        return AppRoutes.signin;
      }

      if (isLoggedIn && isAuthRoute) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
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
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.add_expense,
        name: 'add_expense',
        builder: (context, state) => const AddExpensePage(),
      ),
      GoRoute(
        path: AppRoutes.edit_expense,
        name: 'edit_expense',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};
          return EditExpensePage(expenseData: data);
        },
      ),
      GoRoute(
        path: AppRoutes.expense_list,
        name: 'expense_list',
        builder: (context, state) => const ExpenseListPage(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
});