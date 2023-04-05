import 'package:flutter/material.dart';
class FullScreenImage extends StatelessWidget {
    final String imageUrl;
   const FullScreenImage(this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Image.network(imageUrl),
      ),
    );
  }
}