import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/export_lib.dart';

import 'api_bloc.dart';
import 'api_response.dart';

class ApiBlocWidget<T> extends StatefulWidget {
  ApiBloc<T> apiBloc;
  final String url;
  final dynamic body;

  ApiBlocWidget({Key key, this.apiBloc, this.url, this.body}) : super(key: key);

  @override
  _ApiBlocWidgetState<T> createState() => _ApiBlocWidgetState<T>();
}

class _ApiBlocWidgetState<T> extends State<ApiBlocWidget<T>> {
  final ecsLib = getIt.get<ECSLib>();
  String get url => widget.url;
  dynamic get body => widget.body;
  @override
  void initState() {
    super.initState();
    widget.apiBloc = ApiBloc<T>(url: url, body: body);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<T>>(
      stream: widget.apiBloc.stmStream,
      builder: (BuildContext context, AsyncSnapshot<ApiResponse<T>> snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Center(child: ecsLib.loadingLogoWarranzy());
              break;
            case Status.COMPLETED:
              Navigator.pop(context, snapshot.data.data);
              return Text("${snapshot.data.data}");
              break;
            case Status.ERROR:
              return Column(
                children: <Widget>[
                  Text(snapshot.data.message),
                  RaisedButton(
                    shape: CircleBorder(),
                    child: Icon(Icons.refresh),
                    onPressed: () {
                      widget.apiBloc.fetchData();
                    },
                  )
                ],
              );
              break;
          }
        }
        return Container();
      },
    );
  }
}
