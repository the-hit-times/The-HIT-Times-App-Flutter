import 'package:flutter/material.dart';
import 'package:the_hit_times_app/card_ui.dart';
import 'package:the_hit_times_app/database_helper.dart';
import 'package:the_hit_times_app/display.dart';
import 'package:the_hit_times_app/models/notification.dart' as nf;

class DispNoti extends StatefulWidget {
  DispNoti();

  @override
  // TODO: implement createState
  Notify createState() => Notify();
}

class Notify extends State<DispNoti> {
  List data = List.empty();
  List<nf.Notification> notes = List.empty();
  int nfLength = 0;
  void getData() async {
    notes = await NotificationDatabase.instance.readAllNotifications();
    nfLength = notes.length;
    data = notes;
  }

  Future<String> getSWData() async {
    notes = await NotificationDatabase.instance.readAllNotifications();
    nfLength = notes.length;
    data = notes;

    setState(() {
      getData();
      print("notes.length");
      print(notes.length);
      // var resBody = json.decode(res.body);
      // allPosts = PostList.fromJson(resBody);
      // allPosts.posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      // data = resBody;
      // allPosts.posts.removeWhere((item) =>
      //     item.dropdown == '05' ||
      //     item.dropdown == '04' ||
      //     item.dropdown == '03' ||
      //     item.dropdown == '02' ||
      //     item.dropdown == '01' ||
      //     item.dropdown == '00');
      // data = allPosts.posts;
      // AppXLength = allPosts.posts.length;
    });

    // print("------------------------------------------");
    // //print(weeklies.length);
    // print("------------------------------------------");
    // print(allPosts.posts.length);
    return "Success";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getSWData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
        child: nfLength != 0
            ? ListView.builder(
                itemCount: nfLength == 0 ? 0 : nfLength,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => DisplayPost(
                            pIndex: index,
                            title: notes[index].title,
                            body: notes[index].description,
                            imgUrl: notes[index].imageUrl,
                            date: notes[index].createdTime.toIso8601String(),
                            description: notes[index].description,
                            category: 0),
                      ));
                    },
                    child: NotiCard(
                      title: notes[index].title,
                      body: notes[index].description,
                      imgUrl: notes[index].imageUrl,
                      date: notes[index].createdTime.toIso8601String(),
                      description: notes[index].description,
                    ),
                  );
                },
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications, color: Colors.grey, size: 60.0),
                    Text(
                      "No Notification found",
                      style: TextStyle(fontSize: 24.0, color: Colors.grey),
                    ),
                  ],
                ),
              ),
      ),
    ]);
  }
}
