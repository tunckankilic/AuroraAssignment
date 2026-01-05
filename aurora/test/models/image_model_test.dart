import 'package:flutter_test/flutter_test.dart';
import 'package:aurora/models/image_model.dart';

void main() {
  group('ImageModel Tests', () {
    test('fromJson should parse JSON correctly', () {
      final json = {
        'url': 'https://images.unsplash.com/photo-test',
      };

      final model = ImageModel.fromJson(json);

      expect(model.url, 'https://images.unsplash.com/photo-test');
    });

    test('toJson should serialize correctly', () {
      final model = ImageModel(
        url: 'https://images.unsplash.com/photo-test',
      );

      final json = model.toJson();

      expect(json['url'], 'https://images.unsplash.com/photo-test');
    });

    test('ImageModel should be immutable', () {
      final model = ImageModel(
        url: 'https://images.unsplash.com/photo-test',
      );

      expect(model.url, 'https://images.unsplash.com/photo-test');
      // Cannot reassign - immutability test
      // model.url = 'new'; // This should not compile
    });
  });
}

