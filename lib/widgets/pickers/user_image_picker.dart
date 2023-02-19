import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) onImagePicked;
  const UserImagePicker({
    super.key,
    required this.onImagePicked,
  });

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  Future<ImageSource?> _selectImageSource() async {
    return showDialog<ImageSource>(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text('Pick an image'),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.of(ctx).pop(ImageSource.camera),
              child: Row(
                children: const [
                  Icon(Icons.camera),
                  SizedBox(width: 10),
                  Text('Use Camera'),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.of(ctx).pop(ImageSource.gallery),
              child: Row(
                children: const [
                  Icon(Icons.image),
                  SizedBox(width: 10),
                  Text('Use Gallery'),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.of(ctx).pop(null),
              child: const Text(
                'Cancel',
                textAlign: TextAlign.end,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final ImageSource? imageSource = await _selectImageSource();
    if (imageSource == null) return;
    final XFile? xFile = await ImagePicker().pickImage(
      source: imageSource,
      imageQuality: 50,
      maxWidth: 150,
      maxHeight: 150,
    );

    if (xFile == null) return;

    setState(() {
      _pickedImage = File(xFile.path);
    });

    widget.onImagePicked(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: _pickedImage != null ? FileImage(_pickedImage!) : null,
          ),
          const Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              foregroundColor: Colors.white,
              radius: 15,
              child: Icon(
                Icons.add,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
