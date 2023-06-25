import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'project_information_page.dart';
import 'project_summary_events.dart';

class ProjectSummaryPage extends StatefulWidget {
  final projectID;
  ProjectSummaryPage({super.key, this.projectID});

  @override
  _ProjectSummaryPageState createState() => _ProjectSummaryPageState();
}

class _ProjectSummaryPageState extends State<ProjectSummaryPage> {
  late ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    kEvents.clear();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
    _selectedEvents.value = _getEventsForDay(selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    loadEventsFromDatabase(widget.projectID);

    return Scaffold(
      backgroundColor: const Color(0xFFDCE4E9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.1,
        ),
        child: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: MediaQuery.of(context).size.height * 0.1,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF221540),
            ),
          ),
          title: Text(
            'Project Summary',
            style: TextStyle(
              fontFamily: 'Rubik Bold',
              fontSize: MediaQuery.of(context).size.height * 0.03,
              color: const Color(0xFF221540),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectInformationPage(
                        projectIDQuery: widget.projectID,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFF221540),
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                fontFamily: "Karla Regular",
                fontSize: MediaQuery.of(context).size.height * 0.02,
                color: const Color(0xff221540),
              ),
              weekendStyle: TextStyle(
                fontFamily: "Karla Regular",
                fontSize: MediaQuery.of(context).size.height * 0.02,
                color: const Color(0xff221540),
              ),
            ),
            headerStyle: HeaderStyle(
              headerMargin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.02,
              ),
              formatButtonDecoration: BoxDecoration(
                  border: Border.all(
                color: Colors.white,
              )),
              formatButtonTextStyle: const TextStyle(
                color: Colors.white,
              ),
              leftChevronIcon: const Icon(
                Icons.chevron_left,
                color: Colors.white,
              ),
              rightChevronIcon: const Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
              decoration: const BoxDecoration(
                color: Color(0xff221540),
              ),
              titleTextStyle: TextStyle(
                fontFamily: "Rubik Regular",
                fontSize: MediaQuery.of(context).size.height * 0.02,
                color: Colors.white,
              ),
            ),
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            calendarStyle: CalendarStyle(
                markerDecoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffE5963C),
                ),
                todayTextStyle: TextStyle(
                  fontFamily: "Karla Regular",
                  fontSize: MediaQuery.of(context).size.height * 0.018,
                  color: Colors.white,
                ),
                todayDecoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(122, 34, 21, 64),
                ),
                selectedTextStyle: TextStyle(
                  fontFamily: "Karla Regular",
                  fontSize: MediaQuery.of(context).size.height * 0.018,
                  color: Colors.white,
                ),
                selectedDecoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff221540),
                ),
                defaultTextStyle: TextStyle(
                  fontFamily: "Karla Regular",
                  fontSize: MediaQuery.of(context).size.height * 0.018,
                  color: const Color(0xff221540),
                )),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    print("VALUE $value");
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text(
                          '${value[index]}',
                          style: TextStyle(
                            fontFamily: 'Karla Regular',
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            color: const Color(0xff221540),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
