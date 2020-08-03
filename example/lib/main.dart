import 'package:common_state_provider/common_state_provider.dart';
import 'package:common_state_provider/widgets/blocking_layout_request.dart';
import 'package:common_state_provider/widgets/in_layout_request_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'api_service.dart';
import 'fetch_weather_provider.dart';
import 'fetch_weather_provider.dart';
import 'fetch_weather_provider.dart';
import 'widgets/generic_dialog.dart';
import 'widgets/generic_error.dart';
import 'widgets/generic_loading.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    CommonStateHandling.registerCommonErrorWidget((context, error, showRetry, onRetry) {
      return GenericError(error: error, retryEnabled: showRetry, onRetry: onRetry,);
    });

    CommonStateHandling.registerCommonLoadingWidget((context) {
      return GenericLoading();
    });

    CommonStateHandling.registerBlockingDialogWidget((context, child, state) {
      return GenericDialog(child: child, state: state);
    });

    return MaterialApp(
      title: 'Common State Handling',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SomeScreen(),
    );
  }
}

class SomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ChangeNotifierProvider(
            create: (context) => FetchWeatherProvider(), child: WeatherCard()),
      ),
    );
  }
}

class WeatherCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: <Widget>[
          Card(
            child: Container(
              margin: const EdgeInsets.all(12.0),
              height: 180.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Weather card'),
                  Expanded(
                    child: InLayoutRequestWidget<Weather, FetchWeatherProvider>(
                      onRetry: () =>  context.read<FetchWeatherProvider>().execute(null),
                      listenSuccess: (_, s) => print('success'),
                      builder: (context, weather) {
                        return Container(
                            alignment: Alignment.center,
                            child: Text(weather.condition + " in " + weather.city));
                      },
                      buildInitial: (context) {
                        return InkWell(
                          onTap: (){
                            context.read<FetchWeatherProvider>().execute(null);
                          },
                          child: Container(
                              alignment: Alignment.center,
                              child: Text('Click here to get weather')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

