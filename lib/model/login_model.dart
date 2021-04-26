class LoginResponseModel {
  final String status;
  final String message;
  final String data;

  LoginResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    print("--------------------------------");
    print(json);
    return LoginResponseModel(
            status: json["status"] != null ? json["status"] : "",
            message: json["message"] != null ? json["message"] : "",
            data: json["data"]["token"] != null ? json["data"]["token"] : "",
    );
  }

  factory LoginResponseModel.fromSharedPrefs(Map<String, dynamic> json) {
    print("--------------------------------");
    print(json);
    return LoginResponseModel(
      status: json["status"] != null ? json["status"] : "",
      message: json["message"] != null ? json["message"] : "",
      data: json["data"] != null ? json["data"] : "",
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'status': this.status.trim(),
      'message': this.message.trim(),
      'data': this.data.trim(),
    };

    return map;
  }
}

class LoginRequestModel {
  String email;
  String password;

  LoginRequestModel({
    this.email,
    this.password,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'email': email.trim(),
      'password': password.trim(),
    };

    return map;
  }

}