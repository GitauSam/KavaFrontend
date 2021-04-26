class RegisterRequestModel {
  String name;
  String email;
  String password;
  String password_confirmation;

  RegisterRequestModel({
    this.name,
    this.email,
    this.password,
    this.password_confirmation,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'name': name.trim(),
      'email': email.trim(),
      'password': password.trim(),
      'password_confirmation': password_confirmation.trim(),
    };

    return map;
  }
}

class RegisterResponseModel {
  final String status;
  final String message;
  final String data;

  RegisterResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      status: json["status"] != null ? json["status"] : "",
      message: json["message"] != null ? json["message"] : "",
      data: json["data"]["token"] != null ? json["data"]["token"] : "",
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "status": this.status.trim(),
      "message": this.message.trim(),
      "data": this.data.trim(),
    };

    return map;
  }
}