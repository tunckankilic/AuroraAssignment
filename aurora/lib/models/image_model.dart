class ImageModel {
  final String url;

  ImageModel({required this.url});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }

  @override
  String toString() => 'ImageModel(url: $url)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ImageModel && other.url == url;
  }

  @override
  int get hashCode => url.hashCode;
}

