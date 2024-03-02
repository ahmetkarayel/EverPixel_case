import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

class ScreenEditImage extends StatefulWidget {
  final ui.Image uiImage;
  const ScreenEditImage({super.key, required this.uiImage});

  @override
  State<ScreenEditImage> createState() => _ScreenEditImageState();
}

class _ScreenEditImageState extends State<ScreenEditImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fotoğraf Düzenleme"),centerTitle: true,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(child: RawImage(image: widget.uiImage, height: 300,))
            ],
          ),
        ),
      ),
    );
  }
}