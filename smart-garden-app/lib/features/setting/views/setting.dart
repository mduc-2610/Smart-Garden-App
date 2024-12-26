import 'package:flutter/material.dart';
import 'package:smart_garden_app/common/widgets/misc/main_wrapper.dart';
import 'package:smart_garden_app/features/setting/controllers/setting_controller.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';
import 'package:smart_garden_app/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:smart_garden_app/utils/device/device_utility.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.put(SettingsController());

    return Obx(() => Scaffold(
      appBar: AppBar(
        title: Text(
          'Personal Setting',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: TDeviceUtil.getScreenHeight(),
          child: MainWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: TSize.spaceBetweenSections),

                Text(
                  'Password & Backup',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: TSize.spaceBetweenItemsVertical),
                _buildOptionTile(
                  context: context,
                  title: 'Change Password',
                  onTap: () {
                    // Handle Change Password tap
                  },
                ),
                const SizedBox(height: TSize.spaceBetweenItemsVertical),
                _buildOptionTile(
                  context: context,
                  title: 'Set Backup Email',
                  onTap: () {
                    // Handle Set Backup Email tap
                  },
                ),
                const SizedBox(height: TSize.spaceBetweenItemsVertical),
                _buildOptionTile(
                  context: context,
                  title: 'Change Personal Information',
                  onTap: () {
                    // Handle Change Personal Information tap
                  },
                ),
                const SizedBox(height: TSize.spaceBetweenSections),

                // Settings Section
                Text(
                  'Setting',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                _buildConnectedTile(
                  context: context,
                  icon: Icons.lightbulb,
                  title: 'Dark Mode',
                  isConnected: controller.isDarkMode.value,
                  onToggle: controller.toggleDarkMode,
                ),
                _buildConnectedTile(
                  context: context,
                  icon: controller.isSoundEnabled.value ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                  title: 'Sound',
                  isConnected: controller.isSoundEnabled.value,
                  onToggle: controller.toggleSound,
                ),

                const SizedBox(height: TSize.spaceBetweenSections),

                Text(
                  'Device Settings',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: TSize.spaceBetweenItemsVertical),
                Card(
                  elevation: TSize.cardElevationMd,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ESP32 IP Address',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.esp32IpAddress.value,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => controller.showIpEditDialog(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required String title,
    required VoidCallback onTap
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: TSize.cardElevationMd,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: TSize.iconMd,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectedTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool isConnected,
    required ValueChanged<bool> onToggle,
  }) {
    return Card(
      elevation: TSize.cardElevationMd,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: TColor.primary,
              size: TSize.iconLg,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Switch(
              value: isConnected,
              onChanged: onToggle,
              activeColor: TColor.light
            ),
          ],
        ),
      ),
    );
  }
}
