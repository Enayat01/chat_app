import '../config/constants.dart';
import 'package:flutter/material.dart';

showImageSelection(
  BuildContext context,
  VoidCallback onPressedCamera,
  VoidCallback onPressedGallery,
) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text(cameraSelection),
            onTap: onPressedCamera,
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text(gallerySelection),
            onTap: onPressedGallery,
          ),
        ],
      );
    },
  );
}
