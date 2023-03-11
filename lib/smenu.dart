import 'package:flutter/material.dart';
import 'package:the_hit_times_app/notification.dart';
import 'package:the_hit_times_app/read_issue.dart';
import 'weeklie.dart';
import 'about_us.dart';
import 'globals.dart' as globals;

// import 'notification.dart';

class SMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        fourGrid(),
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 8.0, bottom: 8.0),
          height: 200.0,
          width: double.infinity,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Scaffold(
                      appBar: AppBar(
                        title: Text("About Us"),
                        centerTitle: true,
                        iconTheme: IconThemeData(
                          color: Colors.white, //change your color here
                        ),
                      ),
                      body: AboutUs()) /*Placeholder()*/
                  ));
            },
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/about_us3.png'),
                        fit: BoxFit.fill,
                        colorFilter: ColorFilter.mode(
                          Colors.black26,
                          BlendMode.darken,
                        ),
                      ),
                      color: Colors.amber),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: bottomTitle(caption: 'About Us'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class bottomTitle extends StatelessWidget {
  bottomTitle({required this.caption});
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      width: double.infinity,
      margin: EdgeInsets.all(0.0),
      //color: Colors.black12,
      child: Container(
        margin: EdgeInsets.only(left: 10.0),
        child: caption.length < 13
            ? Text(
                caption,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 1,
              )
            : Text(
                caption,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 1,
              ),
      ),
    );
  }
}

class fourGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              height: MediaQuery.of(context).size.width * 0.5,
              width: MediaQuery.of(context).size.width * 0.47,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Container(
                              // color: Colors.amber
                              child: DispNoti(
                            date: globals.noti_date,
                            body: globals.noti_body,
                            title: globals.noti_title,
                          )) /*Placeholder()*/
                      ));
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        image: DecorationImage(
                          image: ExactAssetImage(
                              'assets/images/notifications.png'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black26, BlendMode.darken),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: bottomTitle(caption: 'Notifications')),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              height: MediaQuery.of(context).size.width * 0.5,
              width: MediaQuery.of(context).size.width * 0.47,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Scaffold(
                            appBar: AppBar(
                              title: Text("App Exclusive"),
                              centerTitle: true,
                              iconTheme: IconThemeData(
                                color: Colors.white, //change your color here
                              ),
                            ),
                            body: AppX(),
                          )));
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        image: DecorationImage(
                          image: ExactAssetImage('assets/images/exclusive.png'),
                          fit: BoxFit.fill,
                          alignment: Alignment.center,
                          colorFilter: ColorFilter.mode(
                              Colors.black26, BlendMode.darken),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: bottomTitle(caption: 'App Exclusive')),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              height: MediaQuery.of(context).size.width * 0.5,
              width: MediaQuery.of(context).size.width * 0.47,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Scaffold(
                          appBar: AppBar(
                            title: Text("Weeklies"),
                            centerTitle: true,
                            iconTheme: IconThemeData(
                              color: Colors.white, //change your color here
                            ),
                          ),
                          body: Weeklies()) /*Placeholder()*/
                      ));
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        image: DecorationImage(
                          image: ExactAssetImage('assets/images/weeklies.jpeg'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black26, BlendMode.darken),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: bottomTitle(caption: 'Weeklies')),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              height: MediaQuery.of(context).size.width * 0.5,
              width: MediaQuery.of(context).size.width * 0.47,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => ReadIssue()));
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        image: DecorationImage(
                          image:
                              ExactAssetImage('assets/images/read_issue.jpeg'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black26, BlendMode.darken),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: bottomTitle(caption: 'Read Issue')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
