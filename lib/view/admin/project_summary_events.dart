import 'dart:async';
import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  final String rpName;
  final String projectID;

  const Event(this.rpName, this.projectID);

  @override
  String toString() => 'rpName: $rpName projectID: $projectID';
}

final DatabaseReference _databaseReference =
    FirebaseDatabase.instance.ref().child('projectUpdates/');

Map<DateTime, List<Event>> _kEventSource = {};

Future<Map<DateTime, List>> fetchEventsFromDatabase(String projectID) {
  final Completer<Map<DateTime, List>> completer =
      Completer<Map<DateTime, List>>();

  _databaseReference.once().then((DatabaseEvent snapshot) {
    // ignore: prefer_collection_literals
    final eventsFromDatabase = Map<DateTime, List<Event>>();
    final Map<dynamic, dynamic> data =
        snapshot.snapshot.value as Map<dynamic, dynamic>;

    data.forEach((key, value) {
      if (value["projectID"] == projectID) {
        if (value["inspectionDate"] != null && value["inspectionDate"] != "") {
          Map<dynamic, dynamic> inspectDates =
              value["inspectionDate"] as Map<dynamic, dynamic>;
          for (int index = 1; index <= inspectDates.length; index++) {
            String keyName = "inspectionDate$index";
            String getDates = inspectDates[keyName];
            String rpName = value["rpName"];
            print("$rpName, $getDates");
            // final dateTime = DateTime.parse(key.toString());
            DateFormat format1 = DateFormat('MM-dd-yyyy');
            DateTime formatgetData = format1.parse(getDates);

            Event events = Event(rpName, projectID);

            //List<Event>.from(value.map((event) => Event(rpName, projectID)));
            if (eventsFromDatabase[formatgetData] != null) {
              eventsFromDatabase[formatgetData]!.add(events);
            } else {
              eventsFromDatabase[formatgetData] = [events];
            }

            // eventsFromDatabase[formatgetData] = [events];
          }
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
    _kEventSource.clear(); // Clear the existing events
    _kEventSource.addAll(eventsFromDatabase as Map<DateTime, List<Event>>);
    kEvents.clear(); // Clear the global events map
    kEvents.addAll(_kEventSource);
  } catch (error) {
    print('Failed to load events: $error');
  }
}
