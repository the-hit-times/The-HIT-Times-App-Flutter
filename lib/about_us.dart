import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  final String about='Founded in the year of 2013, The HIT Times is only the second student run tabloid in the Eastern zone of India. A progressive induction into a world full of semesters, assignments, placements, and an unending voyage through the premises of Haldia Institute of Technology, we aim at being your eyes and ears on the campus. Hailing as the official media group of the Institution, we are set to bring forth the events and the affairs while providing an impulse to your conscience.  With technology running the game heavily these days, this Android app is a part of our expansion to newer, tech-friendly avenues. So, stay tuned and never miss out on a notification.';

  @override
  Widget build(BuildContext context) {
    final alucard = Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircleAvatar(
          radius: 75.0,
          backgroundColor: Colors.transparent,
          backgroundImage: ExactAssetImage('assets/images/about_us2.png'),
        ),
      ),
    );

    final heading = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        ' About Us ',
        style: TextStyle(fontSize: 28.0, color: Colors.white, fontFamily: "Exo",decoration: TextDecoration.underline),
      ),
    );

    final about_us = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        about,
        style: TextStyle(fontSize: 17.0, color: Colors.white, fontFamily: "Cambo"),
        textAlign: TextAlign.center,
      ),
    );

   final policy = Container(
      child: InkWell(
        onTap: (){
          launch(
              'https://sites.google.com/view/thtkhabri',
            forceWebView: true,
            //enableJavaScript: true,
            forceSafariVC: true
          );
        },
        child: Text(
          'Click here to view Privacy Policy',
          style: TextStyle(fontSize: 20.0, color: Colors.white, fontFamily: 'Anson' ,decoration: TextDecoration.underline),
        ),
      ),
    );

    final body = Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
    gradient: LinearGradient(colors: [
      Colors.black,
      Colors.purple,
      Colors.pinkAccent,
      Colors.black,
    ]),
      ),
      child: Column(
    children: <Widget>[
      alucard, heading,
      Divider(
        color: Colors.amber,
        height: 5.0,
      ),
      Expanded(
        flex: 1,
        child: SingleChildScrollView(
            child: about_us,
        ),
      ),
      Divider(
        color: Colors.amber,
        height: 12.0,
      ),
      policy
    ],
      ),
    );

    return Scaffold(
      body: body,
    );
  }
}