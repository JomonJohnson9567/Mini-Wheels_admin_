import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Shared Cloudinary service for uploading images
/// This service handles image uploads to Cloudinary using upload presets
class CloudinaryService {
  static const String cloudName = 'dxpt9leg6';
  static const String uploadPreset = 'Mini_Wheelz';
  static const String baseUrl =
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

  /// Uploads a single image to Cloudinary
  /// Returns the secure URL of the uploaded image
  /// Throws an exception if upload fails
  static Future<String> uploadImage(
    Uint8List imageBytes,
    String imageName,
  ) async {
    try {
      final url = Uri.parse(baseUrl);
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(
          http.MultipartFile.fromBytes('file', imageBytes, filename: imageName),
        );

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = json.decode(responseBody);
        return data['secure_url'] as String;
      } else {
        final errorBody = await response.stream.bytesToString();
        throw Exception(
          'Failed to upload image: ${response.statusCode} - $errorBody',
        );
      }
    } catch (e) {
      throw Exception('Cloudinary upload error: $e');
    }
  }

  /// Uploads multiple images to Cloudinary sequentially
  /// Returns a list of secure URLs in the same order as input
  /// If any upload fails, throws an exception
  static Future<List<String>> uploadImages(
    List<Uint8List> imageBytesList,
    List<String> imageNames,
  ) async {
    if (imageBytesList.length != imageNames.length) {
      throw Exception('Image bytes and names lists must have the same length');
    }

    List<String> imageUrls = [];

    for (int i = 0; i < imageBytesList.length; i++) {
      final url = await uploadImage(imageBytesList[i], imageNames[i]);
      imageUrls.add(url);
    }

    return imageUrls;
  }
}
