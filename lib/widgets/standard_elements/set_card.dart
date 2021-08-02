import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/standard_elements/frederic_action_dialog.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_vertical_divider.dart';
import 'package:intl/intl.dart';

class SetCard extends StatefulWidget {
  SetCard(this.set, this.activity)
      : super(key: ValueKey<DateTime>(set.timestamp));

  final FredericSet set;
  final FredericActivity activity;

  final Duration animationDuration = const Duration(milliseconds: 200);

  @override
  _SetCardState createState() => _SetCardState();
}

class _SetCardState extends State<SetCard> {
  bool deleted = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: widget.animationDuration,
      padding: deleted
          ? const EdgeInsets.symmetric(horizontal: 16)
          : const EdgeInsets.only(left: 16, right: 16, top: 10),
      child: FredericCard(
          animated: true,
          duration: widget.animationDuration,
          padding: const EdgeInsets.all(8),
          height: deleted ? 0 : 51,
          onLongPress: () {
            showDialog(
                context: context,
                builder: (context) => FredericActionDialog(
                      title: 'Confirm deletion',
                      actionText: 'Delete',
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                            'Do you want to delete this set? This cannot be undone!',
                            textAlign: TextAlign.center),
                      ),
                      onConfirm: () => handleDelete(context),
                      destructiveAction: true,
                    ));
          },
          onTap: () {},
          child: deleted
              ? null
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: kMainColorLight),
                      child: Icon(
                        ExtraIcons.statistics,
                        color: kMainColor,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${widget.set.reps}',
                          style: TextStyle(
                              color: kTextColor,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              fontSize: 14),
                        ),
                        SizedBox(width: 3),
                        Text('reps',
                            style: TextStyle(
                                color: kTextColor,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                                fontSize: 12)),
                        if (widget.activity.type ==
                            FredericActivityType.Weighted) ...[
                          SizedBox(width: 10),
                          FredericVerticalDivider(length: 16),
                          SizedBox(width: 10),
                          Text(
                            '${widget.set.weight}',
                            style: TextStyle(
                                color: kTextColor,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                fontSize: 14),
                          ),
                          SizedBox(width: 3),
                          Text(widget.activity.progressUnit,
                              style: TextStyle(
                                  color: kTextColor,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                  fontSize: 12)),
                        ]
                      ],
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Text(
                      '${DateFormat.yMMMd().format(widget.set.timestamp.toLocal())}',
                      style: TextStyle(
                          color: kTextColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                          fontSize: 14),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${DateFormat.Hm().format(widget.set.timestamp.toLocal())}',
                      style: TextStyle(
                          color: kTextColor,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.3,
                          fontSize: 14),
                    ),
                    SizedBox(width: 12),
                    Icon(ExtraIcons.calendar, color: kMainColor, size: 22),
                  ],
                )),
    );
  }

  void handleDelete(BuildContext context) {
    setState(() {
      deleted = true;
    });
    Future.delayed(widget.animationDuration).then((value) {
      FredericBackend.instance.setManager.state[widget.activity.activityID]
          .deleteSet(widget.set);
      Navigator.of(context).pop();
    });
  }
}
