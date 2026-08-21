import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_expense_tracker/core/utils/app_colors.dart';

import '../../../core/utils/app_routes.dart';
import '../../../core/utils/image_paths.dart';
import '../controller/profile_controller.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileControllerProvider);
    final controller = ref.read(profileControllerProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  20.verticalSpace,
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Icon(Icons.arrow_back, color: AppColor.white, size: 24.sp),
                  ),
                  110.horizontalSpace,
                  Text(
                    'PROFILE',
                    style: GoogleFonts.inter(
                      color: AppColor.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              30.verticalSpace,

              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 32.r,
                      backgroundImage: AssetImage(ImagePath.profile),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.primary,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              15.verticalSpace,

              Text(
                state.name,
                style: GoogleFonts.inter(
                  color: AppColor.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              8.verticalSpace,
                  Text(
                    state.email,
                    style: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: 16.sp,
                    ),
                  ),
              16.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Date of creation: ",
                    style: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    "${state.dateTime.day.toString().padLeft(2, '0')}/${state.dateTime.month.toString().padLeft(2, '0')}/${state.dateTime.year}",
                    style: GoogleFonts.inter(
                      color: AppColor.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              64.verticalSpace,

              _buildOption(
                imagePath: ImagePath.logout_icon,
                text: 'Logout',
                onTap: () async {
                  // await controller.logout();
                  if (context.mounted) {
                    context.go(AppRoutes.signin);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption({
    required String imagePath,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Image.asset(
        imagePath,
        width: 32.w,
        height: 32.h,
        fit: BoxFit.contain,
      ),
      title: Text(
        text,
        style: GoogleFonts.inter(
          color: AppColor.white,
          fontSize: 24.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}