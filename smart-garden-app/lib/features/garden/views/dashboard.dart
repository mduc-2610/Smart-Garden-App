import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_delivery_app/common/widgets/misc/main_wrapper.dart';
import 'package:food_delivery_app/features/garden/controllers/dashboard_controller.dart';
import 'package:food_delivery_app/utils/constants/colors.dart';
import 'package:food_delivery_app/utils/constants/sizes.dart';
import 'package:get/get.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: Get.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w700
          ),
        ),
      ),
      body: MainWrapper(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: TSize.spaceBetweenSections,
                horizontal: TSize.defaultSpace,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  "https://cdn.dribbble.com/users/215472/screenshots/3680687/environment.jpg",
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Row(
              children: [
                InfoCard(
                  title: "Humidity",
                  value: "74%",
                  icon: Icons.water_drop,
                  color: Colors.blue,
                ),
                InfoCard(
                  title: "Temperature",
                  value: "23°C",
                  icon: Icons.thermostat,
                  color: Colors.red,
                ),
                InfoCard(
                  title: "Water Level",
                  value: "85%",
                  icon: Icons.opacity,
                  color: Colors.blue[800],
                ),
              ],
            ),
            Row(
              children: [
                InfoCard(
                  flex: 1,
                  title: "Connectivity",
                  value: "Online",
                  icon: Icons.wifi,
                  color: Colors.green,
                ),
                InfoCard(
                  flex: 2,
                  title: "Plant Status",
                  value: "2 plants growing",
                  icon: Icons.eco,
                  color: Colors.green[800],
                ),
              ],
            ),
            Row(
              children: [
                Obx(() => InfoCard(
                  title: "Light",
                  value: controller.isLightOn.value ? "On" : "Off",
                  icon: Icons.lightbulb,
                  color: Colors.amber,
                  showSwitch: true,
                  switchValue: controller.isLightOn.value,
                  onSwitchChanged: controller.toggleLight,
                )),
                Obx(() => InfoCard(
                  title: "Pump",
                  value: controller.isPumpOn.value ? "On" : "Off",
                  icon: Icons.water,
                  color: Colors.blue,
                  showSwitch: true,
                  switchValue: controller.isPumpOn.value,
                  onSwitchChanged: controller.togglePump,
                )),
              ],
            ),
            Row(
              children: [
                Obx(() => InfoCard(
                  title: "Roof",
                  value: controller.isRoofOpen.value ? "Open" : "Closed",
                  icon: Icons.roofing,
                  color: Colors.orange,
                  showSwitch: true,
                  switchValue: controller.isRoofOpen.value,
                  onSwitchChanged: controller.toggleRoof,
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  final int flex;
  final bool showSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.flex = 1,
    this.showSwitch = false,
    this.switchValue = false,
    this.onSwitchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: SizedBox(
        child: Card(
          elevation: TSize.cardElevationLg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        icon,
                        size: TSize.iconLg,
                        color: color ?? TColor.primary,
                      ),
                      SizedBox(height: TSize.spaceBetweenItemsSm),
                      Text(
                        title,
                        style: Get.textTheme.bodySmall?.copyWith(fontSize: 13),
                      ),
                      SizedBox(height: TSize.spaceBetweenItemsSm),
                      if (!showSwitch) ...[
                        Text(
                          value,
                          style: Get.textTheme.titleLarge,
                        ),
                      ]
                    ],
                  ),
                ),
                if (showSwitch)
                  Switch(
                    value: switchValue,
                    onChanged: onSwitchChanged,
                    activeColor: TColor.light,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
