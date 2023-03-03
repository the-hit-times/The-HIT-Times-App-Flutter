import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:the_hit_times_app/contact_us.dart';
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

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showMyDialog(message);
    });

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

  Future<void> _showMyDialog(RemoteMessage message) async {
    String? title = message.notification?.title;
    String? body = message.notification?.body;
    String? imageUri = message.notification?.android?.imageUrl;
    // String imageUri = "https://scontent-del1-1.cdninstagram.com/v/t51.2885-15/333940738_737738278003133_5896829832535104130_n.webp?stp=dst-jpg_e35_s480x480&_nc_ht=scontent-del1-1.cdninstagram.com&_nc_cat=105&_nc_ohc=kC3wbot7Q0UAX9I-zZs&edm=ACWDqb8BAAAA&ccb=7-5&ig_cache_key=MzA0OTcwODc5MDc2NjUzMzc3NA%3D%3D.2-ccb7-5&oh=00_AfC89wZFLcT9CQKRFipzWmAL9F3k7iLhAKmN4A2bhsu21w&oe=6407AFDA&_nc_sid=1527a3";
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title.toString()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.network(imageUri!),
                ),
                SizedBox(height: 4),
                Text(body.toString()),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Got it!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
