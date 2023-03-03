import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:the_hit_times_app/contact_us.dart';
import 'package:the_hit_times_app/notificationservice/ocal_notification_service.dart';
import 'package:the_hit_times_app/news.dart';
import 'package:the_hit_times_app/smenu.dart';
// import 'notification.dart';
import 'bottom_nav_gallery.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  int _currentIndex = 1;

  BottomNavigationBarType _type = BottomNavigationBarType.shifting;
  late List<NavigationIconView> _navigationViews;
  late PageController _pageController;
  String deviceTokenToSendPushNotification = " ";
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );

    _navigationViews = <NavigationIconView>[
      NavigationIconView(
        icon: IconTheme(
            data: IconThemeData(color: Color(0xFFdff9fb)),
            child: Icon(Icons.menu)),
        title: 'Menu',
        color: Color(0xFF000000),
        vsync: this,
      ),
      NavigationIconView(
        icon: IconTheme(
            data: IconThemeData(color: Color(0xFFdff9fb)),
            child: Icon(Icons.assignment)),
        title: 'News',
        color: Color(0xFF000000),
        vsync: this,
      ),
      NavigationIconView(
        icon: IconTheme(
            data: IconThemeData(color: Color(0xFFdff9fb)),
            child: Icon(Icons.info_outline)),
        title: 'Contact Us',
        color: Color(0xFF000000),
        vsync: this,
      ),
    ];

    for (NavigationIconView view in _navigationViews)
      view.controller.addListener(_rebuild);

    _navigationViews[_currentIndex].controller.value = 1.0;

    _pageController = PageController(initialPage: _currentIndex);
  }

  Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    deviceTokenToSendPushNotification = token.toString();
    print("Token Value $deviceTokenToSendPushNotification");
  }

  @override
  void dispose() {
    for (NavigationIconView view in _navigationViews) view.controller.dispose();
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

  void onPageChanged(int page) {
    setState(() {
      this._currentIndex = page;
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
        }
      });
    } else {
      print('dragged from right');
      print(_currentIndex);
      setState(() {
        if (_currentIndex > 0) _currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getDeviceTokenToSendNotification();
    final BottomNavigationBar botNavBar = BottomNavigationBar(
      items: _navigationViews
          .map((NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      type: _type,
      onTap: (int index) {
        setState(() {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
        });
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('The HIT Times'),
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
      bottomNavigationBar: botNavBar,
    );
  }
}
