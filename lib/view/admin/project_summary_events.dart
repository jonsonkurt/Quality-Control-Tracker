import 'package:firebase_database/firebase_database.dart';

class Event {
  final String date;
  final String? name;
  final String? notes;

  Event({
    required this.date,
    this.name,
    this.notes,
  });
}
