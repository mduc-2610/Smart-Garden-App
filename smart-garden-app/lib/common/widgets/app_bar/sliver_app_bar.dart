import 'package:flutter/material.dart';
import 'package:smart_garden_app/common/widgets/cards/circle_icon_card.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';
import 'package:smart_garden_app/utils/constants/sizes.dart';
import 'package:smart_garden_app/utils/device/device_utility.dart';
import 'package:get/get.dart';

class CSliverAppBar extends StatelessWidget {
  final dynamic title;
  final VoidCallback? backButtonOnPressed;
  final List<Map<String, dynamic>> iconList;
  final bool isBigTitle;
  final bool centerTitle;
  final bool noLeading;
  final bool isExpandedHeight;
  final PreferredSizeWidget? bottom;
  final Widget? flexibleSpace;
  final double? expandedHeight;
  final dynamic result;
  final Color? titleColor;

  const CSliverAppBar({
    required this.title,
    this.iconList = const [],
    this.backButtonOnPressed,
    this.result,
    this.isBigTitle = false,
    this.centerTitle = true,
    this.noLeading = false,
    this.isExpandedHeight = false,
    this.bottom,
    this.flexibleSpace,
    this.expandedHeight,
    this.titleColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: TSize.spaceBetweenItemsVertical),
      sliver: SliverAppBar(
        pinned: true,
        title: title is Widget
            ? title
            : Text(
          title.toString(),
          style: isBigTitle
              ? Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(color: TColor.primary)
              : Theme.of(context).textTheme.headlineMedium,
        ),
        expandedHeight: expandedHeight ?? ((isExpandedHeight) ? TDeviceUtil.getAppBarHeight(): 0),
        centerTitle: centerTitle,
        flexibleSpace: (flexibleSpace) ?? Stack(
          children: [
            Positioned(
              top: TDeviceUtil.getAppBarHeight() / 3,
              right: 16,
              child: Row(
                children: List.generate(
                  iconList.length,
                      (index) => CircleIconCard(
                        elevation: TSize.iconCardElevation,
                        icon: iconList[index]["icon"],
                        onTap: iconList[index]["onPressed"],
                      )
                ),
              ),
            ),
          ],
        ),
        leading: (noLeading == false ) ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  backButtonOnPressed?.call();
                  Get.back(result: result);
                  // Navigator.pop(context);
                },
            ),
          ),
        ) : null,
        bottom: bottom,
      ),
    );
  }
}

