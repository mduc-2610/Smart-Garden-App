import 'package:flutter/material.dart';
import 'package:smart_garden_app/common/widgets/cards/circle_icon_card.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';
import 'package:smart_garden_app/utils/constants/sizes.dart';
import 'package:get/get.dart';

class CAppBar extends StatelessWidget implements PreferredSizeWidget {
  final dynamic title;
  final VoidCallback? backButtonOnPressed;
  final dynamic result;
  final List<Map<String, dynamic>> iconList;
  final bool isBigTitle;
  final bool centerTitle;
  final bool noLeading;
  final PreferredSizeWidget? bottom;
  final TextStyle? textStyle;
  final List<Widget>? actions;


  const CAppBar({
    this.title,
    this.iconList = const [],
    this.actions,
    this.backButtonOnPressed,
    this.result,
    this.isBigTitle = false,
    this.centerTitle = true,
    this.noLeading = false,
    this.bottom,
    this.textStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title is Widget
          ? title
          : Text(
        title.toString(),
        style: textStyle ?? (isBigTitle
            ? Theme.of(context)
            .textTheme
            .headlineLarge
            ?.copyWith(color: TColor.primary)
            : Theme.of(context).textTheme.headlineMedium),
      ),
      centerTitle: centerTitle,
      leading: noLeading
          ? SizedBox.shrink()
          : IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          backButtonOnPressed?.call();
          Get.back(result: result);
          // Navigator.pop(context);
        },
      ),
      actions: actions ?? iconList.map((iconData) {
        return CircleIconCard(
          elevation: TSize.iconCardElevation,
          icon: iconData['icon'],
          onTap: iconData['onPressed'],
        );
      }).toList(),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
      TSize.appBarHeight + (bottom?.preferredSize.height ?? 0.0));
}
