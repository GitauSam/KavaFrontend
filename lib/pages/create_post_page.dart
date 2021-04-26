import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kava_journal/api/api_service.dart';
import 'package:kava_journal/common/ProgressHUD.dart';
import 'package:kava_journal/model/create_post_model.dart';
import 'package:kava_journal/pages/index_post_page.dart';
import 'package:kava_journal/services/shared_preferences_service.dart';

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  bool hidePassword = true;
  bool isApiCallInProgress = false;
  CreatePostRequestModel createPostRequestModel;
  var fileUrl = null;


  @override
  void initState() {
    super.initState();
    createPostRequestModel = new CreatePostRequestModel();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(),
      inAsyncCall: isApiCallInProgress,
      opacity: 0.3,
    );
  }

  Widget _uiSetup() {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Journal"),
        elevation: 0,
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onPressed: () {
              SharedPreferencesService.logout(context);
            },
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          margin: EdgeInsets.symmetric(vertical: 35, horizontal: 20),
          child: Form(
            key: globalFormKey,
            child: Column(
              children: <Widget>[
                Text(
                  "Create Post",
                  style: Theme.of(context).textTheme.headline2,
                ),
                SizedBox(
                  height: 20,
                ),
                if (fileUrl != null) Image.file(
                  File(
                    fileUrl,
                  ),
                  height: 400,
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  onPressed: () async {
                    var file = await ImagePicker().getImage(source: ImageSource.gallery);
                    setState(() {
                      fileUrl = file.path;
                    });
                  },
                  child: Text(
                    "Add an image",
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                new TextFormField(
                  keyboardType: TextInputType.text,
                  onSaved: (input) => createPostRequestModel.message = input,
                  validator: (input) => input.length < 1 ? "Post should not be empty" : null,
                  decoration: new InputDecoration(
                    hintText: "Post",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).accentColor.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 80,
                  ),
                  onPressed: () {
                    if (validateAndSave()) {
                      setState(() {
                        isApiCallInProgress = true;
                      });

                      createPostRequestModel.image = fileUrl;

                      print("sending create post payload");
                      print(createPostRequestModel.toJson());

                      ApiService apiService = new ApiService();

                      apiService.createPost(createPostRequestModel).then((value) => {
                        setState(() {
                          isApiCallInProgress = false;
                        }),

                        print(value.status),
                        print(value.message),
                        print(value.post_message),

                        if (value.post_message.isNotEmpty && value.status == 'Success') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Created post successfully"),
                          )),
                          globalFormKey.currentState.reset(),
                          Navigator.push(context, MaterialPageRoute(builder: (context) => IndexPostPage())),
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Unable to create post"),
                          ))
                        }

                      });

                      // SharedPreferencesService.loginDetails().then((prefs) =>
                      // {
                      //   print("getting prefs"),
                      //   print(prefs),
                      //   apiService.createPost(createPostRequestModel).then((value) => {
                      //   setState(() {
                      //     isApiCallInProgress = false;
                      //   }),
                      //
                      //   print(value.status),
                      //   print(value.message),
                      //   print(value.post_message),
                      //
                      //   if (value.post_message.isNotEmpty && value.status == 'Success') {
                      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //       content: Text("Created post successfully"),
                      //     )),
                      //     globalFormKey.currentState.reset(),
                      //     Navigator.of(context).pushReplacementNamed('/home'),
                      //   } else {
                      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //       content: Text("Unable to create post"),
                      //     ))
                      //   }
                      //
                      // }),
                      // });
                    }
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Theme.of(context).accentColor,
                  shape: StadiumBorder(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
