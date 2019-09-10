import 'dart:async';
import 'package:warranzy_demo/services/api_provider/repository.dart';

import 'api_response.dart';

class ApiBlocGetAllAsset<T> {
  final String url;
  final dynamic body;
  FetchRepository _repository;

  StreamController _stmController;

  StreamSink<ApiResponse<T>> get stmSink => _stmController.sink;

  Stream<ApiResponse<T>> get stmStream => _stmController.stream;

  ApiBlocGetAllAsset({this.url, this.body}) {
    _stmController = StreamController<ApiResponse<T>>();
    _repository = FetchRepository(); //url: "/User/Login", body: body
    fetchData();
  }

  fetchData() async {
    stmSink.add(ApiResponse<T>.loading('Loading'));
    try {
      T _data = await _repository.getAllAsset(url);
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

class ApiBlocGetDetailAsset<T> {
  final String url;
  final dynamic body;
  FetchRepository<T> _repository;

  StreamController _stmController;

  StreamSink<ApiResponse<T>> get stmSink => _stmController.sink;

  Stream<ApiResponse<T>> get stmStream => _stmController.stream;

  ApiBlocGetDetailAsset({this.url, this.body}) {
    _stmController = StreamController<ApiResponse<T>>();
    _repository = FetchRepository<T>(); //url: "/User/Login", body: body
    fetchData();
  }

  fetchData() async {
    stmSink.add(ApiResponse<T>.loading('Loading'));
    try {
      T _data = await _repository.getDetailAsset(url, body);
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
