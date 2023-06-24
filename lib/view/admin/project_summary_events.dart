import 'dart:async';
import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  final String title;
  final String? projectID;

  const Event(this.title, this.projectID);

  @override
  String toString() => title;
}

final DatabaseReference _databaseReference =
    FirebaseDatabase.instance.ref().child('projectUpdates/');

final Map<DateTime, List<Event>> _kEventSource = {};

Future<Map<DateTime, List<Event>>> fetchEventsFromDatabase(String projectID) {
  final Completer<Map<DateTime, List<Event>>> completer =
      Completer<Map<DateTime, List<Event>>>();

  _databaseReference.once().then((DatabaseEvent snapshot) {
    final eventsFromDatabase = Map<DateTime, List<Event>>();
    final Map<dynamic, dynamic> data =
        snapshot.snapshot.value as Map<dynamic, dynamic>;

    data.forEach((key, value) {
      if (value["projectID"] == projectID) {
        print(value["inspectionDate"].runtimeType);
        if (value["inspectionDate"] != null && value["inspectionDate"] != "") {
          Map<dynamic, dynamic> inspectDates =
              value["inspectionDate"] as Map<dynamic, dynamic>;
          for (int index = 1; index <= inspectDates.length; index++) {
            String keyName = "inspectionDate$index";

            // final dateTime = DateTime.parse(key.toString());
            // DateFormat format1 = DateFormat('MM-dd-yyyy');
            // DateTime formatgetData = format1.parse(dateTime);
            // final events = List<Event>.from(value.map((event) =>
            //     Event(event['title'].toString(), event[projectID].toString())));
            // eventsFromDatabase[dateTime] = events;
          }
          ;
        }
      }
    });

    completer.complete(eventsFromDatabase);
  }).catchError((error) {
    completer.completeError(error);
  });

  return completer.future;
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

final kToday = DateTime.now();

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

Future<void> loadEventsFromDatabase(String projectID) async {
  try {
    final eventsFromDatabase = await fetchEventsFromDatabase(projectID);
    _kEventSource.addAll(eventsFromDatabase);
    kEvents.clear();
    kEvents.addAll(_kEventSource);
  } catch (error) {
    print('Failed to load events: $error');
  }
}
