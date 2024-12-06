import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/widgets/skeleton/box_skeleton.dart';
import 'package:food_delivery_app/utils/constants/sizes.dart';
import 'package:shimmer/shimmer.dart';

class FieldSkeleton extends StatelessWidget {

  const FieldSkeleton({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BoxSkeleton(height: 60, width: double.infinity);
  }
}

