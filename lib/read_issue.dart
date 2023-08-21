import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Tabloid {
  final String title;
  final String url;
  Tabloid(this.title, this.url);
}


class ReadIssue extends StatelessWidget {

  final issues = [
    Tabloid("ISSUE 1", "https://drive.google.com/open?id=11-xHJlkM7R_ksCrLFcb9nFwarR3ZhDMY"),
    Tabloid("ISSUE 2", "https://drive.google.com/open?id=1iO_pYVMoJB5k3qT-IoGAYf8CjaUK5wpk"),
    Tabloid("ISSUE 3", "https://drive.google.com/open?id=1qPU7EhsLIkcrddHgCr7X6habi_sENwr6"),
    Tabloid("ISSUE 4", "https://drive.google.com/open?id=1DuFwjqlkVJ_VHMNYIpEkwC57oT1a-6WX"),
    Tabloid("ISSUE 5", "https://drive.google.com/file/d/1vGx6bFbYTH0curzFaUUY9eq8ECG2FH6h/view"),
    Tabloid("ISSUE 6", "https://drive.google.com/open?id=1B1hiOd2gHG9Fg0H_RVxENoKG1jdhiCMG"),
    Tabloid("ISSUE 7", "https://drive.google.com/open?id=1Cy4uJ13UljsXLil9b7nfHkD34kpjn1qI"),
    Tabloid("ISSUE 9", "https://drive.google.com/open?id=1Grgvc5khunoBavWV7t2utfOmU_kmchQA"),
    Tabloid("ISSUE 10", "https://drive.google.com/open?id=1MGEPyNANQX8wv_rk1Oi6ELNJDIK6vAr_"),
  ];

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
          child: ListView.builder(
            itemCount: issues.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                child: InkWell(
                  onTap: () {
                    launch(
                      issues[index].url,
                      //forceWebView: true,
                    );
                  },
                  child: Container(
                    height: 50.0,
                    color: Colors.green,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          issues[index].title,
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
              );
            }
          ),
        ),
      ),
    );
  }
}
