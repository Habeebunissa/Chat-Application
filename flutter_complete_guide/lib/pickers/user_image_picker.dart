// ignore_for_file: unused_element

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);

  final void Function(XFile pickedImage) imagePickFn;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  String _pickedImage = '';
  void _choooseImage() async {
    ImagePicker picker = ImagePicker();

    await picker.pickImage(source: ImageSource.camera).then((value) {
      if (value != null) {
        setState(() {
          _pickedImage = value.path;
        });
        widget.imagePickFn(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blueGrey,
          radius: 40,
          backgroundImage:
              _pickedImage != null ? FileImage(File(_pickedImage)) : null,
        ),
        ElevatedButton.icon(
            onPressed: _choooseImage,
            icon: const Icon(Icons.image),
            label: Text('Add image'),
            style: ElevatedButton.styleFrom(primary: Colors.blueAccent)),
      ],
    );
  }
}
