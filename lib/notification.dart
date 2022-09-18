import 'package:flutter/material.dart';

class DispNoti extends StatelessWidget {
  final String title,body,date;

  DispNoti({required this.title,
  required this.body, required this.date});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The HIT Times'),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.redAccent,
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    fontFamily: 'Exo',
                    color: Colors.white,
                    fontSize: 25.0
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0,30.5,0.0,0.5),
              child: Container(
                //height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                          alignment: Alignment.center,
                          child: Text(title, style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 22.0, fontFamily: "Anson"),)
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0,12.0,0.0,12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(child: Text(body, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0, fontFamily: "Cambo"),), flex: 3,),
                            Flexible(
                              flex: 1,
                              child: Container(
                                  height: 80.0,
                                  width: 80.0,
                                  child: Image.asset("assets/images/notifications.jpg", fit: BoxFit.cover,)
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('', style: TextStyle(fontSize: 18.0),),
                              Text(date , style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w500),)
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
