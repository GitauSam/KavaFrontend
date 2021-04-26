class IndexPostResponseModel {
  final int id;
  final String message;
  final String user;
  final String updatedAt;
  final String imageUri;

  IndexPostResponseModel({
    this.id,
    this.message,
    this.user,
    this.updatedAt,
    this.imageUri,
  });

  factory IndexPostResponseModel.fromJson(Map<String, dynamic> json) {
    return IndexPostResponseModel(
      id: json['id'],
      message: json['message'],
      user: json['user'],
      imageUri: json['image_uri'],
      updatedAt: json['updated_at'],
    );
  }

}