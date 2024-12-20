import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_garden_app/features/garden/controllers/time_controller.dart';

class CustomTimePicker extends StatelessWidget {
  final TimeController controller;
  final String label;

  const CustomTimePicker({
    Key? key,
    required this.controller,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: [
        InkWell(
          onTap: () {
            controller.toggleShowTime();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$label:',
                style: Get.textTheme.titleLarge,
              ),
              Text(
                '${controller.hour.toString().padLeft(2, '0')}:${controller.minute.toString().padLeft(2, '0')} ${controller.period}',
                style: Get.textTheme.bodyMedium,
              ),
              Icon(
                controller.showTime
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
              ),
            ],
          ),
        ),
        controller.showTime
            ? _buildTimePickerContent()
            : const SizedBox.shrink(),
      ],
    ));
  }

  Widget _buildTimePickerContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildScrollableColumn(
          count: 12,
          selectedValue: controller.hour,
          onChanged: (value) => controller.onHourChanged(value),
          time: "hour",
        ),
        const SizedBox(width: 10),
        const Text(" : "),
        const SizedBox(width: 10),
        _buildScrollableColumn(
          count: 60,
          selectedValue: controller.minute,
          onChanged: (value) => controller.onMinuteChanged(value),
          time: "minute",
        ),
        const SizedBox(width: 20),
        _buildScrollableColumn(
          count: 2,
          items: ["AM", "PM"],
          selectedValue: controller.period == "AM" ? 0 : 1,
          onChanged: (value) => controller.onPeriodChanged(value == 0 ? "AM" : "PM"),
          time: "period",
        ),
      ],
    );
  }

  Widget _buildScrollableColumn({
    required int count,
    required int selectedValue,
    int offset = 0,
    List items = const [],
    Function(int)? onChanged,
    required String time,
  }) {
    FixedExtentScrollController scrollController = FixedExtentScrollController(
      initialItem: selectedValue,
    );

    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_drop_up),
          onPressed: () {
            if (scrollController.hasClients) {
              scrollController.jumpTo(scrollController.offset - 40);
            }
          },
        ),
        Container(
          height: 100,
          width: 50,
          color: Colors.transparent,
          child: ListWheelScrollView.useDelegate(
            controller: scrollController,
            itemExtent: 40,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: onChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                final isSelected = index == selectedValue;
                return Container(
                  alignment: Alignment.center,
                  color: isSelected ? Colors.blue : Colors.grey[300],
                  child: Text(
                    items.isEmpty
                        ? (index + offset).toString().padLeft(2, '0')
                        : "${items[index]}",
                    style: TextStyle(
                      fontSize: 24,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                );
              },
              childCount: count,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_drop_down),
          onPressed: () {
            if (scrollController.hasClients) {
              scrollController.jumpTo(scrollController.offset + 40);
            }
          },
        ),
      ],
    );
  }
}
