import "package:flutter/material.dart";
import "package:smart_garden_app/common/widgets/bars/menu_bar.dart";
import "package:smart_garden_app/features/garden/views/dashboard.dart";
import "package:smart_garden_app/features/garden/views/garden.dart";
import "package:smart_garden_app/features/setting/views/setting.dart";

class GardenMenuRedirection extends StatelessWidget {
  const GardenMenuRedirection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> viewList = [
      const DashboardView(),
      const MyGardenView(),
      const AccountSettingsScreen(),
    ];
    return CMenuBar(
      iconList: const [
        {
          "icon": Icons.dashboard,
          "label": "Dashboard",
        },
        {
          "icon": Icons.water_drop_outlined,
          "label": "Garden",

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
