import 'package:bergedil_lovers/mappage.dart';
import 'package:bergedil_lovers/payment.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../delivery.dart';
import '../user.dart';

class CheckOutCart extends StatefulWidget {
  final String email;
  final double total;

  const CheckOutCart({Key key, this.email, this.total}) : super(key: key);
  @override
  _CheckOutCartState createState() => _CheckOutCartState();
}

class _CheckOutCartState extends State<CheckOutCart> {
  ProgressDialog pr;
  String name = "Click to set";
  String phone = "Click to set";
  TextEditingController nameCtrl = new TextEditingController();
  TextEditingController contactCtrl = new TextEditingController();
  TextEditingController locationCtrl = new TextEditingController();
  String address = "";
  double screenHeight, screenWidth;
  SharedPreferences prefs;
  final df = new DateFormat('dd-MM-yyyy hh:mm a');

 @override
  void initState() {
    super.initState();
    _loadPref();
  }
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Checkout'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          SizedBox(height: 15),
          Expanded(
            flex: 7,
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                Container(
                  margin: EdgeInsets.all(2),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "CUSTOMER INFORMATION DETAILS",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(flex: 3, child: Text("EMAIL:")),
                            Container(
                                height: 20,
                                child: VerticalDivider(color: Colors.grey)),
                            Expanded(
                              flex: 7,
                              child: Text(widget.email),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(flex: 3, child: Text("NAME: ")),
                            Container(
                                height: 20,
                                child: VerticalDivider(color: Colors.grey)),
                            Expanded(
                              flex: 7,
                              child: GestureDetector(
                                  onTap: () => {nameDialog()},
                                  child: Text(name)),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(flex: 3, child: Text("PHONE: ")),
                            Container(
                                height: 20,
                                child: VerticalDivider(color: Colors.grey)),
                            Expanded(
                              flex: 7,
                              child: GestureDetector(
                                  onTap: () => {phoneDialog()},
                                  child: Text(phone)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Divider(
                  color: Colors.grey,
                  height: 2,
                ),
                Container(
                  margin: EdgeInsets.all(2),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Column(
                      children: [
                        Text(
                          "FOR PICK-UP: Please pick-up at seller's house between 2P.M - 6P.M.",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  height: 2,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Text(
                          "DELIVERY ADDRESS",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                                flex: 6,
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: locationCtrl,
                                      style: TextStyle(fontSize: 15),
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Search/Enter address'),
                                      keyboardType: TextInputType.multiline,
                                      minLines: 4, 
                                      maxLines:4,
                                    ),
                                  ],
                                )),
                            Container(
                                height: 120,
                                child: VerticalDivider(color: Colors.grey)),
                            Expanded(
                                flex: 4,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 150,
                                      child: ElevatedButton(
                                        onPressed: () => {_getUserCurrentLoc()},
                                        child: Text("Location"),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.deepPurple),
                                        ),
                                      ),
                                    Divider(
                                      color: Colors.grey,
                                      height: 2,
                                    ),
                                    Container(
                                      width: 150,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          Delivery _del =await Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => MapPage(),
                                            ),
                                          );
                                          print(address);
                                          setState(() {
                                            locationCtrl.text = _del.address;
                                          });
                                        },
                                        child: Text("Map"),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.deepPurple),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  height: 2,
                ),
                SizedBox(height: 10),
                Container(
                    child: Column(
                  children: [
                    Text(
                      "TOTAL AMOUNT PAYABLE",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "RM " + widget.total.toStringAsFixed(2),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    Container(
                      width: screenWidth / 2.5,
                      child: ElevatedButton(
                        onPressed: () {
                          _paynowDialog();
                        },
                        child: Text("PAY NOW"),
                        style: ElevatedButton.styleFrom(
                         primary: Colors.deepPurple),
                      ),
                    )
                  ],
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

  void nameDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Please set your name"),
            content: new Container(
                height: 100,
                child: Column(
                  children: [
                    Text("Enter name"),
                    TextField(
                        controller: nameCtrl,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          icon: Icon(Icons.person),
                        )),
                  ],
                )),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.white, backgroundColor: Color(0xFF6A1B9A)),
                child: Text("Ok", style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  Navigator.of(context).pop();
                  name = nameCtrl.text;
                  prefs = await SharedPreferences.getInstance();
                  await prefs.setString("name", name);
                  setState(() {});
                },
              ),
            ],
          );
        });
  }

  void phoneDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Please set your phone number"),
            content: new Container(
                height: 100,
                child: Column(
                  children: [
                    Text("Enter number"),
                    TextField(
                      controller: contactCtrl,
                      decoration: InputDecoration(
                          labelText: 'Phone Number', icon: Icon(Icons.phone)),
                    ),
                  ],
                )),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.white, backgroundColor: Color(0xFF6A1B9A)),
                child: Text("Ok", style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  Navigator.of(context).pop();

                  phone = contactCtrl.text;
                  prefs = await SharedPreferences.getInstance();
                  await prefs.setString("phone", phone);
                  setState(() {});
                },
              ),
            ],
          );
        });
  }

  Future<void> _loadPref() async {
    prefs = await SharedPreferences.getInstance();
    name = prefs.getString("name") ?? 'Click to set';
    phone = prefs.getString("phone") ?? 'Click to set';
    setState(() {});
  }

  _getUserCurrentLoc() async {
    pr = ProgressDialog(context);
    pr.style(
      message: 'Searching for location...',
      borderRadius: 5.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.show();

    await _determinePosition().then((value) => {_getPlace(value)});
    setState(
      () {},
    );
  }

  void _getPlace(Position pos) async {
    List<Placemark> newPlace =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);

    Placemark placeMark = newPlace[0];
    String name = placeMark.name.toString();
    String subLocality = placeMark.subLocality.toString();
    String locality = placeMark.locality.toString();
    String administrativeArea = placeMark.administrativeArea.toString();
    String postalCode = placeMark.postalCode.toString();
    String country = placeMark.country.toString();
    address = name +
        "," +
        subLocality +
        ",\n" +
        locality +
        "," +
        postalCode +
        ",\n" +
        administrativeArea +
        "," +
        country;
    locationCtrl.text = address;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return Geolocator.getCurrentPosition();
  }

  void _paynowDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: new Text(
                'Pay RM ' + widget.total.toStringAsFixed(2) + "?",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("Yes"),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    User user = new User(
                        widget.email, phone, name, widget.total.toString());
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PayScreen(user: user,),
                      ),
                    );
                  },
                ),
                TextButton(
                    child: Text("No"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ]);
        });
  }
}
