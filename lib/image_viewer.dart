import 'package:flutter/material.dart';
import 'package:quality_control_tracker/full_screen_wrapper.dart';

class DetailScreen extends StatelessWidget {
  final String imageUrl;

  const DetailScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: imageUrl,
            child: imageUrl == "None"
                ? Image.asset('assets/images/no-image.png')
                : FullScreenImage(
                    child: InteractiveViewer(
                      clipBehavior: Clip.antiAlias,
                      boundaryMargin: const EdgeInsets.all(20.0),
                      minScale: 0.5,
                      maxScale: 5.0,
                      child: Image.network(imageUrl),
                    ),
                  ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
