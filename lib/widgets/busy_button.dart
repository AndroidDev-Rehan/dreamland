import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Constants/colors.dart';

class BusyButton extends StatelessWidget {
  const BusyButton({
    super.key,
    required this.busy,
    required this.title,
    this.onPressed,
    this.fgColor = Colors.white,
    this.borderRadius = 10,
    this.bgColor = AppColors.kcPrimaryColor,
    this.fontSize = 18,
    this.textStyle,
    this.height = 48,
    this.width = double.infinity,
    this.busyColor = Colors.white,
    this.circleProgressHeight,
    this.circleProgressWidth,
    this.onLongPress,

  });

  final bool busy;
  final String title;
  final Color fgColor;
  final Color bgColor;
  final Color busyColor;
  final double fontSize;
  final TextStyle? textStyle;
  final double borderRadius;
  final double height;
  final double width;
  final void Function()? onPressed;
  final double? circleProgressHeight;
  final double? circleProgressWidth;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        backgroundColor: bgColor,
        minimumSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onLongPress: onLongPress,
      onPressed: onPressed?.call,
      child: busy
          ? SizedBox(
              height: circleProgressHeight,
              width: circleProgressWidth,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(busyColor),
              ),
            )
          : Text(
              title,
              style:
              textStyle ??
              TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize.sp,
                color: fgColor,
              ),
            ),
    );
  }
}
