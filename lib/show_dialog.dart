import 'package:common_state_provider/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'common_state_provider.dart';

/// Util class that shows dialog
///
/// todo: handle close/cancel callback (depending on the project)
Future<T> showInfoDialog<T>(
    BuildContext context, RequestState state, Widget content,
    {bool dismissible = true}) {
  return showDialog<T>(
      barrierDismissible: dismissible,
      context: context,
      builder: (BuildContext context) {
        return CommonStateHandling().dialogBuilder(context, content, state);
      });
}
