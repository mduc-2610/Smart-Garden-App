import 'package:flutter/material.dart';
import 'package:smart_garden_app/common/widgets/skeleton/box_skeleton.dart';
import 'package:smart_garden_app/utils/constants/sizes.dart';
import 'package:shimmer/shimmer.dart';

class FieldSkeletonList extends StatelessWidget {
  final int length;

  const FieldSkeletonList({
    required this.length,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return
      Column(
        children: [
          for(int i = 0; i < length; i++)...[
            BoxSkeleton(height: 60, width: double.infinity),
            if(i != length - 1) SizedBox(height: TSize.spaceBetweenInputFields,),
          ]
        ],
      );
  }
}