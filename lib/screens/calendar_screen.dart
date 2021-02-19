import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/widgets/calendar_screen/build_Calendar_view.dart';

//import 'file:///C:/Dev/Projects/frederic/lib/widgets/calendar_screen/activity_calendar_card_screen.dart';

class CalendarScreen extends StatefulWidget {
  static String routeName = '/newCalendar';

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<String> monthInYearImageUrls = [
    'https://mobil.woman.at/_storage/asset/10566591/storage/womanat:content-large/file/140877089/Erwiesen:%20HIIT-Workout%20ist%20am%20effektivsten!.jpg',
    'https://www.emotion.de/sites/www.emotion.de/files/styles/article_lead/public/home-workout.jpg?itok=51YSMTu7',
    'https://imgr1.menshealth.de/Das-perfekte-Partner-Workout-bigMobileWideOdc2x-40cf7c32-55813.jpg',
    'https://www.foodspring.at/magazine/wp-content/uploads/2020/11/workout-section-small.jpg',
    'https://imgr1.womenshealth.de/Home-Workout-169FullWidth-7ed2f872-82935.jpg',
    'https://www.sponser.at/media/catalog/product/h/e/header_pre_workout_booster.png',
    'https://www.fitbook.de/data/uploads/2020/04/gettyimages-1131378684_1587483231-1040x690.jpg',
    'https://mk0dorunibu85c8qtalq.kinstacdn.com/wp-content/uploads/2018/07/2018-06-11-PHOTO-00000059.jpg',
    'https://cdn.pullup-dip.com/media/image/6c/24/40/calisthenics-home-push-ups.jpg',
    'https://uebungenzuhause.de/wp-content/uploads/2018/02/Calisthenics-eigenes-koerpergewicht-bodyweight.jpg',
    'https://www.foodspring.at/magazine/wp-content/uploads/2020/11/Calisthenics-Training_%C2%A9Martinns.png',
    'https://cdn.pullup-dip.com/media/image/26/eb/3f/calisthenics-title_600x600.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    FredericWorkout demoWorkout =
        FredericWorkout('kKOnczVnBbBHvmx96cjG', shouldLoadActivities: true);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          leading: Icon(Icons.list),
          title: Text('2021'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.calendar_today),
            ),
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () {},
            )
          ],
        ),
      ),
      body: StreamBuilder<Object>(
          stream: demoWorkout.asStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return BuildCalendarView(
                startDate: DateTime(2021, 4, 20),
                endDate: DateTime(2021, 12),
                events: null,
                monthImgHeaderUrl: monthInYearImageUrls,
                sideColumnWidth: 50,
                workoutToLoad: snapshot.data,
              );
            }
            return Text('Loading');
          }),
    );
  }
}
