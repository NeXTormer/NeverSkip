import 'package:flutter/material.dart';
import 'package:frederic/providers/activity.dart';
import 'package:intl/intl.dart';
import 'package:side_header_list_view/side_header_list_view.dart';

class NewNewCalendarScreen extends StatefulWidget {
  @override
  _NewNewCalendarScreenState createState() => _NewNewCalendarScreenState();
}

class _NewNewCalendarScreenState extends State<NewNewCalendarScreen> {
  Map<int, List<ActivityItem>> _events = {
    0: [
      ActivityItem(
        activityID: 'a1',
        owner: null,
        name: 'Push Up',
        description: 'Beschreibung Platzhalter',
        image:
            'https://www.runtastic.com/blog/wp-content/uploads/2018/02/10-push-up-variations-thumbnail_blog_1200x800-4-1024x683.jpg',
        date: '01.01.2021',
      ),
      ActivityItem(
        activityID: 'a1',
        owner: null,
        name: 'Push Up',
        description: 'Beschreibung Platzhalter',
        image:
            'https://www.runtastic.com/blog/wp-content/uploads/2018/02/10-push-up-variations-thumbnail_blog_1200x800-4-1024x683.jpg',
        date: '01.01.2021',
      ),
    ],
    5: [
      ActivityItem(
        activityID: 'a1',
        owner: null,
        name: 'Push Up',
        description: 'Beschreibung Platzhalter',
        image:
            'https://www.runtastic.com/blog/wp-content/uploads/2018/02/10-push-up-variations-thumbnail_blog_1200x800-4-1024x683.jpg',
        date: '05.01.2021',
      ),
    ]
  };

  List<ActivityItem> _test = [
    ActivityItem(
      activityID: 'a1',
      owner: null,
      name: 'Push Up',
      description: 'Beschreibung Platzhalter',
      image:
          'https://www.runtastic.com/blog/wp-content/uploads/2018/02/10-push-up-variations-thumbnail_blog_1200x800-4-1024x683.jpg',
      date: '01.01.2021',
    ),
    ActivityItem(
      activityID: 'a1',
      owner: null,
      name: 'Push Up',
      description: 'Beschreibung Platzhalter',
      image:
          'https://www.runtastic.com/blog/wp-content/uploads/2018/02/10-push-up-variations-thumbnail_blog_1200x800-4-1024x683.jpg',
      date: '01.01.2021',
    ),
    ActivityItem(
      activityID: 'a1',
      owner: null,
      name: 'Push Up',
      description: 'Beschreibung Platzhalter',
      image:
          'https://www.runtastic.com/blog/wp-content/uploads/2018/02/10-push-up-variations-thumbnail_blog_1200x800-4-1024x683.jpg',
      date: '0.01.2021',
    ),
  ];

  List<String> _january = [];

  @override
  void initState() {
    for (DateTime indexDay = DateTime(2021, 1, 1);
        indexDay.month == 1;
        indexDay = indexDay.add(Duration(days: 1))) {
      _january.add(DateFormat('dd/MM/yyy').format(indexDay));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.list),
        title: Text('Month'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.calendar_today),
          ),
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              for (int i = 0; i < _january.length; i++) {
                var temp = _events[0].toList()[0].date;
                print(temp);
              }
            },
          )
        ],
      ),
      body: SideHeaderListView(
        itemCount: _january.length,
        padding: EdgeInsets.all(16.0),
        itemExtend: 48.0,
        headerBuilder: (ctx, index) {
          if (_events[index] != null) {
            return SizedBox(
              width: 32.0,
              child: Text(
                _events[index][0].date.substring(0, 2),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          } else {
            return SizedBox(
              width: 32.0,
              child: Text(
                ' ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }
        },
        itemBuilder: (ctx, index) {
          var temp = _events[index];
          if (temp != null) {
            return Container(
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...temp.map(
                    (e) => Text(e.name),
                  ),
                ],
              ),
            );
          } else {
            return Text('NO.....');
          }
        },
        hasSameHeader: (a, b) {
          //print('${names[a].substring(0, 1)} == ${names[b].substring(0, 1)}');
          // return names[a].substring(0, 1) == names[b].substring(0, 1);
          return false;
        },
      ),
    );
  }
}

const names = const <String>[
  'Annie',
  'Arianne',
  'Bertie',
  'Bettina',
  'Bradly',
  'Caridad',
  'Carline',
  'Cassie',
  'Chloe',
  'Christin',
  'Clotilde',
  'Dahlia',
  'Dana',
  'Dane',
  'Darline',
  'Deena',
  'Delphia',
  'Donny',
  'Echo',
  'Else',
  'Ernesto',
  'Fidel',
  'Gayla',
  'Grayce',
  'Henriette',
  'Hermila',
  'Hugo',
  'Irina',
  'Ivette',
  'Jeremiah',
  'Jerica',
  'Joan',
  'Johnna',
  'Jonah',
  'Joseph',
  'Junie',
  'Linwood',
  'Lore',
  'Louis',
  'Merry',
  'Minna',
  'Mitsue',
  'Napoleon',
  'Paris',
  'Ryan',
  'Salina',
  'Shantae',
  'Sonia',
  'Taisha',
  'Zula',
];
