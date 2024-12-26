import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_garden_app/common/widgets/buttons/main_button.dart';
import 'package:smart_garden_app/common/widgets/misc/main_wrapper.dart';
import 'package:smart_garden_app/features/garden/controllers/plant_detail_moisture_controller.dart';
import 'package:smart_garden_app/features/garden/models/Moisture.dart';
import 'package:smart_garden_app/features/garden/models/Plant.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';
import 'package:smart_garden_app/utils/constants/sizes.dart';
import 'package:smart_garden_app/utils/device/device_utility.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PlantDetailMoistureView extends StatelessWidget {
  final Plant plant;

  const PlantDetailMoistureView({
    Key? key,
    required this.plant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PlantDetailMoistureController(plant: plant));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${plant.name} moisture",
          // style: Get.textTheme.displaySmall?.copyWith(
          //   fontWeight: FontWeight.w700,
          // ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Get.isDarkMode ? TColor.light : TColor.dark,),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: MainWrapper(
        child: Column(
          children: [
            const SizedBox(height: TSize.spaceBetweenItemsVertical),

            Row(
              children: [
                Expanded(
                  child: Obx(() => TextFormField(
                    controller: TextEditingController(
                      text: controller.selectedDate.value.toString().split(' ')[0],
                    ),
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                      prefixIcon: const Icon(Icons.calendar_today),
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                      border: const OutlineInputBorder(),
                    ),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: controller.selectedDate.value,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        controller.setDate(date);
                      }
                    },
                  )),
                ),
              ],
            ),
            const SizedBox(height: TSize.spaceBetweenItemsVertical),
        
            Row(
              children: [
                Expanded(
                  child: Obx(() => DropdownButtonFormField<int>(
                    decoration: const InputDecoration(labelText: 'Start Time'),
                    value: controller.startTime.value,
                    items: List.generate(25, (index) => index)
                        .map((hour) => DropdownMenuItem(
                      value: hour,
                      child: Text('$hour:00'),
                    ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) controller.setStartTime(value);
                    },
                  )),
                ),
                const SizedBox(width: TSize.spaceBetweenItemsSm),
                Expanded(
                  child: Obx(() => DropdownButtonFormField<int>(
                    decoration: const InputDecoration(labelText: 'End Time'),
                    value: controller.endTime.value,
                    items: List.generate(25, (index) => index)
                        .map((hour) => DropdownMenuItem(
                      value: hour,
                      child: Text('$hour:00'),
                    ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) controller.setEndTime(value);
                    },
                  )),
                ),
                const SizedBox(width: TSize.spaceBetweenItemsSm),
                Expanded(
                  child: MainButton(
                    borderRadius: TSize.borderRadiusLg,
                    onPressed: controller.applyFilters,
                    text: 'Apply Filters',
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSize.spaceBetweenItemsVertical),
        
            Row(
              children: [
                Expanded(
                  child: Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedTimeFormat.value,
                    items: const [
                      DropdownMenuItem(value: 'HH', child: Text('HH')),
                      DropdownMenuItem(value: 'HH:mm', child: Text('HH:mm')),
                      DropdownMenuItem(value: 'HH:mm:ss', child: Text('HH:mm:ss')),
                    ],
                    onChanged: (value) {
                      if (value != null) controller.setTimeFormat(value);
                    },
                  )),
                ),
              ],
            ),
            const SizedBox(height: TSize.spaceBetweenItemsVertical),
        
            Obx(() {
              if (controller.isLoading.value) {
                return Shimmer.fromColors(
                  baseColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[600]!
                      : Colors.grey[300]!,
                  highlightColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[500]!
                      : Colors.grey[100]!,
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                );
              } else if (controller.filteredData.isEmpty) {
                return Container(
                  width: TDeviceUtil.getScreenWidth(),
                  height: 250,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[800]
                        : Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[700]!
                          : Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.analytics_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: TSize.spaceBetweenItemsSm),
                      Text(
                        'No Moisture Data Found',
                        style: Get.textTheme.titleMedium?.copyWith(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: TSize.spaceBetweenItemsSm),
                      Text(
                        'Try adjusting your filters or selecting a different date',
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: TSize.spaceBetweenItemsMd),
                      SizedBox(
                        width: 150,
                        child: MainButton(
                          borderRadius: TSize.borderRadiusLg,
                          onPressed: controller.fetchMoistureData,
                          prefixIcon: Icons.refresh_rounded,
                          backgroundColor: Colors.transparent,
                          textColor: TColor.primary,
                          prefixIconColor: TColor.primary,
                          text: 'Refresh data',
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return SizedBox(
                  height: 250,
                  child: SfCartesianChart(
                    legend: const Legend(isVisible: true),
                    primaryXAxis: const CategoryAxis(),
                    primaryYAxis: const NumericAxis(
                      minimum: 0,
                      maximum: 100,
                      title: AxisTitle(text: 'Moisture %'),
                    ),
                    series: <LineSeries<Moisture, String>>[
                      LineSeries<Moisture, String>(
                        name: 'Moisture',
                        dataSource: controller.filteredData,
                        xValueMapper: (Moisture data, _) {
                          return data.createdAt != null
                              ? DateFormat(controller.selectedTimeFormat.value)
                              .format(data.createdAt!)
                              : '';
                        },
                        yValueMapper: (Moisture data, _) => data.moisture,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}