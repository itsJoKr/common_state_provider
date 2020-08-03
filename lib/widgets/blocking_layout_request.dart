import 'dart:async';

import 'package:common_state_provider/request_provider.dart';
import 'package:common_state_provider/show_dialog.dart';
import 'package:common_state_provider/widgets/request_widget_mixin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common_state_provider.dart';
import '../states.dart';

class BlockingLayoutRequest<ResponseBody, P extends RequestProvider<dynamic, ResponseBody>> extends StatefulWidget {
  const BlockingLayoutRequest(
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

  /// OnRetry
  final VoidCallback onRetry;

  @override
  _BlockingLayoutRequestState<ResponseBody, P> createState() => _BlockingLayoutRequestState<ResponseBody, P>();
}

class _BlockingLayoutRequestState<ResponseBody, P extends RequestProvider<dynamic, ResponseBody>>
    extends State<BlockingLayoutRequest<ResponseBody, P>> with RequestWidgetMixin {
  bool _dialogShown = false;
  RequestProvider<dynamic, ResponseBody> _provider;
  VoidCallback _listener;

  @override
  void initState() {
    super.initState();

    _listener = () {
      if (_dialogShown) {
        Navigator.pop(context);
      }

      var state = _provider.state;

      if (state is LoadingState<ResponseBody>) {
        final loadingWidget = (widget.buildLoading != null)
            ? widget.buildLoading(context)
            : CommonStateHandling().loadingBuilder(context);
        _showDialog(state, loadingWidget);
      } else if (state is ErrorState<ResponseBody>) {
        final errorWidget = getErrorWidgetWithButton(context, widget.buildError, state, widget.onRetry, () {
          Navigator.pop(context);
        });
        _showDialog(state, errorWidget, dismissible: true);
      } else if (state is ContentState<ResponseBody>) {
        scheduleMicrotask(() {
          if (widget.listenSuccess != null) widget.listenSuccess(context, state.content);
        });
      }
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _provider = Provider.of<P>(context, listen: false);
    _provider.addListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<P>(
      builder: (context, requestProvider, _) {
        var state = requestProvider.state;

        if (state is InitialState<ResponseBody>) {
          return (widget.buildInitial != null) ? widget.buildInitial(context) : const SizedBox.shrink();
        } else if (state is ContentState<ResponseBody>) {
          return widget.builder(context, state.content);
        }

        return Container();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _provider.removeListener(_listener);
  }

  Future<T> _showDialog<T>(RequestState state, Widget child, {bool dismissible = false}) async {
    _dialogShown = true;
    final T content = await showInfoDialog<T>(context, state, child, dismissible: dismissible);
    _dialogShown = false;
    return content;
  }
}
