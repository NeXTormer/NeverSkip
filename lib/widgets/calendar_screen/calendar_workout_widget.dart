import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarWorkoutWidget extends StatelessWidget {
  const CalendarWorkoutWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
                    child: Text(
                      "Anabolika, Brust, Bizeps jeden Tag immer schub schub",
                      style: GoogleFonts.varelaRound(textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage('https://www.dw.com/image/54269410_401.jpg', scale: 1),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            'Ah, Farid der Boss, jage die Cops, komm mit einer Bande multikrimineller Killer bei dir rein Und mache dann aus deim Bodyguard Schrott per scharfem Geschoss aus der Kalaschnikow',
                            style: TextStyle(fontSize: 16),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )));
  }
}
