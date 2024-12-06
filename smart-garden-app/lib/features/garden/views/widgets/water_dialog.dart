import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/features/garden/controllers/water_dialog_controller.dart';
import 'package:food_delivery_app/features/garden/views/widgets/custom_time_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/widgets/buttons/small_button.dart';
import 'package:food_delivery_app/utils/constants/sizes.dart';
import 'package:food_delivery_app/utils/helpers/helper_functions.dart';

class WaterCustomizeDialog extends StatefulWidget {
  @override
  _WaterCustomizeDialogState createState() => _WaterCustomizeDialogState();
}

class _WaterCustomizeDialogState extends State<WaterCustomizeDialog> {
  final ValueNotifier<bool> showStartTimeNotifier = ValueNotifier(false);
  final ValueNotifier<bool> showEndTimeNotifier = ValueNotifier(false);

  final controller = Get.put(WaterCustomizeController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text(
            'Water Customize',
            style: Get.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.close),
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
            if (!controller.defaultSettings) ...[
              SizedBox(height: TSize.spaceBetweenItemsVertical),
              Text(
                'Pump Timer (hours/day)',
                style: Get.textTheme.titleLarge,
              ),
              Slider(
                value: controller.pumpTimer,
                min: 0,
                max: 24,
                divisions: 24,
                label: controller.pumpTimer.toStringAsFixed(0),
                onChanged: (value) {
                  setState(() {
                    controller.pumpTimer = value;
                  });
                },
              ),
              SizedBox(height: 10),
              Text(
                'Pump cycle',
                style: Get.textTheme.titleLarge,
              ),

              PumpTimeRow(labelText: "On", unit: "(min)",),
              SizedBox(height: TSize.spaceBetweenItemsVertical),
              PumpTimeRow(labelText: "Rest", unit: "(hr)",),
              SizedBox(height: TSize.spaceBetweenItemsVertical),

             CustomTimePicker(
                label: 'Start Time',
                controller: controller.startTimeController,
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
              "${widget.labelText}",
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
                child: Icon(
                  Icons.remove,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(width: TSize.spaceBetweenItemsHorizontal),
            Text(
              '$_currentValue',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(width: TSize.spaceBetweenItemsHorizontal),
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
                child: Icon(
                  Icons.add,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(width: TSize.spaceBetweenItemsHorizontal),
          ],
        ),
      ],
    );
  }
}