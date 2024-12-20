import "package:flutter/material.dart";
import "package:smart_garden_app/common/widgets/bars/menu_bar.dart";
import "package:smart_garden_app/features/garden/views/dashboard.dart";
import "package:smart_garden_app/features/garden/views/garden.dart";
import "package:smart_garden_app/features/setting/views/setting.dart";
import "package:get/get.dart";

class GardenMenuRedirection extends StatelessWidget {
  const GardenMenuRedirection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> viewList = [
      MyGardenView(),
      DashboardView(),
      AccountSettingsScreen(),
    ];
    return CMenuBar(
      iconList: [
        {
          "icon": Icons.water_drop_outlined,
          "label": "Garden",

        },
        {
          "icon": Icons.dashboard,
          "label": "Dashboard",
        },
        {
          "icon": Icons.person,
          "label": "Setting",

        },
      ],
      viewList: viewList,
      tag: "user",
    );
  }
}
