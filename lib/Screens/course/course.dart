import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vocabulary_learning_app/Screens/vocab_list/vocab_list.dart';
import 'package:vocabulary_learning_app/constants/router_constants.dart';
import 'package:vocabulary_learning_app/models/app_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vocabulary_learning_app/Screens/vocab_list/vocab_list.dart';
import 'package:vocabulary_learning_app/constants/router_constants.dart';
import 'package:vocabulary_learning_app/models/app_router.dart';
import 'package:vocabulary_learning_app/Screens/Shared/nav_bar.dart';
import 'package:vocabulary_learning_app/Screens/Shared/footer.dart';
import 'package:vocabulary_learning_app/Screens/list_word/list_word.dart';
import 'dart:developer';

// NewCourseInfoPage
class CoursePage extends StatefulWidget {
  @override
  _CoursePage createState() => _CoursePage();
}

class _CoursePage extends State<CoursePage> {
  final auth = FirebaseAuth.instance;
  CollectionReference firebaseinstance;

  User user;
  bool isloggedin = false;
  checkAuth() async {
    auth.authStateChanges().listen((user) {
      // not logged in
      if (user == null) {
        AppRouter.router.navigateTo(context, AppRoutes.login.route,
            transition: TransitionType.none);
      }
      // not verified
      else if (!user.emailVerified) {
        AppRouter.router.navigateTo(context, AppRoutes.emailNotVerified.route,
            transition: TransitionType.none);
      }
    });
  }

  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      this.checkAuth();
    });

    super.initState();
  }

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _desController = new TextEditingController();
  TextEditingController _tagController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: 'VocabLearn | New List',
      primaryColor: Theme.of(context).primaryColor.value,
    ));

    var screenSize = MediaQuery.of(context).size;
    firebaseinstance = FirebaseFirestore.instance.collection('lists');
    return Scaffold(

       appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 1000),
        child: NavBar(),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
              child: Text(
                "Create new List",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 30),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 35),
              child: TextField(
                controller: _nameController,
                style: TextStyle(fontSize: 18, color: Colors.black),
                decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle:
                        TextStyle(color: Color(0xff888888), fontSize: 15)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 35),
              child: TextField(
                controller: _tagController,
                style: TextStyle(fontSize: 18, color: Colors.black),
                decoration: InputDecoration(
                    labelText: "Description",
                    labelStyle:
                        TextStyle(color: Color(0xff888888), fontSize: 15)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 35),
              child: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: <Widget>[
                  TextField(
                    controller: _desController,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    decoration: InputDecoration(
                        labelText: "Tag",
                        labelStyle:
                            TextStyle(color: Color(0xff888888), fontSize: 15)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 35),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onCreateCourse,
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.blue.shade300),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      textStyle: MaterialStateProperty.all(
                          TextStyle(color: Colors.white)),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(0))),
                  child: Text(
                    "Create",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),

            // SizedBox(
            //   height: 130,
            // ),
            Footer(),
          ],
        ),
      ),
    );
  }

  void onCreateCourse() async {

      var newCourse = await firebaseinstance.add({
          "creator_id": FirebaseAuth.instance.currentUser.uid,
          "created_at": Timestamp.now(),
          "name": _nameController.text,
          "description": _desController.text,
          "tag": _tagController.text
        });
        log('data: $newCourse.id');
     AppRouter.router.navigateTo(
      context, "/wordlists/" + newCourse.id,
      
      // routeSettings: RouteSettings(
      //   arguments: ListWord(newCourse.id),
      // ),
      transition: TransitionType.none);
  }

  Widget gotoVocabList(BuildContext context) {
    return TablePage();
  }

//   var homeHandler = Handler(
//   handlerFunc: (context, params) {
//     final MyArgumentsDataClass args = context.settings.arguments as MyArgumentsDataClass;

//     return ListWord(args);
//   },
// );
}
