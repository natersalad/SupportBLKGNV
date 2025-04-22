import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload an image file and return the download URL
  Future<String?> uploadImage(File imageFile, {String folder = 'posts'}) async {
    try {
      // Generate a unique filename using UUID
      final String fileName =
          '${const Uuid().v4()}${path.extension(imageFile.path)}';
      final String filePath = '$folder/$fileName';

      // Create the storage reference
      final storageRef = _storage.ref().child(filePath);

      // Upload the file
      final uploadTask = storageRef.putFile(imageFile);

      // Wait for the upload to complete
      final snapshot = await uploadTask.whenComplete(() => null);

      // Get the download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }
}
