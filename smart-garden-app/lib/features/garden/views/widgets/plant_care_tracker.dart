import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/features/garden/models/garden/plant.dart';
import 'package:food_delivery_app/features/garden/views/widgets/light_dialog.dart';
import 'package:food_delivery_app/features/garden/views/widgets/tracking_button.dart';
import 'package:food_delivery_app/features/garden/views/widgets/water_dialog.dart';
import 'package:food_delivery_app/features/garden/views/widgets/water_dialog.dart';
import 'package:food_delivery_app/features/garden/views/widgets/water_dialog.dart';
import 'package:food_delivery_app/utils/constants/sizes.dart';

class PlantCareTracker extends StatelessWidget {
  final Plant plant;
  final Axis direction;

  const PlantCareTracker({
    required this.plant,
    this.direction = Axis.horizontal,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: direction,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _buildTrackingWidgets(context),
    );
  }

  List<Widget> _buildTrackingWidgets(BuildContext context) {
    final bool isHorizontal = direction == Axis.horizontal;

    return [
      TrackingWidget(
        onPressed: () {
          showDialog(context: context, builder: (context) => WaterCustomizeDialog());
        },
        topText: 'Water',
        iconData: Icons.water_drop,
        progressColor: Colors.blue,
        progressValue: 2 / plant.waterDaysPerWeek,
        middleText: '${plant.waterDaysPerWeek} days',
        bottomText: 'every 7 days',
      ),
      SizedBox(
        width: isHorizontal ? TSize.spaceBetweenItemsXl : 0.0,
        height: isHorizontal ? 0.0 : TSize.spaceBetweenItemsXl,
      ),
      TrackingWidget(
        onPressed: () {
          showDialog(context: context, builder: (context) => LightDialog());
    },
        topText: 'Light',
        iconData: Icons.light_mode,
        progressColor: Colors.orange,
        progressValue: plant.lightPercentPerDay / 100,
        middleText: '${plant.lightPercentPerDay}%',
        bottomText: '18 hours a day',
      ),
      SizedBox(
        width: isHorizontal ? TSize.spaceBetweenItemsXl : 0.0,
        height: isHorizontal ? 0.0 : TSize.spaceBetweenItemsXl,
      ),
      TrackingWidget(
        onPressed: () {
          showDialog(context: context, builder: (context) => WaterCustomizeDialog());
        },
        topText: 'Plant',
        iconData: Icons.eco,
        progressColor: Colors.green,
        progressValue: plant.plantDays / 30,
        middleText: '${plant.plantDays} days',
        bottomText: 'since planting',
      ),
    ];
  }
}
