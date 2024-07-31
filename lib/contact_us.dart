import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:emailjs/emailjs.dart';

class ContactUs extends StatefulWidget {
  @override
  ContactUsState createState() {
    return new ContactUsState();
  }
}

class ContactUsState extends State<ContactUs> {
  final TextEditingController _name = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _roll = new TextEditingController();
  final TextEditingController _story = new TextEditingController();

  final GlobalKey<FormState> _formkey = new GlobalKey<FormState>();
  _FormData _data = new _FormData();

  bool _isDisable() {
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("contactus...");
  }

  void submit() {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      send(_data.name, _data.email, _data.roll, _data.story);
      setState(() {
        _name.clear();
        _email.clear();
        _roll.clear();
        _story.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: const Text('Thanks for contacting us 😊😊'),
      ));
    }
  }

  static Future<void> send(name, email, roll, story) async {
    Map<String, dynamic> templateParams = {
      "from_name": name,
      "roll": roll,
      "reply_to": email,
      "message": story
    };

    try {
      final res = await EmailJS.send(
        'service_35n1vwe',
        'template_ahymwe4',
        templateParams,
        const Options(
          publicKey: 'PnEhm9lCAPvBW30tp',
          privateKey: 'RC2k9fbunLJtJTBMEqnHi',
        ),
      );
      print(res.text);
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Form(
        key: this._formkey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    width: screenSize.width - 30,
                    decoration: new BoxDecoration(
                      color: Color.fromARGB(255, 10, 66, 79),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50)),
                    ),
                    padding: EdgeInsets.only(
                        left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                    child: Text(
                      "Got Something interesting to share."
                      "\nWrite to us.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        height: 1.0,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Anson",
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(7.0)),
            ListTile(
              title: TextFormField(
                keyboardType: TextInputType.name,
                controller: _name,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true, //<-- SEE HERE
                  fillColor: Color.fromARGB(255, 179, 244, 244),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)),
                  hintText: "Enter name",
                  prefixIcon: Align(
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 7, 95, 115),
                    ),
                  ),
                ),
                validator: (val) =>
                    val!.isEmpty ? 'Need to know you Mr.Anonymous' : null,
                onSaved: (String? value) {
                  this._data.name = value!;
                },
              ),
            ),
            ListTile(
              title: TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true, //<-- SEE HERE
                  fillColor: Color.fromARGB(255, 179, 244, 244),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)),
                  hintText: "Enter email",
                  prefixIcon: Align(
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: Icon(
                      Icons.email,
                      color: Color.fromARGB(255, 7, 95, 115),
                    ),
                  ),
                ),
                validator: (val) =>
                    !val!.contains('@') ? 'Not a valid email.' : null,
                onSaved: (String? value) {
                  this._data.email = value!;
                },
              ),
            ),
            ListTile(
              title: TextFormField(
                controller: _roll,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true, //<-- SEE HERE
                  fillColor: Color.fromARGB(255, 179, 244, 244),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)),
                  hintText: "Enter roll",
                  prefixIcon: Align(
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: Icon(
                      Icons.edit,
                      color: Color.fromARGB(255, 7, 95, 115),
                    ),
                  ),
                ),
                onSaved: (String? value) {
                  this._data.roll = value!;
                },
                validator: (val) =>
                    val!.isEmpty ? 'Enter valid Roll number' : null,
              ),
            ),
            const SizedBox(height: 5.0),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _story,
                decoration: InputDecoration(
                    filled: true, //<-- SEE HERE
                    fillColor: Color.fromARGB(255, 179, 244, 244),
                    hintText: "Tell us about the happening",
                    helperText: "Keep it short, we will contact for the rest.",
                    helperStyle:
                        TextStyle(color: Color.fromARGB(255, 6, 186, 227))),
                maxLines: 4,
                validator: (val) => val!.isEmpty ? 'Fill this please' : null,
                onSaved: (String? value) {
                  this._data.story = value!;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(), backgroundColor: Color.fromARGB(255, 4, 114, 138),
                  padding: EdgeInsets.all(5),
                  minimumSize: const Size.fromHeight(50), // NEW
                ),
                onPressed: _isDisable() ? null : this.submit,
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            const Divider(
              height: 1.0,
            )
          ],
        ),
      ),
    );
  }
}

class _FormData {
  String name = '';
  String email = '';
  String roll = '';
  String story = '';
}
