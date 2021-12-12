import 'package:flutter/material.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_chip.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';
import 'package:frederic/widgets/standard_elements/progress_bar.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerNormalGoalCard extends StatelessWidget {
  const ShimmerNormalGoalCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FredericCard(
        width: 260,
        padding: const EdgeInsets.all(10),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Row(
            children: [
              PictureIcon(null),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(width: 80, height: 10, color: Colors.black),
                          FredericChip('x days'),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    width: 10, height: 10, color: Colors.black),
                                Container(
                                    width: 10, height: 10, color: Colors.black),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child:
                                    Container(height: 8, color: Colors.black),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
