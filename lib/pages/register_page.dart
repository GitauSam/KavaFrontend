import 'package:flutter/material.dart';
import 'package:kava_journal/api/api_service.dart';
import 'package:kava_journal/common/ProgressHUD.dart';
import 'package:kava_journal/model/register_model.dart';
import 'package:kava_journal/services/shared_preferences_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  bool hidePassword = true;
  RegisterRequestModel requestModel;
  bool isApiCallInProgress = false;


  @override
  void initState() {
    super.initState();
    requestModel = new RegisterRequestModel();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallInProgress,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).accentColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                margin: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).hintColor,
                      offset: Offset(0, 10),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Form(
                  key: globalFormKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 25,
                      ),
                      Text("Register", style: Theme.of(context).textTheme.headline2,),
                      SizedBox(
                        height: 20,
                      ),
                      new TextFormField(
                        keyboardType: TextInputType.text,
                        onSaved: (input) => requestModel.name = input,
                        validator: (input) => input.length < 1 ? "Name should not be empty" : null,
                        decoration: new InputDecoration(
                          hintText: "Name",
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
                          prefixIcon: Icon(
                            Icons.face,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      new TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (input) => requestModel.email = input,
                        validator: (input) => !input.contains("@") ? "Email Id should be valid" : null,
                        decoration: new InputDecoration(
                          hintText: "Email Address",
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
                          prefixIcon: Icon(
                            Icons.email,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      new TextFormField(
                        keyboardType: TextInputType.text,
                        onSaved: (input) => requestModel.password = input,
                        validator: (input) => input.length < 6 ? "Password should have a min length of 6 characters" : null,
                        obscureText: hidePassword,
                        decoration: new InputDecoration(
                          hintText: "Password",
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
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).accentColor,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                            color: Theme.of(context).accentColor.withOpacity(0.4),
                            icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      new TextFormField(
                        keyboardType: TextInputType.text,
                        onSaved: (input) => requestModel.password_confirmation = input,
                        validator: (input) => input.length < 6 ? "Password should have a min length of 6 characters" : null,
                        obscureText: hidePassword,
                        decoration: new InputDecoration(
                          hintText: "Confirm Password",
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
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).accentColor,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                            color: Theme.of(context).accentColor.withOpacity(0.4),
                            icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
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

                            print("Sending registration request: " + requestModel.toString());

                            ApiService apiService = new ApiService();
                            apiService.register(requestModel).then((value) => {
                              setState(() {
                                isApiCallInProgress = false;
                              }),

                              print(value.status),
                              print(value.message),
                              print(value.data),

                              if (value.data.isNotEmpty && value.status == 'Success') {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Registration Successful"),
                                )),
                                globalFormKey.currentState.reset(),
                                SharedPreferencesService.setRegisterDetails(value),
                                Navigator.of(context).pushReplacementNamed('/index'),
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Invalid username/password"),
                                ))
                              }

                            });
                          }
                          print(requestModel.toJson());
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        color: Theme.of(context).accentColor,
                        shape: StadiumBorder(),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        child: Text(
                          "Already registered?",
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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






















