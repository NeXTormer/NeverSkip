import 'package:flutter/material.dart';
import 'package:frederic/widgets/activity_screen/activity_filter_controller.dart';
import 'package:frederic/widgets/activity_screen/appbar/activity_musclegroup_button.dart';
import 'package:frederic/widgets/activity_screen/appbar/activity_type_button.dart';

class ActivityFlexibleAppbar extends StatefulWidget {
  ActivityFlexibleAppbar({@required this.filterController});

  ActivityFilterController filterController;
  TextEditingController textController;

  @override
  _ActivityFlexibleAppbarState createState() => _ActivityFlexibleAppbarState();
}

class _ActivityFlexibleAppbarState extends State<ActivityFlexibleAppbar> {
  final double appbarHeight = 20;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    widget.textController = TextEditingController();
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: 245,
                          height: 35,
                          child: TextField(
                            controller: widget.textController,
                            autofocus: false,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (s) {
                              widget.filterController.searchText = s;
                            },
                            //cursorHeight: 50,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            decoration: InputDecoration(
                              hintText: widget.filterController.searchText,
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              suffixIcon: GestureDetector(
                                child: Icon(Icons.close, color: Colors.black54),
                                onTap: () {
                                  widget.textController.clear();
                                  widget.filterController.searchText = '';
                                },
                              ),
                              filled: true,
                              fillColor: Colors.black12,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blueAccent,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      ActivityTypeButton(
                          isActive: widget.filterController.calisthenics,
                          onPressed: () => setState(() =>
                              widget.filterController.calisthenics =
                                  !widget.filterController.calisthenics),
                          iconData: Icons.person),
                      SizedBox(width: 8),
                      ActivityTypeButton(
                          isActive: widget.filterController.weighted,
                          onPressed: () => setState(() => widget
                              .filterController
                              .weighted = !widget.filterController.weighted),
                          iconData: Icons.fitness_center),
                      SizedBox(width: 8),
                      ActivityTypeButton(
                          isActive: widget.filterController.stretch,
                          onPressed: () => setState(() => widget
                              .filterController
                              .stretch = !widget.filterController.stretch),
                          iconData: Icons.accessibility_new),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ActivityMuscleGroupButton('Chest',
                          isActive: widget.filterController.chest,
                          onPressed: () => setState(() => widget
                              .filterController
                              .chest = !widget.filterController.chest)),
                      ActivityMuscleGroupButton('Arms',
                          isActive: widget.filterController.arms,
                          onPressed: () => setState(() => widget
                              .filterController
                              .arms = !widget.filterController.arms)),
                      ActivityMuscleGroupButton('Back',
                          isActive: widget.filterController.back,
                          onPressed: () => setState(() => widget
                              .filterController
                              .back = !widget.filterController.back)),
                      ActivityMuscleGroupButton('Legs',
                          isActive: widget.filterController.legs,
                          onPressed: () => setState(() => widget
                              .filterController
                              .legs = !widget.filterController.legs)),
                      ActivityMuscleGroupButton('Abs',
                          isActive: widget.filterController.abs,
                          onPressed: () => setState(() => widget
                              .filterController
                              .abs = !widget.filterController.abs)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
