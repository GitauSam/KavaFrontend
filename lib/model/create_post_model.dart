class CreatePostRequestModel {
  String message;
  String image;

  CreatePostRequestModel({
    this.message,
    this.image,
  });

  Map<String, String> toJson() {
    Map<String, String>  map = {
      'message': message.trim(),
      'image': image.trim(),
    };

    return map;
  }
}

class CreatePostResponseModel {
  final String status;
  final String message;
  final String post_message;

  CreatePostResponseModel({
    this.status,
    this.message,
    this.post_message,
  });

  factory CreatePostResponseModel.fromJson(Map<String, dynamic> json) {
    return CreatePostResponseModel(
      status: json["status"] != null ? json["status"] : "",
      message: json["message"] != null ? json["message"] : "",
      post_message: json["data"]["post"]["message"] != null ? json["data"]["post"]["message"] : "",
    );
  }
}