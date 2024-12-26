import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_garden_app/common/widgets/buttons/main_button.dart';
import 'package:smart_garden_app/features/garden/models/Dht11.dart';
import 'package:smart_garden_app/features/garden/views/widgets/info_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_garden_app/utils/device/device_utility.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:smart_garden_app/common/widgets/misc/main_wrapper.dart';
import 'package:smart_garden_app/features/garden/controllers/dashboard_controller.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';
import 'package:smart_garden_app/utils/constants/sizes.dart';
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
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: TDeviceUtil.getScreenHeight(),
          child: MainWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: TSize.spaceBetweenItemsVertical),

                    // Date Picker
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
                          child: SizedBox(
                            width: double.infinity,
                            child: MainButton(
                              borderRadius: TSize.borderRadiusLg,
                              onPressed: controller.applyFilters,
                              text: 'Apply Filters',
                            ),
                          ),
                        ),
                      ],
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
                            'No Sensor Data Found',
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
                              onPressed: controller.fetchDht11Data,
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
                        primaryYAxis: const NumericAxis(),
                        series: <LineSeries<Dht11, String>>[
                          LineSeries<Dht11, String>(
                            name: 'Temperature',
                            dataSource: controller.filteredData,
                            xValueMapper: (Dht11 data, _) {
                              return data.createdAt != null
                                  ? DateFormat(controller.selectedTimeFormat.value).format(data.createdAt!)
                                  : '';
                            },
                            yValueMapper: (Dht11 data, _) => data.temperature,
                            color: Colors.red,
                          ),
                          LineSeries<Dht11, String>(
                            name: 'Humidity',
                            dataSource: controller.filteredData,
                            xValueMapper: (Dht11 data, _) {
                              return data.createdAt != null
                                  ? DateFormat(controller.selectedTimeFormat.value).format(data.createdAt!)
                                  : '';
                            },
                            yValueMapper: (Dht11 data, _) => data.humidity,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    );
                  }
                }),

                const SizedBox(height: TSize.spaceBetweenItemsVertical),

                // Info Cards
                Obx(() => Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          InfoCard(
                            title: "Humidity",
                            value: controller.hanoiTemperature.value,
                            icon: Icons.water_drop,
                            color: Colors.blue,
                          ),
                          InfoCard(
                            title: "Temperature",
                            value: controller.hanoiHumidity.value,
                            icon: Icons.thermostat,
                            color: Colors.red,
                          ),
                          InfoCard(
                            title: "Wind speed",
                            value: controller.hanoiWindSpeed.value,
                            icon: Icons.air,
                            color: Colors.green,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Obx(() => InfoCard(
                            title: "Light state",
                            value: controller.isLight.value ? "On" : "Off",
                            icon: Icons.lightbulb,
                            color: controller.isLight.value ? Colors.amber : TColor.bulbOffColor,
                            showSwitch: true,
                            switchValue: controller.isLight.value,
                            onSwitchChanged: controller.toggleLight,
                            disabled: controller.isLedAuto.value,
                          ),),
                          Obx(() => InfoCard(
                            title: "Light auto",
                            value: controller.isLedAuto.value ? "On" : "Off",
                            icon: Icons.auto_awesome,
                            color: Colors.orange,
                            showSwitch: true,
                            switchValue: controller.isLedAuto.value,
                            onSwitchChanged: controller.toggleLedAuto,
                          ),)
                          // InfoCard(
                          //   title: "Pump",
                          //   value: controller.isPumpOn.value ? "On" : "Off",
                          //   icon: Icons.water,
                          //   color: Colors.blue,
                          //   showSwitch: true,
                          //   switchValue: controller.isPumpOn.value,
                          //   onSwitchChanged: controller.togglePump,
                          // ),
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     InfoCard(
                      //       title: "Roof",
                      //       value: controller.isRoofOpen.value ? "Open" : "Closed",
                      //       icon: Icons.roofing,
                      //       color: Colors.orange,
                      //       showSwitch: true,
                      //       switchValue: controller.isRoofOpen.value,
                      //       onSwitchChanged: controller.toggleRoof,
                      //     ),
                      //   ],
                      // ),
                      Row(
                        children: [
                          const InfoCard(
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
                    ],
                  ),
                ),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}