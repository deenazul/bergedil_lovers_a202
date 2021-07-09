import 'dart:convert';
import 'package:bergedil_lovers/product/cartpage.dart';
import 'package:bergedil_lovers/product.dart';
import 'package:bergedil_lovers/product/addfeed.dart';
import 'package:bergedil_lovers/product/newproduct.dart';
import 'package:bergedil_lovers/screens/searchscreen.dart';
import 'package:bergedil_lovers/screens/splashscreen.dart';
import 'package:bergedil_lovers/screens/userfeed.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bergedil Lovers Shop',
      home: SplashScreen(),
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
  List _productList=[];
  SharedPreferences prefs;
  String email = "";
  int itemCart = 1;
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
          actions: [
            IconButton(
                icon: Icon(Icons.rate_review_outlined), onPressed: _postFeed),
            IconButton(icon: Icon(Icons.list_alt_outlined), onPressed: _toFeed),
            IconButton(
                icon: Icon(Icons.shopping_cart_outlined), onPressed: _toCart),
          ],
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
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          new Icon(
                                                        Icons.broken_image,
                                                        size: screenWidth / 4,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    _productList[index]
                                                        ['prname'],
                                                    style: TextStyle(
                                                        fontSize: 26,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(df.format(DateTime.parse(_productList[index]['datecreated']))),
                                                  Text(
                                                      'Price (RM): ${_productList[index]['prprice']}',
                                                      style: TextStyle(
                                                          fontSize: 18)),
                                                  Text(
                                                      'Quantity (Available): ${_productList[index]['prqty']}',
                                                      style: TextStyle(
                                                          fontSize: 18)),
                                                  Container(
                                                    child: ElevatedButton(
                                                      onPressed: () =>
                                                          {_addCart(index)},
                                                      child: Text(
                                                        "Add to Cart + ",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary: Colors
                                                                  .deepPurple),
                                                    ),
                                                  ),
                                                ]),
                                          ),
                                        ]))
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

  _toCart() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CartPage(email: email)));
  }

  _toFeed() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserFeed()));
  }

  _postFeed() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddFeed()));
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
        setState(() {});
        print(_productList);
      }
    });
  }

  _searchProduct() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => SearchScreen()));
  }

  Future<void> _loadPref() async {
    prefs = await SharedPreferences.getInstance();
    email = prefs.getString("email") ?? '';
    print(email);
    if (email == '') {
      _loademaildialog();
    } else {}
  }

  _addCart(int index) async {
    if (email == '') {
      _loademaildialog();
    } else {
      pr = ProgressDialog(context);
      pr.style(
        message: 'Adding to cart...',
        borderRadius: 5.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
      );
      pr = ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
      await pr.show();

      await Future.delayed(Duration(seconds: 1));
     String prid = _productList[index]['prid'];
      http.post(
          Uri.parse(
              "https://nurulida1.com/272834/bergedillovers/php/insertcart2.php"),
          body: {"email": email, "prid": prid}).then((response) {
        pr.hide().then((isHidden) {
          print(isHidden);
        });
        print(response.body);
        if (response.body == "failed") {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.deepPurple,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.deepPurple,
              textColor: Colors.white,
              fontSize: 16.0);
          _loadCart();
          Navigator.push(
              context, MaterialPageRoute(builder: (content) => CartPage()));
        }
      });
    }
  }

  void _loadCart() {
    print(email);
    http.post(
        Uri.parse(
            "https://nurulida1.com/272834/bergedillovers/php/loadcartitem.php"),
        body: {"email": email}).then((response) {
      setState(() {
        itemCart = int.parse(response.body);
        print(itemCart);
      });
    });
  }

  Future<void> _testasync() async {
    await _loadPref();
    _loadProduct("all");
    _loadCart();
  }

  void _loademaildialog() {
    TextEditingController _emailController = new TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Enter Email"),
            content: new Container(
                height: 80,
                width: 350,
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          labelText: 'Email', icon: Icon(Icons.email)),
                    ),
                  ],
                )),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.white, backgroundColor: Color(0xFF6A1B9A)),
                child: Text("Proceed", style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  print(_emailController.text);
                  String _email = _emailController.text.toString();
                  prefs = await SharedPreferences.getInstance();
                  await prefs.setString("email", _email);
                  email = _email;
                  Fluttertoast.showToast(
                      msg: "Email stored",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.deepPurple,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  Navigator.of(context).pop();
                  _toCart();
                },
              ),
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Color(0xFF6A1B9A)),
                  child: Text("Cancel", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }
}
