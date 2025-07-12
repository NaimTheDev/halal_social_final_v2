import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  /// Picks an image from gallery or camera
  Future<XFile?> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      return image;
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }

  /// Uploads an image to Firebase Storage and returns the download URL
  Future<String> uploadProfileImage(String userId, XFile imageFile) async {
    try {
      final String fileName =
          'profile_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference ref = _storage.ref().child('uploads/$fileName');

      UploadTask uploadTask;

      if (kIsWeb) {
        // For web platform, use bytes
        final Uint8List imageBytes = await imageFile.readAsBytes();
        uploadTask = ref.putData(imageBytes);
      } else {
        // For mobile platforms, we need to import dart:io conditionally
        // Use readAsBytes for cross-platform compatibility
        final Uint8List imageBytes = await imageFile.readAsBytes();
        uploadTask = ref.putData(imageBytes);
      }

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  /// Deletes an image from Firebase Storage
  Future<void> deleteImage(String imageUrl) async {
    try {
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }
}
