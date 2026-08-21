import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/custom_widgets/custom_button.dart';
import '../../../core/custom_widgets/custom_text_field.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_routes.dart';
import '../controller/signin_controller.dart';
import 'package:go_router/go_router.dart';

class SigninPage extends ConsumerWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signinControllerProvider);
    final controller = ref.read(signinControllerProvider.notifier);


    ref.listen(signinControllerProvider, (previous, next) {
      if (next.isSuccess && !(previous?.isSuccess ?? false)) {
        context.go(AppRoutes.home);
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                50.verticalSpace,
                Text(
                  "WELCOME TO\nMINI EXPENSE TRACKER",
                  style: GoogleFonts.inter(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary.withAlpha(120),
                  ),
                  textAlign: TextAlign.center,
                ),

                30.verticalSpace,

                Text(
                  "LOGIN TO YOUR ACCOUNT",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.lightGray,
                  ),
                ),
                80.verticalSpace,


                CustomTextField(
                  controller: controller.emailController,
                  hintText: "Email",
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  errorText: state.emailError,
                ),
                16.verticalSpace,

                CustomTextField(
                  controller: controller.passwordController,
                  hintText: "Password",
                  prefixIcon: Icons.lock,
                  obscureText: state.isPasswordHidden,
                  errorText: state.passwordError,
                  suffixIcon: GestureDetector(
                    onTap: controller.togglePasswordVisibility,
                    child: Icon(
                      state.isPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),

                30.verticalSpace,
                CustomButton(

                  text: state.isLoading ? "Signing in..." : "Sign in",
                  onPressed: state.isLoading ? null : controller.login,
                ),


                50.verticalSpace,


                Center(
                  child: InkWell(
                    onTap: () => context.push(AppRoutes.signup),
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF636F85),
                        ),
                        children: [
                          TextSpan(
                            text: "Sign up",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                20.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}