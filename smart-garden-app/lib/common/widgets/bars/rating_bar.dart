import 'package:flutter/material.dart';
import 'package:smart_garden_app/utils/constants/colors.dart';
import 'package:smart_garden_app/utils/constants/sizes.dart';
import 'package:smart_garden_app/utils/helpers/helper_functions.dart';

class CRatingBar extends StatelessWidget {
  final String? prefixText;
  final double value;
  const CRatingBar({
    this.prefixText,
    this.value = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if(prefixText != null)...[
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('$prefixText', textAlign: TextAlign.start,),
              ],
            ),
          )
        ],
        SizedBox(width: TSize.spaceBetweenItemsHorizontal,),

        Expanded(
          flex: 2,
          // width: 135,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(TSize.borderRadiusMd),
            child: SizedBox(
              height: TSize.sm,
              child: LinearProgressIndicator(
                value: value,
                color: TColor.star,
                backgroundColor: Colors.grey[300],
              ),
            ),
          ),
        ),
      ],
    );
  }
}