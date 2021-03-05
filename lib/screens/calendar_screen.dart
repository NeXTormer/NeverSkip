import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/widgets/calendar_screen/calendar_view.dart';

class CalendarScreen extends StatefulWidget {
  static String routeName = '/newCalendar';

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  FredericUser user;

  String appBarTileText = '';
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

  // Future<void> getWorkoutTitle() async {
  //   if (workout != null) {
  //     print(workout.name);
  //     setState(() {
  //       appBarTileText = workout.name;
  //     });
  //   }
  // }

  @override
  void initState() {
    //getWorkoutTitle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = FredericBackend.instance().currentUser;

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.list),
        title: Text(appBarTileText),
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
      body: FredericWorkoutBuilder(
          id: 'kKOnczVnBbBHvmx96cjG',
          builder: (context, data) {
            FredericWorkout workout = data;
            workout.loadActivities();
            return CalendarView(
              startDate: DateTime(2021, 1, 20),
              endDate: DateTime(2021, 12),
              events: null,
              monthImgHeaderUrl: monthInYearImageUrls,
              sideColumnWidth: 50,
              workoutToLoad: workout,
            );
          }),
    );
  }
}
