import 'package:flutter/material.dart';
import 'package:the_hit_times_app/contact_us.dart';
import 'package:the_hit_times_app/news.dart';
import 'package:the_hit_times_app/smenu.dart';
import 'package:the_hit_times_app/notification.dart';
// import 'notification.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'bottom_nav_gallery.dart';
import 'globals.dart' as globals;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  int _currentIndex = 1;

  BottomNavigationBarType _type = BottomNavigationBarType.shifting;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void campusNews() {
    setState(() {
      this._currentIndex = 1;
    });
  }

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }

  void _onHorizontalDrag(DragEndDetails details) {
    if (details.primaryVelocity == 0)
      return; // user have just tapped on screen (no dragging)

    if (details.primaryVelocity!.compareTo(0) == -1) {
      print('dragged from left');
      print(_currentIndex);
      setState(() {
        if (_currentIndex < 2) {
          _currentIndex++;
          FocusScope.of(context)?.unfocus();
        }
      });
    } else {
      print('dragged from right');
      print(_currentIndex);
      setState(() {
        if (_currentIndex > 0) _currentIndex--;
        FocusScope.of(context)?.unfocus();
      });
    }
  }

  void onPageChanged(int page) {
    setState(() {
      this._currentIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The HIT Times'),
        leading: Container(
          padding: EdgeInsets.all(5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              "assets/images/logo.jpeg",
              fit: BoxFit.fill,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            tooltip: 'Notifications',
            onPressed: () {
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
          )
        ],
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) =>
            _onHorizontalDrag(details),
        child: Stack(
          children: <Widget>[
            Offstage(
              offstage: _currentIndex != 0,
              child: TickerMode(
                enabled: _currentIndex == 0,
                child: Container(child: SMenu()),
              ),
            ),
            Offstage(
              offstage: _currentIndex != 1,
              child: TickerMode(
                enabled: _currentIndex == 1,
                child: Container(child: News()),
              ),
            ),
            Offstage(
              offstage: _currentIndex != 2,
              child: TickerMode(
                enabled: _currentIndex == 2,
                child: Container(
                    /*decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        colors: [const Color(0xFFddd6f3), const Color(0xFFffffff), const Color(0xFF9bc5c3)], // whitish to gray
                        stops: [0.0,0.3,1.0],
                        tileMode: TileMode.mirror, // repeats the gradient over the canvas
                      ),
                    ),*/
                    height: MediaQuery.of(context).size.height,
                    child: ContactUs()),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Color.fromARGB(255, 7, 95, 115),
        height: 50,
        index: _currentIndex,
        items: <Widget>[
          Icon(Icons.menu, size: 30, color: Colors.white),
          Icon(Icons.newspaper, size: 30, color: Colors.white),
          Icon(Icons.mail_outline, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            FocusScope.of(context)?.unfocus();
          });
        },
      ),
    );
  }
}
