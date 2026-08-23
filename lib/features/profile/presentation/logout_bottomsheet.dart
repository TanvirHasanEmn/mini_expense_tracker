import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_routes.dart';
import '../controller/profile_controller.dart';

class LogoutBottomSheetContent extends ConsumerWidget {
  const LogoutBottomSheetContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(profileControllerProvider.notifier);
    final isLoggingOut = ref.watch(profileControllerProvider).isLoggingOut;

    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          20.verticalSpace,
          Text(
            'Logout',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          20.verticalSpace,
          Container(
            height: 1.h,
            color: Colors.grey.withValues(alpha: 0.5),
          ),
          30.verticalSpace,
          Text(
            'Are you sure you want to log out?',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.center,
          ),
          30.verticalSpace,
          ElevatedButton(
            onPressed: isLoggingOut
                ? null
                : () async {
              await controller.logout();
              if (context.mounted) {
                context.pop();
                context.go(AppRoutes.signin);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
              minimumSize: Size(double.infinity, 50.h),
            ),
            child: isLoggingOut
                ? SizedBox(
              height: 20.h,
              width: 20.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.black,
              ),
            )
                : Text(
              'Yes, Logout',
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          15.verticalSpace,
          ElevatedButton(
            onPressed: isLoggingOut ? null : () => context.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF333333),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
              minimumSize: Size(double.infinity, 50.h),
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}