import 'dart:async';

import 'package:flutter/material.dart';
import 'package:warranzy_demo/services/api_provider/repository.dart';

import 'api_response.dart';

class ApiBloc<T> {
  final String url;
  final dynamic body;
  FetchRepository _repository;

  StreamController _stmController;

  StreamSink<ApiResponse<T>> get stmSink => _stmController.sink;

  Stream<ApiResponse<T>> get stmStream => _stmController.stream;

  ApiBloc({this.url, this.body}) {
    _stmController = StreamController<ApiResponse<T>>();
    // _movieRepository = MovieRepository();
    _repository = FetchRepository(); //url: "/User/Login", body: body
    fetchData();
  }

  fetchData() async {
    stmSink.add(ApiResponse<T>.loading('Loading'));
    try {
      T _data = await _repository.login(url, body);
      stmSink.add(ApiResponse<T>.completed(_data));
    } catch (e) {
      stmSink.add(ApiResponse<T>.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _stmController?.close();
  }
}

class APIProvider<T> extends ChangeNotifier {}
