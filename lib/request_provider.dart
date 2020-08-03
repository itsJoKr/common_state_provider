

import 'package:common_state_provider/states.dart';
import 'package:flutter/cupertino.dart';

abstract class RequestProvider<RequestBody, ResponseBody> with ChangeNotifier {

  RequestState<ResponseBody> state = InitialState<ResponseBody>();

  Future<void> execute(RequestBody body) async {
    state = LoadingState<ResponseBody>();
    notifyListeners();

    try {
      final ResponseBody content = await request(body);
      state = ContentState<ResponseBody>(content);
    } catch (error, s) {
      print(error.toString());
      print(s);
      state = ErrorState<ResponseBody>(error, s);
    } finally {
      notifyListeners();
    }
  }

  Future<ResponseBody> request(RequestBody body);
}
