import 'package:smart_garden_app/features/garden/controllers/light_dialog_controller.dart';
import 'package:smart_garden_app/features/garden/views/widgets/custom_time_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:smart_garden_app/common/widgets/buttons/small_button.dart';
import 'package:smart_garden_app/utils/constants/sizes.dart';

class LightDialog extends StatefulWidget {
  const LightDialog({super.key});

  @override
  _LightDialogState createState() => _LightDialogState();
}

class _LightDialogState extends State<LightDialog> {
  final ValueNotifier<bool> showStartTimeNotifier = ValueNotifier(false);
  final ValueNotifier<bool> showEndTimeNotifier = ValueNotifier(false);

  final controller = Get.put(LightDialogController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text(
            'Light Customize',
            style: Get.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Default Settings',
                  style: Get.textTheme.titleLarge,
                ),
                Switch(
                  value: controller.defaultSettings,
                  onChanged: (value) {
                    setState(() {
                      controller.defaultSettings = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: TSize.spaceBetweenItemsVertical,),

            if (!controller.defaultSettings) ...[
              CustomTimePicker(
                label: 'Start Time',
                controller: controller.startTimeController,
              ),
              const SizedBox(height: TSize.spaceBetweenItemsSm,),

              CustomTimePicker(
                label: 'End Time',
                controller: controller.endTimeController,
              ),
            ],
          ],
        ),
      ),
      actions: [
        SmallButton(
          onPressed: () {},
          text: "Save",
        )
      ],
    );
  }
}
