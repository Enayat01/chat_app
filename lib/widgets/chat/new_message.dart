import 'dart:io';

import 'package:chat_app/widgets/image_selection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../config/constants.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _enteredMessage = '';
  final _imagePicker = ImagePicker();
  File? _imageFile;
  final _currentUser = FirebaseAuth.instance.currentUser;
  final _userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> _sendMessage() async {
    FocusScope.of(context).unfocus();
    final docSnapShot = await _userCollection.doc(_currentUser?.uid).get();
    if (docSnapShot.exists) {
      // Map<String, dynamic>? data = docSnapShot.data();
      FirebaseFirestore.instance.collection('chat').add({
        'text': _enteredMessage,
        'timeCreated': Timestamp.now(),
        'userId': _currentUser?.uid,
        'username': docSnapShot.data()?['username'],
        'userImage': docSnapShot.data()?['userImage'],
        'type': 'text',
      });
    }
    _controller.clear();
  }

  Future _sendImage(ImageSource source) async {
    _imagePicker
        .pickImage(source: source, imageQuality: 50, maxHeight: 300)
        .then((value) {
      if (value != null) {
        _imageFile = File(value.path);
        _uploadImage();
      }
    });
  }

  Future _uploadImage() async {
    String filename = const Uuid().v1();
    final imageRef = FirebaseStorage.instance
        .ref()
        .child('chat_images')
        .child('$filename.jpg');
    await imageRef.putFile(_imageFile!);
    final imageUrl = await imageRef.getDownloadURL();
    final docSnapShot = await _userCollection.doc(_currentUser?.uid).get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': imageUrl,
      'timeCreated': Timestamp.now(),
      'userId': _currentUser?.uid,
      'username': docSnapShot.data()?['username'],
      'userImage': docSnapShot.data()?['userImage'],
      'type': 'image',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: sendMessageLabel,
                suffixIcon: IconButton(
                  onPressed: () {
                    showImageSelection(context, () {
                      _sendImage(ImageSource.camera).then((value) {
                        Navigator.pop(context);
                      });
                    }, () {
                      _sendImage(ImageSource.gallery).then((value) {
                        Navigator.pop(context);
                      });
                    });
                  },
                  icon: const Icon(Icons.attach_file),
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 3,
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            icon: const Icon(Icons.send_rounded),
          ),
        ],
      ),
    );
  }
}
