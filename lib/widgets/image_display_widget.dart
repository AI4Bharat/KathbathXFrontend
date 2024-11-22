import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ImageDisplayWidget extends StatelessWidget {
  final String imagePath;
  final bool isAbsolute;

  const ImageDisplayWidget(
      {super.key, required this.imagePath, this.isAbsolute = false});

  Future<String> getAbsolutePath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    if (isAbsolute) {
      return imagePath;
    } else {
      return '${directory.path}/$imagePath';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getAbsolutePath(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Error loading image');
        } else if (snapshot.hasData) {
          String absoluteImagePath = snapshot.data!;
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange, width: 4.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Image.file(
                  File(absoluteImagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
