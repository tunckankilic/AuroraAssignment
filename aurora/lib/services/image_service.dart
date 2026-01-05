import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/image_model.dart';

class ImageService {
  static const String _baseUrl = 'https://november7-730026606190.europe-west1.run.app';
  static const String _imageEndpoint = '/image/';

  Future<ImageModel> fetchRandomImage() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_imageEndpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout');
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ImageModel.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        throw Exception('Image not found');
      } else if (response.statusCode >= 500) {
        throw Exception('Server error. Please try again later');
      } else {
        throw Exception('Failed to load image. Status code: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Unexpected error occurred: $e');
    }
  }
}

