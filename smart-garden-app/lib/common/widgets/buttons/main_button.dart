import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_delivery_app/utils/constants/colors.dart';
import 'package:food_delivery_app/utils/constants/sizes.dart';
import 'package:food_delivery_app/utils/device/device_utility.dart';

class MainButton extends StatelessWidget {
  final double? width;
  final double? height;
  final String text;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final bool isElevatedButton;
  final String? prefixIconStr;
  final String? suffixIconStr;
  final double? paddingHorizontal;
  final double? paddingVertical;
  final double? borderWidth;
  final TextStyle? textStyle;
  final double? borderRadius;

  VoidCallback? onPressed;
  Color? textColor;
  Color? borderColor;
  Color? backgroundColor;
  Color? suffixIconColor;
  Color? prefixIconColor;
  final bool placeholder;

  MainButton({
    this.width,
    this.height,
    required this.onPressed,
    required this.text,
    this.textColor,
    this.suffixIcon,
    this.suffixIconColor,
    this.prefixIcon,
    this.prefixIconColor,
    this.prefixIconStr,
    this.suffixIconStr,
    this.isElevatedButton = true,
    this.paddingHorizontal,
    this.paddingVertical,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.placeholder = false,
    this.textStyle = const TextStyle(),
    super.key
  });

  @override
  Widget build(BuildContext context) {
    if(placeholder) {
      textColor = Colors.transparent;
      borderColor = Colors.transparent;
      backgroundColor = Colors.white;
      suffixIconColor = Colors.transparent;
      prefixIconColor = Colors.transparent;
      // onPressed = null;
    }
    return isElevatedButton
        ? ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? TSize.borderRadiusMd),
        ),
        side: BorderSide(
          width: borderWidth ?? 1,
          color: borderColor ?? TColor.primary
        ),
        // padding: EdgeInsets.symmetric(
        //     // vertical: paddingVertical ?? 0,
        //     // horizontal: paddingHorizontal ?? 0
        // ),
        backgroundColor: backgroundColor,
      ),
      child: Container(
          height: height,
          padding: EdgeInsets.symmetric(
              vertical: paddingVertical ?? 0,
              horizontal: paddingHorizontal ?? 0
          ),
          // width: width,
          // width: width ?? TDeviceUtil.getScreenWidth() * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 35),
          ),
          child: _buildButtonContent()
      ),
    )
        : TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 35),
        ),
        side: BorderSide(
            width: borderWidth ?? 1,
            color: borderColor ?? TColor.primary
        ),
      ),
      child: Container(
        height: height,
          padding: EdgeInsets.symmetric(
              vertical: paddingVertical ?? 0,
              horizontal: paddingHorizontal ?? 0
          ),
          // width: width,
          // width: width ?? TDeviceUtil.getScreenWidth() * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 35),
          ),
          child: _buildButtonContent()),
    );
  }

  Center _buildButtonContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixIcon != null || prefixIconStr != null) ...[
                (prefixIcon != null)
                  ? Icon(prefixIcon, color: prefixIconColor)
                  : SvgPicture.asset(
                    prefixIconStr!
                  ),
                SizedBox(width: TSize.spaceBetweenItemsHorizontal),
              ],
              Text(
                text,
                style: textStyle?.copyWith(color: textColor)
              ),
              if (suffixIcon != null || suffixIconStr != null) ...[
                SizedBox(width: TSize.spaceBetweenItemsHorizontal),
                (suffixIcon != null)
                    ? Icon(suffixIcon, color: suffixIconColor)
                    : SvgPicture.asset(
                    suffixIconStr!
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
