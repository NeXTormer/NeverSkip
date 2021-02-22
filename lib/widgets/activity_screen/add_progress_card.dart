import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/widgets/activity_screen/set_card.dart';

class AddProgressCard extends StatefulWidget {
  AddProgressCard(this.activity, this.reps);

  final FredericActivity activity;
  final int reps;

  @override
  _AddProgressCardState createState() => _AddProgressCardState();
}

class _AddProgressCardState extends State<AddProgressCard> {
  _WeightCounterController weightCounterController;

  @override
  Widget build(BuildContext context) {
    weightCounterController = _WeightCounterController();

    return Wrap(children: [
      Container(
        width: double.infinity,
        child: Column(
          children: [
            Image(
                image: NetworkImage(widget.activity.image),
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover),
            Container(
              padding: EdgeInsets.all(12),
              child: FutureBuilder<FredericActivity>(
                  future: widget.activity.loadSets(10),
                  builder: (context, snapshot) {
                    String importantValue = "weight";
                    bool isCali = false;
                    num defaultValue = 0;
                    if (snapshot.hasData) {
                      isCali = snapshot.data.type ==
                          FredericActivityType.Calisthenics;
                      if (snapshot.data.type == FredericActivityType.Stretch)
                        importantValue = 'seconds';
                      defaultValue = snapshot.data.getCurrentBestProgress();
                    }

                    return Column(
                      children: [
                        Text(widget.activity.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500)),
                        SizedBox(height: 10),
                        Text(widget.activity.description),
                        SizedBox(height: 6),
                        Divider(),
                        if (!isCali) SizedBox(height: 6),
                        if (!isCali) Text('Enter $importantValue:'),
                        if (!isCali) SizedBox(height: 4),
                        if (!isCali)
                          _WeightCounter(
                            controller: weightCounterController,
                            defaultValue: defaultValue,
                          ),
                        SizedBox(height: 6),
                        OutlineButton(
                          onPressed: () {
                            if ((!isCali &&
                                    weightCounterController.value == 0) ||
                                widget.reps == 0) {
                              showDialog<void>(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Center(child: Text('Error')),
                                    content: Text(
                                        'Please enter reps${isCali ? '' : ' and weight'}'),
                                  );
                                },
                              );
                            } else {
                              widget.activity.addProgress(
                                  widget.reps, weightCounterController.value);
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            child: Text('Add progress'),
                          ),
                        ),
                        Builder(
                            //future: widget.activity.loadSetsOnce(5),
                            builder: (context) {
                          if (widget.activity.sets == null) return Container();
                          List<Widget> setList = List<Widget>();
                          for (var value in widget.activity.sets) {
                            setList.add(SetCard(value, isCali));
                          }
                          return Column(
                            children: setList,
                          );
                        }),
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _WeightCounterController {
  num value;
}

class _WeightCounter extends StatefulWidget {
  _WeightCounter({@required this.defaultValue, @required this.controller}) {
    controller.value = defaultValue;
  }

  num defaultValue;

  _WeightCounterController controller;

  @override
  __WeightCounterState createState() => __WeightCounterState();
}

class __WeightCounterState extends State<_WeightCounter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (widget.controller.value != 0) widget.controller.value--;
              });
            },
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              child: Icon(
                Icons.remove,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            width: 35,
            height: 25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0),
              color: Colors.white,
            ),
            child: Center(
              child: Text('${widget.controller.value}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                widget.controller.value++;
              });
            },
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
