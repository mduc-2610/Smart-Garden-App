import 'package:flutter/material.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';
import 'package:smart_garden_app/utils/constants/sizes.dart';
import 'package:get/get.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  final int flex;
  final bool showSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final bool disabled; // New disabled parameter

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
    this.disabled = false, // Initialize disabled as false by default
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
          color: disabled ? TColor.disabled : null,
          child: Opacity(
            opacity: disabled ? 0.5 : 1.0,
            child: AbsorbPointer(
              absorbing: disabled,
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
                          const SizedBox(height: TSize.spaceBetweenItemsSm),
                          Text(
                            title,
                            style: Get.textTheme.bodySmall?.copyWith(fontSize: 13),
                          ),
                          const SizedBox(height: TSize.spaceBetweenItemsSm),
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
                      Row(
                        children: [
                          Switch(
                            value: switchValue,
                            onChanged: disabled ? null : onSwitchChanged, // Disable switch interaction
                            activeColor: TColor.light,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
