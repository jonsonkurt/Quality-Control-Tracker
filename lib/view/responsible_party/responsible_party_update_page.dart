import 'package:flutter/material.dart';

class ResponsiblePartyUpdatePage extends StatefulWidget {
  final String projectIDQuery;

  const ResponsiblePartyUpdatePage({
    Key? key,
    required this.projectIDQuery,
  }) : super(key: key);

  @override
  State<ResponsiblePartyUpdatePage> createState() =>
      _ResponsiblePartyUpdatePageState();
}

class _ResponsiblePartyUpdatePageState
    extends State<ResponsiblePartyUpdatePage> {
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
            title: Padding(
              padding: EdgeInsets.fromLTRB(
                0, 
                mediaQuery.size.height * 0.035, 
                mediaQuery.size.width * 0.06, 
                0),
              child:  Text(
                'Updates',
                style: TextStyle(
                  fontFamily: 'Rubik Bold',
                  fontSize: mediaQuery.size.height * 0.04,
                  color: const Color(0xFF221540),
                ),
              ),
            ),
          ),
        ),
        body: const Text('Responsible party list of updates'));
  }
}
