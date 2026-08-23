import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_expense_tracker/core/utils/app_colors.dart';

import '../../../core/utils/image_paths.dart';
import '../controller/profile_controller.dart';
import 'logout_bottomsheet.dart';


class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  void _showLogoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LogoutBottomSheetContent(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: SafeArea(
        child: state.isLoading
            ? const Center(
          child: CircularProgressIndicator(color: AppColor.primary),
        )
            : Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  20.verticalSpace,
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Icon(Icons.arrow_back,
                        color: AppColor.white, size: 24.sp),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'PROFILE',
                        style: GoogleFonts.inter(
                          color: AppColor.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  24.horizontalSpace,
                ],
              ),
              30.verticalSpace,
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 32.r,
                      backgroundImage:
                      const AssetImage(ImagePath.profile),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        height: 12.h,
                        width: 12.w,
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
              if (state.dateTime != null)
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
                      "${state.dateTime!.day.toString().padLeft(2, '0')}/${state.dateTime!.month.toString().padLeft(2, '0')}/${state.dateTime!.year}",
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
                onTap: () => _showLogoutBottomSheet(context),
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