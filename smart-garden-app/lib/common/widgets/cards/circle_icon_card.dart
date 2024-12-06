import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_delivery_app/utils/constants/colors.dart';
import 'package:food_delivery_app/utils/constants/icon_strings.dart';
import 'package:food_delivery_app/utils/constants/sizes.dart';

class CircleIconCard extends StatelessWidget {
  final VoidCallback? onTap;
  final double elevation;
  final Color? backgroundColor;
  final String? iconStr;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final double? padding;
  final Color? borderSideColor;
  final double borderSideWidth;
  final Color? shadowColor;
  final Color? surfaceTintColor;

  const CircleIconCard({
    this.onTap,
    this.elevation = TSize.cardElevationSm,
    this.backgroundColor,
    this.iconStr,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.padding,
    this.borderSideColor,
    this.borderSideWidth = 0,
    this.shadowColor,
    this.surfaceTintColor,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TSize.borderRadiusCircle),
          side: (borderSideWidth != 0 ) ? BorderSide(
            color: borderSideColor ?? Theme.of(context).appBarTheme.backgroundColor!,
            width: borderSideWidth,
          ) : BorderSide.none,
        ),
        shadowColor: shadowColor ?? Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: surfaceTintColor ?? Theme.of(context).appBarTheme.backgroundColor,
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: (iconStr != null)
              ? SvgPicture.asset(
                iconStr!,
                width: iconSize ?? TSize.iconSm + 5,
                height: iconSize ?? TSize.iconSm + 5,
              )
              : Icon(
                icon,
                color: iconColor ?? TColor.iconColor,
                size: iconSize ?? TSize.iconSm + 5,
              ),
        )
      ),
    );
  }
}
