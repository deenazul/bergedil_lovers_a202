import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

class UserFeed extends StatefulWidget {
  final String email;
  const UserFeed({Key key, this.email}) : super(key: key);
  @override
  _UserFeedState createState() => _UserFeedState();
}

class _UserFeedState extends State<UserFeed> {
  List _feedList;
  double screenHeight, screenWidth;
  final df = new DateFormat('dd-MM-yyyy hh:mm a');
  ProgressDialog pr;
  String email;
  @override
  void initState() {
    super.initState();
    _loadPost();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('REVIEWS'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(children: [
        _feedList == null
            ? Flexible(child: Center(child: Text("No post.")))
            : Flexible(
                child: Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 20,),
                    Flexible(
                        flex: 9,
                        child: ListView.builder(
                            itemCount: _feedList.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                child: Card(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                flex: 6,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(df.format(DateTime
                                                        .parse(_feedList[index]
                                                            ['dateposted'])))
                                                  ],
                                                )),
                                            Expanded(
                                                flex: 2,
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 10, 0),
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: PopupMenuButton(
                                                      onSelected: (newValue) {
                                                        if (newValue == 1) {
                                                          _deleteDialog(index);
                                                        }
                                                        if (newValue == 0) {
                                                          _editDialog(index);
                                                        }
                                                      },
                                                      child: Icon(Icons.menu),
                                                      itemBuilder: (context) =>
                                                          [
                                                            PopupMenuItem(
                                                              child:
                                                                  Text("Edit"),
                                                              value: 0,
                                                            ),
                                                            PopupMenuItem(
                                                              child: Text(
                                                                  "Delete"),
                                                              value: 1,
                                                            ),
                                                          ]),
                                                ))
                                          ],
                                        )),
                                        GestureDetector(
                                          onTap: () => _showPost(index),
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            alignment: Alignment.centerLeft,
                                            child: Text(checkPostLen(
                                                _feedList[index]
                                                    ['desc_review'])),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          child: CachedNetworkImage(
                                            height: 300,
                                            width: 300,
                                            imageUrl:
                                                "${_feedList[index]['img_review']}",
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                new Transform.scale(
                                                    scale: 0.5,
                                                    child:
                                                        CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new Icon(
                                              Icons.broken_image,
                                              size: screenWidth / 4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })),
                  ],
                )),
              )
      ]),
    );
  }

  String checkPostLen(String desc) {
    if (desc.length < 35) {
      return desc;
    } else {
      return desc.substring(0, 35) + " ...read more";
    }
  }

  _loadPost() {
    http.post(
        Uri.parse(
            "https://nurulida1.com/272834/bergedillovers/php/loadpost.php"),
        body: {}).then((response) {
      print(response.body);
      if (response.body == "nodata") {
        print("Sorry. no review available");
        return;
      } else {
        var jsondata = json.decode(response.body);
        _feedList = jsondata["review"];
        setState(() {});
        print(_feedList);
      }
      setState(() {});
    });
  }

  void _deleteDialog(int index) {
    print(_feedList[index]['id_review']);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Delete this review?"),
            content: Text("Confirm?"),
            actions: [
              TextButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _deletePost(index);
                },
              ),
              TextButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  Future<void> _deletePost(int index) async {
    pr = ProgressDialog(context);
    pr.style(
      message: 'Deleting post...',
      borderRadius: 5.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    await pr.show();

    http.post(
        Uri.parse(
            "https://nurulida1.com/272834/bergedillovers/php/deletepost.php"),
        body: {
          "id_review": _feedList[index]['id_review'],
        }).then((response) {
      if (response.body == "success") {
        pr.hide().then((isHidden) {
          print(isHidden);
        });
        Fluttertoast.showToast(
            msg: "Delete Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.deepPurple,
            textColor: Colors.white,
            fontSize: 16.0);
        _loadPost();
      } else {
        Fluttertoast.showToast(
            msg: "Delete Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.deepPurple,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  void _editDialog(int index) {
    TextEditingController editdescCtrl = new TextEditingController();
    editdescCtrl.text = _feedList[index]['desc_review'];
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Edit Your Review ',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        content: Container(
          height: screenHeight / 3,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: editdescCtrl,
                  minLines: 5,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'description',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                ),
                Container(
                  width: screenWidth,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple, // background
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      String newreview = editdescCtrl.text.toString();
                      _updatePost(index, newreview);
                    },
                    child: Text("Update"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showPost(int index) {
    print(_feedList[index]['id_review']);
    print("HELLO");
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: SingleChildScrollView(
          child: Container(
            height: screenHeight / 3,
            child: Column(
              children: [
                Expanded(flex: 1, child: Text("Review")),
                Expanded(
                    flex: 7,
                    child: SingleChildScrollView(
                        child: Text(_feedList[index]['desc_review']))),
                Expanded(
                    flex: 2,
                    child: Container(
                      width: screenWidth,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepPurple, // background
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Close"),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _updatePost(int index, String newreview) async {
    pr = ProgressDialog(context);
    pr.style(
      message: 'Updating review...',
      borderRadius: 5.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    await pr.show();
    http.post(
        Uri.parse(
            "https://nurulida1.com/272834/bergedillovers/php/updatepost.php"),
        body: {
          "id_review": _feedList[index]['id_review'],
          "newreview": newreview,
        }).then((response) {
      if (response.body == "success") {
        pr.hide().then((isHidden) {
          print(isHidden);
        });
        Fluttertoast.showToast(
            msg: " Update Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.deepPurple,
            textColor: Colors.white,
            fontSize: 16.0);
        _loadPost()();
      } else {
        Fluttertoast.showToast(
            msg: "Update Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.deepPurple,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
}
