import 'package:flutter/material.dart';
import 'package:the_hit_times_app/card_ui.dart';
import 'package:the_hit_times_app/database_helper.dart';
import 'package:the_hit_times_app/display.dart';
import 'package:the_hit_times_app/models/notification.dart' as nf;
import 'package:the_hit_times_app/notidisplay.dart';
import 'package:the_hit_times_app/util/cache_manager.dart';

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

  Future<void> getData() async {
    notes = await NotificationDatabase.instance.readAllNotifications();
    notes.sort((a, b) {
      return b.createdTime.compareTo(a.createdTime);
    });
    nfLength = notes.length;
    data = notes;
    setState(() {
      print("notes.length");
      print(notes.length);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: getData,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Notifications"),
            centerTitle: true,
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            actions: [
              IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.clear_all),
                tooltip: 'Clear All',
                onPressed: () async {
                  // clear notfication data base and rebuild this page
                  await NotificationDatabase.instance.deleteAllNotifications();
                  setState(() {
                    nfLength = 0;
                  });
                },
              )
            ],
          ),
          body: Column(children: <Widget>[
            Expanded(
              child: nfLength != 0
                  ? ListView.builder(
                      itemCount: nfLength == 0 ? 0 : nfLength,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: ()  {
                            if (notes[index].postId != null && notes[index].postId! != "") {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => NotificationDisplayWeb(postId: notes[index].postId!,)
                                ),
                              );
                            } else {
                              Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => Notidisplay(
                                    pIndex: index,
                                    title: notes[index].title,
                                    body: notes[index].description,
                                    imgUrl: notes[index].imageUrl,
                                    date: notes[index]
                                        .createdTime
                                        .toIso8601String(),
                                    description: notes[index].description,
                                    category: 0),
                              )
                              );
                            }
                          },
                          child: NotiCard(
                            title: notes[index].title,
                            body: notes[index].description,
                            imgUrl: notes[index].imageUrl,
                            date: notes[index].createdTime.toIso8601String(),
                            description: notes[index].description,
                            onClear: () {
                              setState(() {
                                NotificationDatabase.instance
                                    .delete(notes[index].id!);
                                notes.removeAt(index);
                                nfLength = notes.length;
                              });
                            },
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications,
                              color: Colors.grey, size: 60.0),
                          Text(
                            "No Notification found",
                            style:
                                TextStyle(fontSize: 24.0, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
            ),
          ]),
        ));
  }
}
