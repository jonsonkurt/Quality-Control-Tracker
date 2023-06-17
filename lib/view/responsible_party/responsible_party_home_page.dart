import 'package:flutter/material.dart';

class ResponsiblePartyHomePage extends StatefulWidget {
  final String projectIDQuery;

  const ResponsiblePartyHomePage({
    Key? key,
    required this.projectIDQuery,
  }) : super(key: key);

  @override
  State<ResponsiblePartyHomePage> createState() =>
      _ResponsiblePartyHomePageState();
}

class _ResponsiblePartyHomePageState extends State<ResponsiblePartyHomePage> {
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
                      color: Color(0xFF221540),),
                    ),
            ),
            title: Padding(
              padding: EdgeInsets.only(
                top: mediaQuery.size.height * 0.035,
                ),
              child: Text(
                'Information',
                style: TextStyle(
                  fontFamily: 'Rubik Bold',
                  fontSize: mediaQuery.size.height * 0.04,
                  color: const Color(0xFF221540),
                ),
              ),
            ),
          ),
        ),
        body: const Text('Party information'));
  }
}
