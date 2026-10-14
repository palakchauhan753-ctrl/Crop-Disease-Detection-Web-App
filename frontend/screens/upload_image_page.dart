import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class UploadImagePage extends StatefulWidget {
  const UploadImagePage({super.key});

  @override
  State<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {

  Uint8List? webImage;
  File? mobileImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          webImage = bytes;
        });
      } else {
        setState(() {
          mobileImage = File(pickedFile.path);
        });
      }
    }
  }

  bool get hasImage => kIsWeb ? webImage != null : mobileImage != null;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 🔥 TITLE
          Text(
            "Upload Leaf Image",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 10),

          // 🖼 IMAGE BOX (FIXED SIZE - NO EXPAND)
          Center(
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(8),
              ),
              child: hasImage
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: kIsWeb
                          ? Image.memory(webImage!, fit: BoxFit.cover)
                          : Image.file(mobileImage!, fit: BoxFit.cover),
                    )
                  : Icon(Icons.image, color: Colors.grey),
            ),
          ),

          SizedBox(height: 10),

          // ✅ CLICKABLE TEXT (NO BOX)
          Center(
            child: GestureDetector(
              onTap: pickImage,
              child: Text(
                hasImage
                    ? "Tap to upload another image"
                    : "Tap to upload image",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SizedBox(height: 8),

          // ✅ SUCCESS MESSAGE
          if (hasImage)
            Center(
              child: Text(
                "Image uploaded successfully",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),

          SizedBox(height: 5),
        ],
      ),
    );
  }
}