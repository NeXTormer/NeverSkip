import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class GoalCard extends StatelessWidget {
  Widget buildCardButtons() {
    return Positioned(
      top: 0.0,
      right: 0.0,
      child: Row(
        children: [
          IconButton(icon: Icon(Icons.edit), onPressed: () {}),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: Colors.red[900],
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget buildCircularPercentIndicator(String text, var padding) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: CircularPercentIndicator(
          radius: 100,
          lineWidth: 8.0,
          percent: 0.7,
          progressColor: Colors.greenAccent[400],
          center: Text(
            '70.0%',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2.0,
        child: Stack(
          children: [
            buildCardButtons(),
            Row(
              children: [
                buildCircularPercentIndicator('70.0%', 10.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Table(
                          border: TableBorder(
                            horizontalInside: BorderSide(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          children: [
                            TableRow(
                              children: [
                                Text(
                                  'Current',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0),
                                ),
                                Text(
                                  'Left',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0),
                                ),
                                Text(
                                  'Target',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 1.0),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Text(
                                  '87.5 kg',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                Text(
                                  '2.5 kg',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                Text(
                                  '90.0 kg',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
