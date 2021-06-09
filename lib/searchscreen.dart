import 'dart:convert';
import 'package:bergedil_lovers/main.dart';
import 'package:bergedil_lovers/product.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bergedil_lovers/newproduct.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;


class SearchScreen extends StatefulWidget {
  final Product product;
  const SearchScreen({Key key, this.product}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ProgressDialog pr;
  double screenHeight, screenWidth;
  List _searchList;
  final df = new DateFormat('dd-MM-yyyy hh:mm a');
TextEditingController _searchCtrl = new TextEditingController();
    

  @override
  void initState() {
    super.initState();
    //_searchProduct(search);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    String search = _searchCtrl.toString();

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: onPress,
          child: Icon(Icons.add),
          backgroundColor: Colors.deepPurple,
        ),
        appBar: AppBar(
          title: Text('BERGEDIL LOVERS SHOP'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Column(children: [
          _searchList == null
              ? Flexible(
                  child:
                      Center(child: Text("Product searched is unavailable.")))
              : Flexible(
                  child: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 50,
                          width: screenWidth / 1.5,
                          padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 18),
                            controller: _searchCtrl,
                            decoration: InputDecoration(
                              hintText: "Search product",
                              suffixIcon: IconButton(
                                onPressed: () => _searchProduct(search),
                                icon: Icon(Icons.search),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                      BorderSide(color: Colors.deepPurple)),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 9,
                          child: ListView.builder(
                            itemCount: _searchList.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return Padding(
                                  padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                  child: Card(
                                      child: SingleChildScrollView(
                                          child: Column(children: [
                                    Container(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            flex: 6,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                Container(
                                                  child: CachedNetworkImage(
                                                    height: 300,
                                                    width: 300,
                                                    imageUrl:
                                                        "${_searchList[index]['picture']}",
                                                    fit: BoxFit.cover,
                                                    placeholder: (context,
                                                            url) =>
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
                                                Text(
                                                  _searchList[index]['prname'],
                                                  style: TextStyle(
                                                      fontSize: 26,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(df.format(DateTime.parse(
                                                    _searchList[index]
                                                        ['datecreated']))),
                                                Text(
                                                    'Price (RM): ${_searchList[index]['prprice']}',
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                                Text(
                                                    'Quantity (Available): ${_searchList[index]['prqty']}',
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                              ],
                                            )),
                                      ],
                                    ))
                                  ]))));
                            },
                          ),
                        ),
                      ]),
                ))
        ]));
  }

  void onPress() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => NewProduct()));
  }

  _searchProduct(String search) {
    search = _searchCtrl.toString();
    http.post(
        Uri.parse(
            "https://nurulida1.com/272834/bergedillovers/php/searchproduct.php"),
        body: {
          "prname": search,
        }).then((response) {
      if (response.body == "nodata") {
        print('Product searched is unavailable.');
        return;
      } else {
        var jsondata = json.decode(response.body);
        _searchList = jsondata["products"];
        //if (!mounted) return;
        setState(() {});
        print(_searchList);
      }
    });
  }
}
