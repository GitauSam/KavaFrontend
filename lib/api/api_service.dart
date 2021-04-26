import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:kava_journal/common/app_constants.dart';
import 'package:kava_journal/model/create_post_model.dart';
import 'package:kava_journal/model/index_post_model.dart';
import 'dart:convert';

import 'package:kava_journal/model/login_model.dart';
import 'package:kava_journal/model/register_model.dart';
import 'package:kava_journal/services/shared_preferences_service.dart';

class ApiService {

  final String baseUrl = AppConstants.url +  "/api";

  Map<String, String> requestHeaders = {
    'Content-type': 'application/x-www-form-urlencoded'
  };

  Future<LoginResponseModel> login(LoginRequestModel loginRequestModel) async {
    String url = baseUrl + "/auth/login";

    final response = await http.post(
        Uri.parse(url),
        headers: requestHeaders,
        body: loginRequestModel.toJson()
    );
    
    if (response.statusCode == 200) {
      LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(json.decode(response.body));
      return loginResponseModel;
    } else {
      throw Exception("Failed to login");
    }
  }

  Future<RegisterResponseModel> register(RegisterRequestModel registerRequestModel) async {
    String url = baseUrl + "/auth/register";

    final response = await http.post(
        Uri.parse(url),
      headers: requestHeaders,
      body: registerRequestModel.toJson()
    );

    if (response.statusCode == 200) {
      RegisterResponseModel registerResponseModel = RegisterResponseModel.fromJson(json.decode(response.body));
      return registerResponseModel;
    } else {
      throw Exception("Failed to register");
    }
  }

  Future<CreatePostResponseModel> createPost(CreatePostRequestModel createPostRequestModel) async {

    String url = baseUrl + "/v1/journal/create";
    var details = await SharedPreferencesService.loginDetails();

    print("token: " + details.data);

    requestHeaders["Authorization"] = "Bearer " + details.data;

    var request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
    );
    request.files.add(
        http.MultipartFile.fromBytes(
            'image',
            File(createPostRequestModel.image).readAsBytesSync(),
            filename: createPostRequestModel.image.split("/").last,
        ),
    );

    request.fields.addAll(createPostRequestModel.toJson());
    request.headers.addAll(requestHeaders);

    final response =  await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      CreatePostResponseModel createPostResponseModel = CreatePostResponseModel.fromJson(json.decode(response.body));
      return createPostResponseModel;
    } else {
      throw Exception("Failed to create post");
    }
  }

  Future<List<IndexPostResponseModel>> indexPosts() async {

    String url = baseUrl + "/v1/journal";
    var details = await SharedPreferencesService.loginDetails();

    print("token: " + details.data);

    requestHeaders["Authorization"] = "Bearer " + details.data;

    final response = await http.get(
      Uri.parse(url),
      headers: requestHeaders
    );

    if (response.statusCode == 200) {
      // List resp = json.decode(response.body);

      print(response.body);
      print("--------------------------------------------------------------");
      print(json.decode(response.body)['data']['posts']);

      List resp = json.decode(response.body)['data']['posts'];

      print("posts size: ");
      print(resp.length);

      return resp.map(
          (data) => new  IndexPostResponseModel.fromJson(data)
      ).toList();
    } else {
      throw Exception("Unable to fetch journal posts");
    }
  }

}