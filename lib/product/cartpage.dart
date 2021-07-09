import 'dart:convert';
import 'package:bergedil_lovers/product/checkoutcart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../product.dart';

class CartPage extends StatefulWidget {
  final String email;
  final Product product;
  const CartPage({Key key, this.email, this.product}) : super(key: key);
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String email;
  List _cartList = [];
  double _totalAmt = 0.0;
  double screenHeight, screenWidth;
  final df = new DateFormat('dd-MM-yyyy hh:mm a');
  @override
  void initState() {
    super.initState();
    _loadMyCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Cart'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Column(children: [
          if (_cartList.isEmpty)
            Flexible(child: Center(child: Text("No items in your cart.")))
          else
            Flexible(
                child: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 9,
                      child: ListView.builder(
                        itemCount: _cartList.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return Padding(
                              padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                              child: Card(
                                  child: SingleChildScrollView(
                                      child: Column(children: [
                                Container(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                    flex: 6,
                                  child: Column(
                              crossAxisAlignment:CrossAxisAlignment.center,
                                children: [
                                SizedBox(height: 30, ),
                                Container(child: CachedNetworkImage(
                                height: 200,
                                width: 200,
                                imageUrl:"${_cartList[index]['picture']}",
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                new Transform.scale(
                                scale: 0.5,
                                child:CircularProgressIndicator()),
                                errorWidget: (context, url, error) => new Icon(Icons.broken_image,
                                size: screenWidth / 4,
                                                ),
                                              ),
                                            ),
                                Text(_cartList[index]['prname'],
                                style: TextStyle(fontSize: 26,
                                fontWeight: FontWeight.bold),
                                            ),
                                Text('Price (RM): ${_cartList[index]['prprice']}',
                                  style: TextStyle(fontSize: 18)),
                                 Row(mainAxisAlignment:
                                 MainAxisAlignment.center,
                                children: [IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {modifyQty( index, "removecart");
                                  },
                                 ),
                                Text(_cartList[index] ['cart_qty']),
                                IconButton(icon: Icon(Icons.add),
                                onPressed: () {modifyQty(index, "addcart");
                              }),
                            ],
                          ),
                          Text("RM" +(int.parse(_cartList[index]['cart_qty']) *
                          double.parse( _cartList[index] ['prprice'])).toStringAsFixed(2),
                          )
                         ],
                        )),
                        Expanded(child: Column(
                           children: [
                          IconButton(icon: Icon(Icons.delete),
                            onPressed: () { _delCart(index);
                             }),
                                      ],
                                    ))
                                  ],
                                )),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(height: 5),
                                      Divider(
                                        color: Colors.red,
                                        height: 1,
                                        thickness: 10.0,
                                      ),
                         Text("Your total is RM " + _totalAmt.toStringAsFixed(2),
                        style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(onPressed: () { _payment(); },
                         child: Text("CHECKOUT"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.deepPurple),
                                      )
                                    ],
                                  ),
                                ),
                              ]))));
                        },
                      ),
                    ),
                  ]),
            )),
        ]));
  }

  _loadMyCart() {
    http.post(
        Uri.parse(
            "https://nurulida1.com/272834/bergedillovers/php/load_cart.php"),
        body: {"email": widget.email}).then((response) {
      print(response.body);
      if (response.body == "failed") {
        print('No items in cart.');
        _cartList = [];
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(jsondata);
        _cartList = jsondata["cart"];
        _totalAmt = 0.0;
        for (int i = 0; i < _cartList.length; i++) {
          _totalAmt = _totalAmt +
              double.parse(_cartList[i]['prprice']) *
                  int.parse(_cartList[i]['cart_qty']);
        }
      }
      setState(() {});
    });
  }

  Future<void> modifyQty(int index, String s) async {
    await Future.delayed(Duration(seconds: 1));
      http.post(
          Uri.parse(
              "https://nurulida1.com/272834/bergedillovers/php/updatecart.php"),
          body: {
            "email": widget.email,
            "op": s,
            "prid": _cartList[index]['prid'],
            "cart_qty": _cartList[index]['cart_qty']
          }).then((response) {
        print(response.body);
        if (response.body == "success") {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          _loadMyCart();
        } else {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    }
  

  void _delCart(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete item in cart?"),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Color(0xFF6A1B9A)),
                  child: Text("Proceed", style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    _delItemCart(index);
                  }),
            ],
          );
        });
  }

  Future<void> _delItemCart(int index) async {
    await Future.delayed(Duration(seconds: 1));
    http.post(
        Uri.parse(
            "https://nurulida1.com/272834/bergedillovers/php/deletecart.php"),
        body: {
          "email": widget.email,
          "prid": _cartList[index]['prid']
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.deepPurple,
            textColor: Colors.black,
            fontSize: 16.0);
        _loadMyCart();
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.deepPurple,
            textColor: Colors.black,
            fontSize: 16.0);
      }
    });
  }

  void _payment() {
    if (_totalAmt == 0.0) {
      Fluttertoast.showToast(
          msg: "Amount not payable",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.deepPurple,
          textColor: Colors.black,
          fontSize: 16.0);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirm to proceed with checkout?"),
              actions: [
                TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Color(0xFF6A1B9A)),
                    child:
                        Text("Proceed", style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CheckOutCart(
                            email: widget.email,
                            total: _totalAmt,
                          ),
                        ),
                      );
                    }),
                TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Color(0xFF6A1B9A)),
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            );
          });
    }
  }
}
