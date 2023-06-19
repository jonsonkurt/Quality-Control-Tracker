import 'package:flutter/material.dart';

class InspectorListPage extends StatefulWidget {
  final String projectIDQuery;

  const InspectorListPage({
    Key? key,
    required this.projectIDQuery,
  }) : super(key: key);

  @override
  State<InspectorListPage> createState() => _InspectorListPageState();
}

class _InspectorListPageState extends State<InspectorListPage> {
  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
        backgroundColor: const Color(0xFFDCE4E9),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            mediaQuery.size.height * 0.1,
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: EdgeInsets.fromLTRB(
                mediaQuery.size.width * 0.035,
                mediaQuery.size.height * 0.028,
                0,
                0,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFF221540),
                ),
              ),
            ),
            title: Padding(
              padding: EdgeInsets.fromLTRB(
                0, 
                mediaQuery.size.height * 0.035, 
                mediaQuery.size.width * 0.06, 
                0),
              child:  Text(
                'For Inspection',
                style: TextStyle(
                  fontFamily: 'Rubik Bold',
                  fontSize: mediaQuery.size.height * 0.04,
                  color: const Color(0xFF221540),
                ),
              ),
            ),
          ),
        ),
        body: const Text('Inspector List of inspections'));
  }
}
