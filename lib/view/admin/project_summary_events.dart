import 'dart:async';
import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  final String rpName;

  final String inspectorNotes;
  final String projectUpdatesTitle;
  final String rpRole;

  const Event(
    this.projectUpdatesTitle,
    this.rpRole,
    this.rpName,
    this.inspectorNotes,
  );

  @override
  String toString() =>
      'Title: $projectUpdatesTitle\nRole: $rpRole\n$rpName\nNotes: $inspectorNotes';
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
          Map<dynamic, dynamic> inspectorNotes =
              value["inspectorNotes"] as Map<dynamic, dynamic>;
          for (int index = 1; index <= inspectDates.length; index++) {
            String keyName = "inspectionDate$index";
            String getDates = inspectDates[keyName];
            DateFormat format1 = DateFormat('MM-dd-yyyy');
            DateTime formatgetData = format1.parse(getDates);

            String rpName = value["rpName"];

            String keyNotes = "inspectorNotes$index";
            String? getNotes = inspectorNotes[keyNotes];
            String rpRole = value["rpRole"];
            String projectUpdatesTitle = value["projectUpdatesTitle"];
            Event events =
                Event(projectUpdatesTitle, rpRole, rpName, getNotes!);

            if (eventsFromDatabase[formatgetData] != null) {
              eventsFromDatabase[formatgetData]!.add(events);
            } else {
              eventsFromDatabase[formatgetData] = [events];
            }
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
