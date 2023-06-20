import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final Widget child;

  const FullScreenImage({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        color: Colors.black,
        constraints: const BoxConstraints.expand(),
        child: child,
      ),
    );
  }
}
