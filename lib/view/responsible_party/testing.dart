import 'package:flutter/material.dart';

class TestingPage extends StatefulWidget {
  @override
  _TestingPageState createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Enter Text'),
              content: TextField(
                controller: _textFieldController,
                decoration: InputDecoration(hintText: "Enter your text"),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('Submit'),
                  onPressed: () {
                    // Perform your logic here with the entered text
                    String enteredText = _textFieldController.text;
                    // For example, you can print the text
                    print(enteredText);

                    Navigator.of(context).pop(); // Close the dialog box
                  },
                ),
              ],
            );
          },
        );
      },
      child: Icon(Icons.add),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dialog Box Example'),
        ),
        body: Center(
          child: Text('Press the floating action button'),
        ),
        floatingActionButton: TestingPage(),
      ),
    );
  }
}
