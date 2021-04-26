import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:kava_journal/api/api_service.dart';
import 'package:kava_journal/common/ProgressHUD.dart';
import 'package:kava_journal/common/app_constants.dart';
import 'package:kava_journal/model/index_post_model.dart';
import 'package:kava_journal/pages/create_post_page.dart';
import 'package:kava_journal/services/shared_preferences_service.dart';

class IndexPostPage extends StatefulWidget {
  @override
  _IndexPostPageState createState() => _IndexPostPageState();
}

class _IndexPostPageState extends State<IndexPostPage> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isApiCallInProgress = false;
  final _biggerFont = TextStyle(fontSize: 18.0, fontFamily: 'Poppins',);
  Future<List<IndexPostResponseModel>> posts;
  final ApiService apiService = new ApiService();

  @override
  void initState() {
    super.initState();
    posts = apiService.indexPosts();
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
      key: scaffoldKey,
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
        ],
      ),
      body: Center(
        child: FutureBuilder <List<IndexPostResponseModel>>(
          future: posts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<IndexPostResponseModel> postList = snapshot.data;
              return ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemCount: postList.length,
                itemBuilder: (BuildContext context, int index) {
                  // if (index.isOdd) return Divider();
                  return _buildRow(postList[index]);
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/create_post');
        },
        child: Icon(
          Icons.add
        ),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }

  Widget _buildRow(IndexPostResponseModel post) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Card(
        elevation: 20,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 0),
              child: Image.network(
                AppConstants.url + post.imageUri,
                height: 200,
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                post.message,
                style: _biggerFont,
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.all(5),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  Jiffy(post.updatedAt).fromNow(),
                  style: TextStyle(color: Colors.grey, fontFamily: 'Poppins',),
                ),
              ),
            ),
            SizedBox(height: 5,),
          ],
        ),
      ),
    );
  }
}
