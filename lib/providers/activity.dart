import 'package:flutter/material.dart';

class ActivityItem {
  final String activityID;
  final String description;
  // final bool hasProgress;
  final String image;
  // final bool isGlobalyActivity;
  // final bool isNotStream;
  // final bool isSingleActivity;
  // final bool isStream;
  final String name;
  final String owner;
  // final int recommendedReps;
  // final int recomendedSets;
  // final List<FredericSet> sets
  // final int weekday;
  final String date;

  ActivityItem({
    @required this.activityID,
    @required this.owner,
    @required this.name,
    @required this.description,
    @required this.image,
    this.date,
    // this.hasProgress,
    // this.isGlobalyActivity,
    // this.isSingleActivity,
    // this.isNotStream,
    // this.isStream,
    // this.recomendedSets,
    // this.recommendedReps,
    // this.weekday,
  });
}

class Activity with ChangeNotifier {
  List<ActivityItem> _activities = [
    ActivityItem(
      activityID: 'a1',
      owner: null,
      name: 'Push Up',
      description: 'Beschreibung Platzhalter',
      image:
          'https://www.runtastic.com/blog/wp-content/uploads/2018/02/10-push-up-variations-thumbnail_blog_1200x800-4-1024x683.jpg',
    ),
    ActivityItem(
      activityID: 'a2',
      owner: 'a1',
      name: 'Diamond',
      description: 'Diamond Push Up',
      image:
          'https://www.medisyskart.com/blog/wp-content/uploads/2015/07/Diamond-Press-Exercises-to-Build-Body-Muscles-1.jpg',
    ),
    ActivityItem(
      activityID: 'a3',
      owner: null,
      name: 'Pull Up',
      description: 'Pull Up',
      image:
          'https://www.medisyskart.com/blog/wp-content/uploads/2015/07/Diamond-Press-Exercises-to-Build-Body-Muscles-1.jpg',
    ),
    ActivityItem(
      activityID: 'a4',
      owner: null,
      name: 'Pull Up',
      description: 'Pull Up',
      image:
          'https://www.medisyskart.com/blog/wp-content/uploads/2015/07/Diamond-Press-Exercises-to-Build-Body-Muscles-1.jpg',
    ),
    ActivityItem(
      activityID: 'a5',
      owner: null,
      name: 'Pull Up',
      description: 'Pull Up',
      image:
          'https://www.medisyskart.com/blog/wp-content/uploads/2015/07/Diamond-Press-Exercises-to-Build-Body-Muscles-1.jpg',
    ),
    ActivityItem(
      activityID: 'a6',
      owner: null,
      name: 'Pull Up',
      description: 'Pull Up',
      image:
          'https://www.medisyskart.com/blog/wp-content/uploads/2015/07/Diamond-Press-Exercises-to-Build-Body-Muscles-1.jpg',
    ),
    ActivityItem(
      activityID: 'a7',
      owner: null,
      name: 'Pull Up',
      description: 'Pull Up',
      image:
          'https://www.medisyskart.com/blog/wp-content/uploads/2015/07/Diamond-Press-Exercises-to-Build-Body-Muscles-1.jpg',
    ),
    ActivityItem(
      activityID: 'a8',
      owner: null,
      name: 'Pull Up',
      description: 'Pull Up',
      image:
          'https://www.medisyskart.com/blog/wp-content/uploads/2015/07/Diamond-Press-Exercises-to-Build-Body-Muscles-1.jpg',
    ),
    ActivityItem(
      activityID: 'a9',
      owner: null,
      name: 'Pull Up',
      description: 'Pull Up',
      image:
          'https://www.medisyskart.com/blog/wp-content/uploads/2015/07/Diamond-Press-Exercises-to-Build-Body-Muscles-1.jpg',
    ),
    ActivityItem(
      activityID: 'a10',
      owner: null,
      name: 'Pull Up',
      description: 'Pull Up',
      image:
          'https://www.medisyskart.com/blog/wp-content/uploads/2015/07/Diamond-Press-Exercises-to-Build-Body-Muscles-1.jpg',
    ),
  ];

  List<ActivityItem> get activites {
    return [..._activities];
  }

  List<ActivityItem> get independentActivities {
    return [..._activities.where((activity) => activity.owner == null)];
  }

  List<ActivityItem> getActivitiesOfOwner(String ownerId) {
    return [..._activities.where((activity) => activity.owner == ownerId)];
  }
}
