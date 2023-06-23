import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'project_summary_events.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class ProjectSummaryPage extends StatefulWidget {
  final String projectID;

  const ProjectSummaryPage({required this.projectID});

  @override
  _ProjectSummaryPageState createState() => _ProjectSummaryPageState();
}

class _ProjectSummaryPageState extends State<ProjectSummaryPage> {
  CalendarFormat format = CalendarFormat.month;
  late Map<DateTime, List<Event>> selectedEvents;

  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  String projectUpdatesID = '';

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref().child("projectUpdates");
    return Scaffold(
        appBar: AppBar(
          title: const Text("Project Summary"),
          centerTitle: true,
        ),
        // Start here heron
        body: StreamBuilder(
            stream:
                ref.orderByChild("projectID").equalTo(widget.projectID).onValue,
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                // pang query sa lahat ng projectUpdates na match sa projectID ng pinindot na card sa admin_home_page.dart
                for (var entry in map.entries) {
                  var innerMap = entry.value;
                  if (innerMap.containsKey("projectUpdatesID")) {
                    projectUpdatesID = innerMap["projectUpdatesID"];
                    String rpName = map[projectUpdatesID]["rpName"];

                    // dito ipapasok yung nasa database
                    // bale yung ipapasok sa selectedEvents is una yung RP submissionDate, rp name, rp notes kung meron man
                    // next is inspectiondate
                    // next is inspectionIssueDeadline
                    // eto kasi yung may mga date na need makita sa calendar
                    //  Pa uncomment na lang.
                    // if (selectedEvents[selectedDay] != null) {
                    //   selectedEvents[selectedDay]!.add(

                    //     Event(date: , name: , notes: ), // eto yung nasa project_summary_events.dart, date lang required dito
                    //   );
                    // } else {
                    //   selectedEvents[selectedDay] = [
                    //     Event(date: , name: , notes: ),
                    //   ];
                    // }
                    print(projectUpdatesID);
                  }
                }
                return Column(
                  children: [
                    TableCalendar(
                      focusedDay: selectedDay,
                      firstDay: DateTime(1990),
                      lastDay: DateTime(2050),
                      calendarFormat: format,
                      onFormatChanged: (CalendarFormat _format) {
                        setState(() {
                          format = _format;
                        });
                      },
                      startingDayOfWeek: StartingDayOfWeek.sunday,
                      daysOfWeekVisible: true,

                      //Day Changed
                      onDaySelected: (DateTime selectDay, DateTime focusDay) {
                        setState(() {
                          selectedDay = selectDay;
                          focusedDay = focusDay;
                        });
                      },
                      selectedDayPredicate: (DateTime date) {
                        return isSameDay(selectedDay, date);
                      },
                      //To style the Calendar
                      calendarStyle: CalendarStyle(
                        isTodayHighlighted: true,
                        selectedDecoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        selectedTextStyle: const TextStyle(color: Colors.white),
                        todayDecoration: BoxDecoration(
                          color: Colors.purpleAccent,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        defaultDecoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        weekendDecoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: true,
                        titleCentered: true,
                        formatButtonShowsNext: false,
                        formatButtonDecoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        formatButtonTextStyle: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ..._getEventsfromDay(selectedDay).map(
                      (Event event) => ListTile(
                        title: Text(
                          event.date, // para macall mo yung date sa listTile.
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Text("hello");
            }));
  }
}
