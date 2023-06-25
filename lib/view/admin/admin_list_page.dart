import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminListPage extends StatefulWidget {
  const AdminListPage({Key? key}) : super(key: key);

  @override
  State<AdminListPage> createState() => _AdminListPageState();
}

class _AdminListPageState extends State<AdminListPage> {
  StreamSubscription<DatabaseEvent>? nameSubricption;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('inspectors');
  DatabaseReference ref1 = FirebaseDatabase.instance.ref().child('projects');
  String? searchQuery = '';

  void _handleSearch(String value) {
    setState(() {
      searchQuery = value;
    });
  }

  int countProjects(List<dynamic> projectList, String inspectorName) {
    int count = 0;
    for (var project in projectList) {
      if (project['inspector'] == inspectorName) {
        count++;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> projectList = [];

    ref1.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic>? projectsData =
          snapshot.value as Map<dynamic, dynamic>?;

      if (projectsData != null) {
        projectList = projectsData.values.toList();
      } else {
        print('No data available');
      }
    }, onError: (error) {
      print('Error: $error');
    });

    return WillPopScope(
      onWillPop: () async {
        return false; // Disable back button
      },
      child: Scaffold(
          backgroundColor: const Color(0xFFDCE4E9),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              MediaQuery.of(context).size.height * 0.1,
            ),
            child: AppBar(
              toolbarHeight: 60,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              title: Padding(
                padding: EdgeInsets.fromLTRB(
                    0,
                    MediaQuery.of(context).size.height * 0.035,
                    MediaQuery.of(context).size.width * 0.06,
                    0),
                child: Text(
                  'Inspectors',
                  style: TextStyle(
                    fontFamily: 'Rubik Bold',
                    fontSize: MediaQuery.of(context).size.height * 0.04,
                    color: const Color(0xFF221540),
                  ),
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: SearchBox1(onSearch: _handleSearch),
              ),
              Expanded(
                child: StreamBuilder(
                    stream: ref.orderByChild("firstName").onValue,
                    builder: (context, AsyncSnapshot snapshot) {
                      dynamic values;

                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData) {
                        DataSnapshot dataSnapshot = snapshot.data!.snapshot;
                        if (dataSnapshot.value != null) {
                          values = dataSnapshot.value;
                          print("VALUES TO - $values");
                          return ListView.builder(
                              itemCount: values.length,
                              itemBuilder: (context, index) {
                                String projectUpdatesID =
                                    values.keys.elementAt(index);
                                String inspectorID =
                                    values[projectUpdatesID]["inspectorID"];
                                String inspectorFirstName =
                                    values[projectUpdatesID]["firstName"];
                                String inspectorLastName =
                                    values[projectUpdatesID]["lastName"];
                                String inspectorFullName =
                                    "$inspectorFirstName $inspectorLastName";
                                String inspectorProfilePic =
                                    values[projectUpdatesID]
                                        ["profilePicStatus"];

                                int projectHandled = countProjects(
                                    projectList, inspectorFullName);

                                if (searchQuery != null &&
                                    searchQuery!.isNotEmpty &&
                                    !inspectorFullName
                                        .toLowerCase()
                                        .contains(searchQuery!.toLowerCase())) {
                                  return Container();
                                }

                                return Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    MediaQuery.of(context).size.width * 0.01,
                                    MediaQuery.of(context).size.height * 0.001,
                                    MediaQuery.of(context).size.width * 0.01,
                                    MediaQuery.of(context).size.height * 0.001,
                                  ),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(

                                        ///mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Hero(
                                                  tag: inspectorID,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child:
                                                        inspectorProfilePic ==
                                                                "None"
                                                            ? Image.asset(
                                                                'assets/images/no-image.png',
                                                                fit: BoxFit
                                                                    .cover,
                                                                width: 100,
                                                                height: 100,
                                                              )
                                                            : Image(
                                                                width: 100,
                                                                height: 100,
                                                                fit: BoxFit
                                                                    .cover,
                                                                image: NetworkImage(
                                                                    inspectorProfilePic),
                                                                loadingBuilder:
                                                                    (context,
                                                                        child,
                                                                        loadingProgress) {
                                                                  if (loadingProgress ==
                                                                      null) {
                                                                    return child;
                                                                  }
                                                                  return const CircularProgressIndicator();
                                                                },
                                                                errorBuilder:
                                                                    (context,
                                                                        object,
                                                                        stack) {
                                                                  return const Icon(
                                                                    Icons
                                                                        .error_outline,
                                                                    color: Color(
                                                                        0xFF221540),
                                                                  );
                                                                },
                                                              ),
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    inspectorFullName,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Rubik Bold',
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.023),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.01,
                                                  ),
                                                  Text(
                                                    "Project handled:$projectHandled",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Karla Regular',
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.018,
                                                      color: const Color(
                                                          0xff221540),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ]),
                                  ),
                                );
                              });
                        }
                      }
                      return Text("helkko");
                    }),
              ),
            ],
          )),
    );
  }
}

class SearchBox1 extends StatefulWidget {
  final ValueChanged<String> onSearch;

  const SearchBox1({required this.onSearch, Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SearchBox1State createState() => _SearchBox1State();
}

class _SearchBox1State extends State<SearchBox1> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 50,
            left: MediaQuery.of(context).size.width / 20,
            right: MediaQuery.of(context).size.width / 20),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(
            color: Colors.black,
          ),
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Search',
            hintStyle: TextStyle(fontFamily: "GothamRnd", color: Colors.grey),
            prefixIcon: Icon(
              Icons.search,
              color: Color(0xFF274C77),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(
                color: Color(0xFF274C77),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(
                color: Color(0xFF274C77),
              ),
            ),
          ),
          onChanged: widget.onSearch,
        ),
      ),
    );
  }
}
