import 'dart:async';

import 'package:common_state_provider/request_provider.dart';
import 'package:common_state_provider/states.dart';
import 'package:common_state_provider/widgets/request_widget_mixin.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../common_state_provider.dart';

class InLayoutRequestWidget<ResponseBody, P extends RequestProvider<dynamic, ResponseBody>> extends StatelessWidget
    with RequestWidgetMixin<ResponseBody> {
  const InLayoutRequestWidget(
      {Key key,
      this.builder,
      this.buildLoading,
      this.buildInitial,
      this.buildError,
      this.listenSuccess,
      this.listenError,
      this.onRetry})
      : super(key: key);

  /// Builder for successful request
  final SuccessRequestWidgetBuilder<ResponseBody> builder;

  /// Builder for loading state
  final RequestWidgetBuilder<ResponseBody> buildLoading;

  /// Builder for initial state, before network request is started
  final RequestWidgetBuilder<ResponseBody> buildInitial;

  /// Builder for unsuccessful request, all errors will propagate here
  /// or use common error handling
  final ErrorRequestWidgetBuilder<ResponseBody> buildError;

  /// Listener for success
  final Function(BuildContext context, ResponseBody respons3) listenSuccess;

  /// Listener for error
  final Function(BuildContext context, ErrorState errorState) listenError;

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Consumer<P>(
      builder: (context, requestProvider, _) {
        var state = requestProvider.state;

        if (state is LoadingState<ResponseBody>) {
          return (buildLoading != null) ? buildLoading(context) : CommonStateHandling().loadingBuilder(context);
        } else if (state is ErrorState<ResponseBody>) {
          scheduleMicrotask(() {
            if (listenError != null) listenError(context, state);
          });
          return getErrorWidget(context, buildError, state, onRetry);
        } else if (state is InitialState<ResponseBody>) {
          return (buildInitial != null) ? buildInitial(context) : const SizedBox.shrink();
        } else if (state is ContentState<ResponseBody>) {
          scheduleMicrotask(() {
            if (listenSuccess != null) listenSuccess(context, state.content);
          });
          return builder(context, state.content);
        }

        assert(false, 'Unknown state for RequestProvider!');
        return Container();
      },
    );
  }
}
