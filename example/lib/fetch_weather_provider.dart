
import 'package:common_state_provider/request_provider.dart';
import 'package:flutter/material.dart';

import 'api_service.dart';

class FetchWeatherProvider extends RequestProvider<void, Weather> {
  final ApiService _apiService = ApiService.instance();

  @override
  Future<Weather> request(void body) {
    return _apiService.fetchWeather();
  }
}


