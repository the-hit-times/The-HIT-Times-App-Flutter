import 'dart:convert';

// import 'notification.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:the_hit_times_app/bookmark.dart';
import 'package:the_hit_times_app/contact_us.dart';
import 'package:the_hit_times_app/features/live/match_history.dart';
import 'package:the_hit_times_app/globals.dart';
import 'package:the_hit_times_app/news.dart';
import 'package:the_hit_times_app/smenu.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  int _currentIndex = 1;
  int matchCount = 0;

  final BottomNavigationBarType _type = BottomNavigationBarType.shifting;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    loadLiveMatchCount();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void campusNews() {
    setState(() {
      _currentIndex = 1;
    });
  }

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }

  void loadLiveMatchCount() async {
    print("Loading live match count");
    String url = "${Constants.BASE_URL}/live/count";
    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    var count = jsonDecode(response.body)["count"];
    print("Live match count: $count");
    setState(() {
      matchCount = count;
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
          FocusScope.of(context).unfocus();
        }
      });
    } else {
      print('dragged from right');
      print(_currentIndex);
      setState(() {
        if (_currentIndex > 0) _currentIndex--;
        FocusScope.of(context).unfocus();
      });
    }
  }

  void onPageChanged(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('The HIT Times'),
        leading: Container(
          padding: const EdgeInsets.all(5),
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
            padding: EdgeInsets.zero,
            icon: matchCount > 0
                ? Badge(
                    label: Text("$matchCount"),
                    child: const Icon(Icons.live_tv),
                  )
                : const Icon(Icons.live_tv),
            tooltip: 'Live',
            onPressed: () async {
              Navigator.of(context)
                  .pushNamed(MatchHistoryScreen.ROUTE_NAME)
                  .then((value) => {setState(() {})});
            },
          ),
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.favorite),
            tooltip: 'Favourites',
            onPressed: () async {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (BuildContext context) => Container(
                          // color: Colors.amber
                          child: const BookMarkPage()) /*Placeholder()*/
                      ))
                  .then((value) => {setState(() {})});
            },
          )
        ],
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) =>
            _onHorizontalDrag(details),
        child: Stack(
          // children: [
          //   _currentIndex == 0 ? Container(child: SMenu()) : Container(),
          //   _currentIndex == 1 ? Container(child: News()) : Container(),
          //   _currentIndex == 2 ? Container(child: ContactUs()) : Container()
          // ],
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
                child: Container(
                  child: News(),
                ),
              ),
            ),
            Offstage(
              offstage: _currentIndex != 2,
              child: TickerMode(
                enabled: _currentIndex == 2,
                child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ContactUs()),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: const Color.fromARGB(255, 7, 95, 115),
        height: 50,
        index: _currentIndex,
        items: const <Widget>[
          Icon(Icons.menu, size: 30, color: Colors.white),
          Icon(Icons.newspaper, size: 30, color: Colors.white),
          Icon(Icons.mail_outline, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            FocusScope.of(context).unfocus();
          });
        },
      ),
    );
  }
}
