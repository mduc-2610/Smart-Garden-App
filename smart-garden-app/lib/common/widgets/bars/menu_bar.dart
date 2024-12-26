import 'package:flutter/material.dart';
import 'package:smart_garden_app/common/controllers/bars/menu_bar_controller.dart';
import 'package:get/get.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';
import 'package:smart_garden_app/utils/constants/sizes.dart';

enum Menu { user, deliverer, restaurant }

class CMenuBar extends StatelessWidget {
  final List<Map<String, dynamic>> iconList;
  final List<Widget> viewList;
  final double? iconSize;
  final String tag;

  const CMenuBar({super.key, 
    required this.iconList,
    required this.viewList,
    this.iconSize,
    this.tag = "user",
  });

  @override
  Widget build(BuildContext context) {
    // final MenuBarController controller = MenuBarController.instance;
    final MenuBarController controller = Get.put(MenuBarController(ls: viewList), tag: tag);

    return Scaffold(
      body: Obx(() => controller.getView(controller.currentIndex.value)),
      bottomNavigationBar: SizedBox(
        height: 75,
        child: Obx(() => BottomNavigationBar(
          iconSize: iconSize ?? TSize.iconXl,
          items: List.generate(iconList.length, (index) {
            return BottomNavigationBarItem(
              icon: _buildIcon(index, controller.currentIndex.value),
              label: iconList[index]["label"],
            );
          }),
          currentIndex: controller.currentIndex.value,
          selectedItemColor: TColor.primary,
          unselectedItemColor: TColor.disable,
          onTap: controller.updateIndex,
          type: BottomNavigationBarType.fixed,
        )),
      ),
    );
  }

  Widget _buildIcon(int index, int currentIndex) {
    final isSelected = index == currentIndex;
    final icon = iconList[index]["icon"];
    final customIcon = iconList[index]["custom"];
    final color = _getColorForIndex(index, isSelected);

    if (customIcon != null) {
      return customIcon;
    } else {
      return Icon(icon, color: color);
    }
  }

  Color _getColorForIndex(int index, bool isSelected) {
    if (!isSelected) {
      return iconList[index]["unselectedColor"] ?? TColor.disable;
    }
    return iconList[index]["selectedColor"] ?? TColor.primary;
  }
}