

import 'package:common_state_provider/states.dart';
import 'package:flutter/material.dart';


class GenericError extends StatelessWidget {
  final bool retryEnabled;
  final Function() onRetry;
  final ErrorState error;

  const GenericError({Key key, this.error, this.retryEnabled = false, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.error, color: Colors.red, size: 50),
          Text(error.error.toString()),
          if (retryEnabled)
            FlatButton(onPressed: () {
              assert(onRetry != null, "Widget should implement onRetry callback");
              onRetry();
            }, child: Text("RETRY"),)
        ],
      ),
    );
  }
}
