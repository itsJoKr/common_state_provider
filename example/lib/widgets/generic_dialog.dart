
import 'package:common_state_provider/states.dart';
import 'package:flutter/cupertino.dart';

class GenericDialog extends StatelessWidget {

  final Widget child;
  final RequestState state;

  const GenericDialog({Key key, this.state, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
        title: Text(_getTitle()),
        content: child
    );
  }

  String _getTitle() {
    if (state is LoadingState) {
      return "Loading";
    } else if (state is ErrorState) {
      return "Error";
    } else {
      return "";
    }
  }
}
