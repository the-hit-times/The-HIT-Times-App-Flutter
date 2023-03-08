import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class ContactUs extends StatefulWidget {
  @override
  ContactUsState createState() {
    return new ContactUsState();
  }
}

class ContactUsState extends State<ContactUs> {
  static const platform = MethodChannel("hit.times.com/mailer");

  final TextEditingController _name = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _roll = new TextEditingController();
  final TextEditingController _story = new TextEditingController();

  final GlobalKey<FormState> _formkey = new GlobalKey<FormState>();
  _FormData _data = new _FormData();

  bool _isDisable(){
    return false;
  }
  void submit(){
    if(_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      String mail = "${_data.name}~${_data.email}~${_data.roll}~${_data.story}";
      send(mail);
      print(mail);
      setState((){
        _name.clear();
        _email.clear();
        _roll.clear();
        _story.clear();
      });
    }
  }
  static Future<void> send(mail) async {
      try {
         await platform.invokeMethod('getMessage',<String, dynamic>{"mail": mail});
      }
      catch (e) {
        print(e);
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
                    onPanDown: (DragDownDetails details){print('Hello');},
                    child: Container(
                      width: screenSize.width,
                      decoration: new BoxDecoration(
                        boxShadow: [new BoxShadow(
                            color: Colors.black,
                            blurRadius: 5.0,)],
                        color: Colors.white,
                        borderRadius: BorderRadius.only( bottomLeft:Radius.circular(70.0),bottomRight: Radius.circular(70.0) ),
                      ),
                      padding: EdgeInsets.only(left: 5.0,right: 5.0,top: 5.0,bottom: 5.0),
                      child: Text(
                          "Got Something interesting to share."
                              "\nWrite to us.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
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
              Padding(
                  padding: EdgeInsets.all(7.0)
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5.0),
                    hintText: "Name *",
                  ),
                  validator: (val) => val!.isEmpty ? 'Need to know you Mr.Anonymous' : null,
                  onSaved: (String? value) {
                    this._data.name = value!;
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.mail),
                title: TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5.0),
                    hintText: "Email *",
                  ),
                  validator: (val) => !val!.contains('@') ? 'Not a valid email.' : null,
                  onSaved: (String? value){
                    this._data.email = value!;
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.child_care),
                title: TextFormField(
                  controller: _roll,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5.0),
                    hintText: "Roll Number *",
                  ),
                  validator: validateRoll,
                  onSaved: (String? value){
                    this._data.roll = value!;
                  },
                ),
              ),
              const SizedBox(height: 5.0),
              Padding(
                padding: EdgeInsets.all(10.0),
                child:TextFormField(
                  controller: _story,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Tell us about the happening',
                    helperText: 'Keep it short, we will contact for the rest.',
                    labelText: 'Story',
                ),
                maxLines: 3,
                validator: (val) => val!.isEmpty ? 'Fill this please' : null,
                onSaved: (String? value){
                  this._data.story = value!;
                },
              ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
              ElevatedButton(
                onPressed: _isDisable()? null : this.submit,
                child: Icon(
                    Icons.send,
                    color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
              ),
              const Divider(
                height: 1.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Version: 2.0\n"
                        "\u00a9 THE HIT TIMES \n"
                        "Coders Team",
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }

  String? validateRoll(String? value) {
    RegExp regex = RegExp(r'^(\d{2})(\/)([A-Z]{2,3})(\/)(\d{1,3})$',caseSensitive: false);
    if (!regex.hasMatch(value!)) {
      return 'Enter a valid Roll';
    } else {
      return null;
    }
  }
}
class _FormData{
  String name = '';
  String email = '';
  String roll = '';
  String story = '';
}