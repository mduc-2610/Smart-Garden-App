import 'package:smart_garden_app/features/garden/controllers/water_dialog_controller.dart';
import 'package:smart_garden_app/features/garden/models/Plant.dart';
import 'package:smart_garden_app/features/garden/views/widgets/custom_time_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:smart_garden_app/common/widgets/buttons/small_button.dart';
import 'package:smart_garden_app/utils/constants/enums.dart';
import 'package:smart_garden_app/utils/constants/sizes.dart';

class WaterCustomizeDialog extends StatefulWidget {
  final Plant? plant;
  const WaterCustomizeDialog({
    required this.plant,
    super.key
  });

  @override
  _WaterCustomizeDialogState createState() => _WaterCustomizeDialogState();
}

class _WaterCustomizeDialogState extends State<WaterCustomizeDialog> {
  // final ValueNotifier<bool> showStartTimeNotifier = ValueNotifier(true);
  // final ValueNotifier<bool> showPumpTimeNotifier = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WaterCustomizeController(plant: widget.plant), tag: "${widget.plant?.id}");
    return AlertDialog(
      title: Row(
        children: [
          Text(
            'Water Customize',
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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       'Default Settings',
            //       style: Get.textTheme.titleLarge,
            //     ),
            //     Switch(
            //       value: controller.defaultSettings,
            //       onChanged: (value) {
            //         setState(() {
            //           controller.defaultSettings = value;
            //         });
            //       },
            //     ),
            //   ],
            // ),
            if (!controller.defaultSettings) ...[
              // const SizedBox(height: TSize.spaceBetweenItemsVertical),
              // Text(
              //   'Pump Timer (hours/day)',
              //   style: Get.textTheme.titleLarge,
              // ),
              // Slider(
              //   value: controller.pumpTimer,
              //   min: 0,
              //   max: 24,
              //   divisions: 24,
              //   label: controller.pumpTimer.toStringAsFixed(0),
              //   onChanged: (value) {
              //     setState(() {
              //       controller.pumpTimer = value;
              //     });
              //   },
              // ),
              // const SizedBox(height: 10),
              // Text(
              //   'Pump cycle',
              //   style: Get.textTheme.titleLarge,
              // ),
              //
              // const PumpTimeRow(labelText: "On", unit: "(min)",),
              // const SizedBox(height: TSize.spaceBetweenItemsVertical),
              // const PumpTimeRow(labelText: "Rest", unit: "(hr)",),
              // const SizedBox(height: TSize.spaceBetweenItemsVertical),
             CustomTimePicker(
               label: "Pump Time",
               controller:  controller.pumpTimeController,
               format: TimeFormat.MMSS,
               showPeriod: false,
             ),

             CustomTimePicker(
                label: 'Start Time',
                controller: controller.startTimeController,
                format: TimeFormat.HHMM,
              ),
            ],
          ],
        ),
      ),
      actions: [
        SmallButton(
          onPressed: controller.saveSettings,
          text: "Save",
        )
      ],
    );
  }
}


class PumpTimeRow extends StatefulWidget {
  final String labelText;
  final String unit;
  final int initialValue;
  final int minValue;
  final int maxValue;

  const PumpTimeRow({
    Key? key,
    required this.labelText,
    required this.unit,
    this.initialValue = 0,
    this.minValue = 0,
    this.maxValue = 60,
  }) : super(key: key);

  @override
  _PumpTimeRowState createState() => _PumpTimeRowState();
}

class _PumpTimeRowState extends State<PumpTimeRow> {
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  void _incrementValue() {
    setState(() {
      if (_currentValue < widget.maxValue) {
        _currentValue++;
      }
    });
  }

  void _decrementValue() {
    setState(() {
      if (_currentValue > widget.minValue) {
        _currentValue--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              widget.labelText,
              style: Get.textTheme.bodyMedium,
            ),
            Text(
              " ${widget.unit}",
              style: Get.textTheme.bodyMedium,
            ),
          ],
        ),
        Row(
          children: [
            InkWell(
              onTap: _decrementValue,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(TSize.borderRadiusSm),
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  )
                ),
                child: const Icon(
                  Icons.remove,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: TSize.spaceBetweenItemsHorizontal),
            Text(
              '$_currentValue',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: TSize.spaceBetweenItemsHorizontal),
            InkWell(
              onTap: _incrementValue,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(TSize.borderRadiusSm),
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  )
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: TSize.spaceBetweenItemsHorizontal),
          ],
        ),
      ],
    );
  }
}