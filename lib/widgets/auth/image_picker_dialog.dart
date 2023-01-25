import 'package:flutter/material.dart';

Future<void> _displayPickImageDialog(
    BuildContext context, VoidCallback onPick) async {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose your option'),
          content: Column(
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.photo_library),
                label: const Text('Select from gallery'),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take a photo'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: const Text('DONE'),
                onPressed: () {
                  onPick;
                  Navigator.of(context).pop();
                }),
          ],
        );
      });
}
