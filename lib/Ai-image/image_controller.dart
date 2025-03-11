import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/Ai-image/my_dailog.dart';
import 'package:flutter_gemini/api/app_write.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stability_image_generation/stability_image_generation.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

enum Status { none, loading, complete }

class ImageController extends GetxController {
  final textC = TextEditingController();
  final status = Status.none.obs;

  final url = ''.obs;
  final imageList = <String>[].obs;

  Uint8List? imageBytes;
  final StabilityAI _ai = StabilityAI();
  final ImageAIStyle imageAIStyle = ImageAIStyle.moreDetails;

  final List<String> prohibitedWords = [
    "sex", "nude", "porn", "explicit", "adult", "violence", "erotic",
    "inappropriate", "nsfw", "naked", "18+", "xxx", "drugs", "gore",
    "blood", "killing", "weapon", "suicide", "abuse", "harassment",
    "hate", "discrimination", "racist", "offensive", "gambling",
    "underwear", "bikini", "lingerie", "revealing", "intimate",
    "controversial", "dangerous", "illegal", "harmful",
  ];

  Future<void> createAIImage() async {
    final inputText = textC.text.trim();

    if (inputText.isEmpty) {
      MyDialog.info('Please provide an image description');
      return;
    }

    if (_containsInappropriateContent(inputText)) {
      MyDialog.error(
          "Your prompt contains inappropriate content. Please provide a family-friendly description.");
      return;
    }

    status.value = Status.loading;
    try {
      final apiKey = await AppWrite.getImageApiKey();
      imageBytes = await _ai.generateImage(
        apiKey: apiKey,
        imageAIStyle: imageAIStyle,
        prompt: "${inputText} (safe for work, family friendly)",
      );

      status.value = Status.complete;
    } catch (e) {
      status.value = Status.none;
      MyDialog.error("Failed to generate image. Please try again.");
    }
  }

Future<void> downloadImage() async {
  try {
    if (imageBytes == null) {
      MyDialog.error("No image available to download");
      return;
    }

    // Show loading dialog
    MyDialog.showLoadingDialog();

    // Use path_provider to save the image to the app's directory
    final tempDir = await getTemporaryDirectory();
    final fileName = "AI_ArtBuddy_${DateTime.now().millisecondsSinceEpoch}.png";
    final filePath = '${tempDir.path}/$fileName';

    // Save the image as a file
    final file = await File(filePath).writeAsBytes(imageBytes!);

    // Save the file to the gallery using ImageGallerySaverPlus
    final result = await ImageGallerySaverPlus.saveFile(file.path,
        name: fileName, isReturnPathOfIOS: true);

    // Close the loading dialog
    Get.back();

    // Check the result and show appropriate dialog
    if (result['isSuccess'] == true) {
      MyDialog.success("Image saved to gallery successfully!");
    } else {
      MyDialog.error("Failed to save image to gallery");
    }
  } catch (e) {
    // Close the loading dialog if an error occurs
    Get.back();
    MyDialog.error("Failed to save image. Please check app permissions and try again.");
  }
}


//  Future<void> downloadImage() async {
//     try {
//       if (imageBytes == null) {
//         MyDialog.error("No image available to download");
//         return;
//       }

//       MyDialog.showLoadingDialog();

//       final result = await ImageGallerySaverPlus.saveImage(imageBytes!,
//           name: "AI_ArtBuddy_${DateTime.now().millisecondsSinceEpoch}",
//           isReturnImagePathOfIOS: true);

//       Get.back(); // Close loading dialog

//       if (result['isSuccess']) {
//         MyDialog.success("Image saved to gallery successfully!");
//       } else {
//         MyDialog.error("Failed to save image to gallery");
//       }
//     } catch (e) {
//       Get.back(); // Close loading dialog
//       MyDialog.error("Failed to save image. Please check app permissions and try again.");
//     }
//   }

  void ShareImage() async {
    try {
      if (imageBytes == null) {
        MyDialog.error("No image available to share");
        return;
      }

      MyDialog.showLoadingDialog();

      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/ai_image_share.png';
      final tempFile = await File(tempPath).writeAsBytes(imageBytes!);

      Get.back(); // Close loading dialog

      await Share.shareXFiles([XFile(tempFile.path)],
          text: 'Check out this amazing AI-generated art from AI ArtBuddy! 🎨✨');

      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    } catch (e) {
      Get.back();
      MyDialog.error("Failed to share image. Please try again.");
    }
  }

  // **Add these functions here:**

  void reportContentDialog(BuildContext context) {
    final TextEditingController reportController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text("Report Content"),
        content: TextField(
          controller: reportController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "Describe the issue...",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              submitReport(reportController.text);
              Get.back();
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

   Future<void> submitReport(String issueDescription) async {
    try {
      // Save the report in Firestore
      await FirebaseFirestore.instance.collection('reports').add({
        'description': issueDescription,
        'timestamp': FieldValue.serverTimestamp(),
      });
      MyDialog.success("Thank you! Your report has been submitted.");
    } catch (e) {
      MyDialog.error("Failed to submit report. Please try again.");
    }
  }

  bool _containsInappropriateContent(String text) {
    return prohibitedWords.any((word) => text.contains(word.toLowerCase()));
  }
}

class MediaStoreHelper {
  Future<void> saveImageToGallery(Uint8List imageBytes, String fileName) async {
    try {
      final directory = await getExternalStorageDirectory();
      final path = "${directory?.path}/$fileName";
      final file = File(path);
      await file.writeAsBytes(imageBytes);

      // Use MediaStore to add the file to the gallery
      final result = await File(path).create();
      MyDialog.success("Image saved successfully!");
    } catch (e) {
      MyDialog.error("Failed to save image. Please try again.");
    }
  }
}