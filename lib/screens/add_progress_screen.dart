import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/number_slider.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AddProgressScreen extends StatelessWidget {
  AddProgressScreen(this.activity);

  final FredericActivity? activity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 12, left: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  ExtraIcons.statistics,
                  color: kMainColor,
                  size: 20,
                ),
                SizedBox(width: 12),
                Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Text(
                    'Exercise Progress',
                    style: GoogleFonts.montserrat(
                        color: kTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
                  ),
                ),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Container(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Save',
                        style: GoogleFonts.montserrat(
                            color: kMainColor, fontSize: 16),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFC9C9C9), width: 0.2)),
          ),
          Expanded(
            child: CustomScrollView(
              controller: ModalScrollController.of(context),
              slivers: [
                SliverPadding(padding: EdgeInsets.only(bottom: 12)),
                SliverToBoxAdapter(
                    child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.all(10),
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(color: kCardBorderColor)),
                  child: Row(
                    children: [
                      PictureIcon(activity!.image),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(activity!.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                    color: kMainColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17)),
                            SizedBox(height: 4),
                            Text(
                                activity!.description +
                                    activity!.description +
                                    activity!.description +
                                    activity!.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                    color: const Color(0xFF3A3A3A),
                                    letterSpacing: 0.2,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13))
                          ],
                        ),
                      )
                    ],
                  ),
                )),
                SliverToBoxAdapter(
                    child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 16),
                  child: FredericHeading('Current Performance'),
                )),
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(color: kCardBorderColor)),
                    child: Column(
                      children: [
                        buildSubHeading('Reps', Icons.loop),
                        SizedBox(height: 12),
                        NumberSlider(itemWidth: 0.14),
                        SizedBox(height: 12),
                        buildSubHeading('Sets', Icons.loop),
                        SizedBox(height: 12),
                        NumberSlider(itemWidth: 0.14),
                        SizedBox(height: 12),
                        buildSubHeading('Weight', Icons.loop),
                        SizedBox(height: 12),
                        NumberSlider(itemWidth: 0.14)
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                    child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 16),
                  child: FredericHeading('Previous Performance'),
                )),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            Container(height: 20, color: Colors.black26)
                        //SetCard(activity!.sets![index], activity)
                        ,
                        childCount: /*activity!.sets!.length*/ 2))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSubHeading(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.montserrat(
              color: const Color(0x803A3A3A),
              fontSize: 12,
              fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
