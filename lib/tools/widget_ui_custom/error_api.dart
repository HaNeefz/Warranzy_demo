import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  final String errorMessage;
  final Function onRetryPressed;
  const Error({Key key, this.errorMessage, this.onRetryPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                errorMessage,
                textAlign: TextAlign.center,
              ),
              RaisedButton(
                  shape: CircleBorder(),
                  child: Icon(Icons.refresh),
                  onPressed: onRetryPressed),
            ],
          ),
        ),
      ),
    );
  }
}
