import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'responsible_party_home_page.dart';
import 'responsible_party_update_page.dart';

class ResponsiblePartyBottomNavigation extends StatefulWidget {
  final String projectID;

  const ResponsiblePartyBottomNavigation({
    Key? key,
    required this.projectID,
  }) : super(key: key);

  @override
  State<ResponsiblePartyBottomNavigation> createState() =>
      _ResponsiblePartyBottomNavigationState();
}

class _ResponsiblePartyBottomNavigationState
    extends State<ResponsiblePartyBottomNavigation> {
  ShapeBorder? bottomBarShape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(25)),
  );
  SnakeBarBehaviour snakeBarStyle = SnakeBarBehaviour.floating;
  EdgeInsets padding = const EdgeInsets.all(12);

  int _selectedItemPosition = 0;
  SnakeShape snakeShape = SnakeShape.circle;

  Color selectedColor = const Color(0xFF221540);
  Color unselectedColor = const Color(0xFF221540);

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedItemPosition);
    _pages = [
      ResponsiblePartyHomePage(projectIDQuery: widget.projectID),
      ResponsiblePartyUpdatePage(projectIDQuery: widget.projectID),
    ];
  }

  late PageController _pageController;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _selectedItemPosition == 0
          ? Visibility(
              visible: false,
              child: FloatingActionButton(
                onPressed: () {},
              ),
            )
          : _selectedItemPosition == 1
              ? FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    // TODO: Add code for adding updates here
                    final TextEditingController _projectDescritionController =
                        TextEditingController();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: const Color(0xffDCE4E9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: const Text(
                            'Request',
                            style: TextStyle(
                                fontFamily: 'Rubik Bold',
                                fontSize: 20,
                                color: Color(0xFF221540)),
                          ),
                          content: TextField(
                            controller: _projectDescritionController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Description',
                              labelStyle: const TextStyle(
                                fontFamily: 'Karla Regular',
                                fontSize: 16,
                              ),
                            ),
                          ),
                          // actions: <Widget>[
                          //   TextButton(
                          //     onPressed: () {
                          //       print("AHHJSAHJSD");
                          //       // Fetches the project details
                          //       // DatabaseReference projectsRef = FirebaseDatabase.instance
                          //       //     .ref()
                          //       //     .child('projects/${widget.projectIDQuery}/');
                          //       // projectsRef.onValue.listen((event) {
                          //       //   try {
                          //       //     inspectorID =
                          //       //         event.snapshot.child("inspectorQuery").value.toString();
                          //       //   } catch (error, stackTrace) {
                          //       //     logger.d('Error occurred: $error');
                          //       //     logger.d('Stack trace: $stackTrace');
                          //       //   }
                          //       // });

                          //       // // Fetches the RP's details
                          //       // DatabaseReference rpRef = FirebaseDatabase.instance
                          //       //     .ref()
                          //       //     .child('responsibleParties/$userID/');
                          //       // rpRef.onValue.listen((event) {
                          //       //   try {
                          //       //     String firstName =
                          //       //         event.snapshot.child("firstName").value.toString();
                          //       //     String lastName =
                          //       //         event.snapshot.child("lastName").value.toString();
                          //       //     rpFullName = "$firstName $lastName";
                          //       //     rpRole = event.snapshot.child("role").value.toString();
                          //       //   } catch (error, stackTrace) {
                          //       //     logger.d('Error occurred: $error');
                          //       //     logger.d('Stack trace: $stackTrace');
                          //       //   }
                          //       // });

                          //       // // Adds a request for inspection on projectUpdates table
                          //       // DatabaseReference projectUpdatesRef = FirebaseDatabase.instance
                          //       //     .ref()
                          //       //     .child('projectUpdates/${widget.projectIDQuery}');

                          //       // // ignore: unnecessary_null_comparison
                          //       // if (_projectDescritionController != null) {
                          //       //   projectUpdatesRef.set({
                          //       //     "projectID": widget.projectIDQuery,
                          //       //     "rpID": userID,
                          //       //     "rpName": rpFullName,
                          //       //     "rpRole": rpRole,
                          //       //   });
                          //       //   _projectDescritionController.text = "";
                          //       //   // Navigator.of(context).pop();
                          //       // } else {
                          //       //   // Description is empty
                          //       //   _projectDescritionController.text = "";
                          //       //   ScaffoldMessenger.of(context).showSnackBar(
                          //       //     const SnackBar(
                          //       //         content: Text("Please input a description.")),
                          //       //   );
                          //       // }
                          //     },
                          //     child: const Text('Request Inspection'),
                          //   ),
                          // ],
                        );
                      },
                    );
                  },
                )
              : null,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      extendBody: true,
      body: AnimatedContainer(
        duration: const Duration(seconds: 1),
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(), // Disable swiping
          children: _pages,
        ),
      ),
      bottomNavigationBar: SnakeNavigationBar.color(
        behaviour: snakeBarStyle,
        snakeShape: snakeShape,
        shape: bottomBarShape,
        padding: padding,
        snakeViewColor: selectedColor,
        selectedItemColor:
            snakeShape == SnakeShape.indicator ? selectedColor : null,
        unselectedItemColor: unselectedColor,
        currentIndex: _selectedItemPosition,
        onTap: (index) {
          setState(() {
            _selectedItemPosition = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Update'),
        ],
      ),
    );
  }
}
