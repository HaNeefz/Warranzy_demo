import 'package:flutter/material.dart';

class SearchBrandNamePage extends StatefulWidget {
  SearchBrandNamePage({Key key}) : super(key: key);

  _SearchBrandNamePageState createState() => _SearchBrandNamePageState();
}

class _SearchBrandNamePageState extends State<SearchBrandNamePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SEARCH"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Text("Hi"),
          ),
          RaisedButton(
            child: Text("Choosed"),
            onPressed: () {
              Navigator.pop(context, "Hello");
            },
          )
        ],
      ),
    );
  }
}
