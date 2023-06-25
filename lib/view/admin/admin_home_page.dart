import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quality_control_tracker/image_viewer.dart';
import 'package:quality_control_tracker/view/admin/admin_profile_page.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:quality_control_tracker/view/admin/admin_project_summary.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('projects');
  late String projectID;
  String projectName = '';
  String? name = "";

  void _handleSearch(String value) {
    setState(() {
      name = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return WillPopScope(
      onWillPop: () async {
        return false; // Disable back button
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFDCE4E9),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            mediaQuery.size.height * 0.1,
          ),
          child: AppBar(
            toolbarHeight: mediaQuery.size.height * 0.1,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: Padding(
              padding: EdgeInsets.fromLTRB(0, mediaQuery.size.height * 0.01,
                  mediaQuery.size.width * 0.06, 0),
              child: Text(
                'Dashboard',
                style: TextStyle(
                  fontFamily: 'Rubik Bold',
                  fontSize: mediaQuery.size.height * 0.04,
                  color: const Color(0xFF221540),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  0,
                  mediaQuery.size.height * 0.01,
                  mediaQuery.size.width * 0.035,
                  0,
                ),
                child: IconButton(
                  onPressed: () {
                    // ignore: use_build_context_synchronously
                    Navigator.push<void>(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdminProfilePage()));
                  },
                  icon: Icon(
                    Icons.account_circle,
                    size: mediaQuery.size.height * 0.045,
                    color: const Color(0xFF221540),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: SearchBox(onSearch: _handleSearch),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: ref
                      .orderByChild("projectStatus")
                      .equalTo("ON-GOING")
                      .onValue,
                  builder: (context, AsyncSnapshot snapshot) {
                    dynamic values;
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      DataSnapshot dataSnapshot = snapshot.data!.snapshot;

                      if (dataSnapshot.value != null) {
                        values = dataSnapshot.value;

                        return ListView.builder(
                          itemCount: values.length,
                          itemBuilder: (context, index) {
                            String projectID = values.keys.elementAt(index);

                            String projectName =
                                values[projectID]["projectName"];
                            String projectLocation =
                                values[projectID]["projectLocation"];
                            String projectImage =
                                values[projectID]["projectImage"];

                            if (name != null &&
                                name!.isNotEmpty &&
                                !projectName
                                    .toLowerCase()
                                    .contains(name!.toLowerCase())) {
                              return Container();
                            }

                            return Padding(
                              padding: EdgeInsets.fromLTRB(
                                mediaQuery.size.width * 0.02,
                                mediaQuery.size.height * 0.001,
                                mediaQuery.size.width * 0.02,
                                mediaQuery.size.height * 0.001,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ProjectSummaryPage(
                                      projectID: projectID,
                                    );
                                  }));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return DetailScreen(
                                                  imageUrl: projectImage,
                                                  projectID: projectID,
                                                );
                                              }));
                                            },

                                            // Image (kindly consult Jiiroo if you can't understand the code ty. ヾ(≧▽≦*)o)
                                            child: Hero(
                                              tag: projectID,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: projectImage == "None"
                                                      ? Image.asset(
                                                          'assets/images/no-image.png',
                                                          fit: BoxFit.cover,
                                                          width: 100,
                                                          height: 100,
                                                        )
                                                      : Image(
                                                          width: 100,
                                                          height: 100,
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                              projectImage),
                                                          loadingBuilder: (context,
                                                              child,
                                                              loadingProgress) {
                                                            if (loadingProgress ==
                                                                null) {
                                                              return child;
                                                            }
                                                            return const CircularProgressIndicator();
                                                          },
                                                          errorBuilder:
                                                              (context, object,
                                                                  stack) {
                                                            return const Icon(
                                                              Icons
                                                                  .error_outline,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      35,
                                                                      35,
                                                                      35),
                                                            );
                                                          },
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: mediaQuery
                                                              .size.width *
                                                          0.05),
                                                  child: Text(
                                                    projectName,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.fade,
                                                    softWrap: false,
                                                    style: TextStyle(
                                                      fontFamily: 'Rubik Bold',
                                                      fontSize: mediaQuery
                                                              .size.height *
                                                          0.02,
                                                      color: const Color(
                                                          0xff221540),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                        mediaQuery.size.height *
                                                            0.002),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: mediaQuery
                                                              .size.width *
                                                          0.05),
                                                  child: Text(
                                                    projectLocation,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.fade,
                                                    softWrap: false,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Karla Regular',
                                                      fontSize: mediaQuery
                                                              .size.height *
                                                          0.017,
                                                      color: const Color(
                                                          0xff221540),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                        mediaQuery.size.height *
                                                            0.002),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Project ID: \n$projectID',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Karla Regular',
                                                        fontSize: mediaQuery
                                                                .size.height *
                                                            0.017,
                                                        color: const Color(
                                                            0xff221540),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        Clipboard.setData(
                                                            ClipboardData(
                                                                text:
                                                                    projectID));
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                              content: Text(
                                                                  'Project ID copied to clipboard')),
                                                        );
                                                      },
                                                      icon: Icon(
                                                        Icons.copy,
                                                        color: const Color(
                                                            0xFF221540),
                                                        size: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // You can access and display other properties from projectData here
                                ),
                              ),
                            );
                          },
                        );
                      }
                    }
                    return const Text("");
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBox extends StatefulWidget {
  final ValueChanged<String> onSearch;

  const SearchBox({required this.onSearch, Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
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
            top: MediaQuery.of(context).size.height / 200,
            left: MediaQuery.of(context).size.width / 250,
            right: MediaQuery.of(context).size.width / 250),
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
              color: Color(0xFF221540),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: widget.onSearch,
        ),
      ),
    );
  }
}
