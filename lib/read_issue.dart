import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReadIssue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Read Issue'),
        centerTitle: true,
        bottomOpacity: 0.0,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Container(
          height: MediaQuery.of(context).size.height * (3 / 4),
          width: MediaQuery.of(context).size.width * (3 / 4),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Card(
                child: InkWell(
                  onTap: () {
                    launch(
                      'https://drive.google.com/open?id=11-xHJlkM7R_ksCrLFcb9nFwarR3ZhDMY',
                      //forceWebView: true,
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * (3 / 4),
                    height: 50.0,
                    color: Colors.green,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          " ISSUE 1 ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: InkWell(
                  onTap: () {
                    launch(
                      'https://drive.google.com/open?id=1iO_pYVMoJB5k3qT-IoGAYf8CjaUK5wpk',
                      //forceWebView: true,
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * (3 / 4),
                    height: 50.0,
                    color: Colors.green,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          " ISSUE 2 ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: InkWell(
                  onTap: () {
                    launch(
                      'https://drive.google.com/open?id=1qPU7EhsLIkcrddHgCr7X6habi_sENwr6',
                      //forceWebView: true,
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * (3 / 4),
                    height: 50.0,
                    color: Colors.green,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          " ISSUE 3 ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: InkWell(
                  onTap: () {
                    launch(
                      'https://drive.google.com/open?id=1DuFwjqlkVJ_VHMNYIpEkwC57oT1a-6WX',
                      //forceWebView: true,
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * (3 / 4),
                    height: 50.0,
                    color: Colors.green,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          " ISSUE 4 ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: InkWell(
                  onTap: () {
                    launch(
                      'https://drive.google.com/file/d/1vGx6bFbYTH0curzFaUUY9eq8ECG2FH6h/view',
                      //forceWebView: true,
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * (3 / 4),
                    height: 50.0,
                    color: Colors.green,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          " ISSUE 5 ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 5.0,
                child: InkWell(
                  onTap: () {
                    launch(
                      'https://drive.google.com/open?id=1B1hiOd2gHG9Fg0H_RVxENoKG1jdhiCMG',
                      //forceWebView: true,
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * (3 / 4),
                    height: 50.0,
                    color: Colors.green,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          " ISSUE 6 ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
