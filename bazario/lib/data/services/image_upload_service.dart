// lib/services/image_upload_service.dart
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String?> uploadImageToCloudinary(File imageFile) async {
  // Use a secure way to store your API credentials, not directly in the code.
  // For a production app, use a backend function (like Firebase Cloud Functions).
  // For now, you can keep them here for testing.
  const String cloudName = 'dyfollyzi';
  const String uploadPreset = 'your_upload_preset'; // You must create this in Cloudinary

  final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

  final request = http.MultipartRequest('POST', uri)
    ..fields['upload_preset'] = uploadPreset
    ..files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = json.decode(responseBody);
      return data['secure_url'];
    } else {
      final responseBody = await response.stream.bytesToString();
      print('Failed to upload image. Status: ${response.statusCode}, Response: $responseBody');
      return null;
    }
  } catch (e) {
    print('Error uploading image to Cloudinary: $e');
    return null;
  }
}