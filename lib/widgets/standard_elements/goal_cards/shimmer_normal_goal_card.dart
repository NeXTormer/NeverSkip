import 'package:flutter/material.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';
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
                          Container(
                              width: 80, height: 10, color: Colors.black54),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100))),
                            child: Container(
                              width: 32,
                              height: 11,
                            ),
                          )
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
                                    width: 10,
                                    height: 10,
                                    color: Colors.black54),
                                Container(
                                    width: 10,
                                    height: 10,
                                    color: Colors.black54),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child:
                                    Container(height: 8, color: Colors.black54),
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
