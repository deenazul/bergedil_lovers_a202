import 'dart:convert';
import 'package:bergedil_lovers/product.dart';
import 'package:bergedil_lovers/searchscreen.dart';
import 'package:bergedil_lovers/splashscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bergedil_lovers/newproduct.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bergedil Lovers Shop',
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  final Product product;
  const MainScreen({Key key, this.product}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ProgressDialog pr;
  double screenHeight, screenWidth;
  List _productList;

  final df = new DateFormat('dd-MM-yyyy hh:mm a');

  @override
  void initState() {
    super.initState();
    _testasync();
    //_searchProduct();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _searchCtrl = new TextEditingController();

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
          _productList == null
              ? Flexible(child: Center(child: Text("No products")))
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
                                onPressed: () => _searchProduct(),
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
                            itemCount: _productList.length,
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
                                                        "${_productList[index]['picture']}",
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
                                                  _productList[index]['prname'],
                                                  style: TextStyle(
                                                      fontSize: 26,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(df.format(DateTime.parse(
                                                    _productList[index]
                                                        ['datecreated']))),
                                                Text(
                                                    'Price (RM): ${_productList[index]['prprice']}',
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                                Text(
                                                    'Quantity (Available): ${_productList[index]['prqty']}',
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

  _loadProduct(String prname) {
    http.post(
        Uri.parse(
            "https://nurulida1.com/272834/bergedillovers/php/loadproduct.php"),
        body: {}).then((response) {
      if (response.body == "nodata") {
        return;
      } else {
        var jsondata = json.decode(response.body);
        _productList = jsondata["products"];
        //if (!mounted) return;
        setState(() {});
        print(_productList);
      }
    });
  }

  _searchProduct() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => SearchScreen()));
  }

  Future<void> _testasync() async {
    _loadProduct("all");
  }
}
