library common_state_provider;

import 'package:common_state_provider/states.dart';
import 'package:flutter/material.dart';


typedef SuccessRequestWidgetBuilder<T> = Widget Function(BuildContext context, T data);
typedef RequestWidgetBuilder<T> = Widget Function(BuildContext context);
typedef ErrorRequestWidgetBuilder<T> = Widget Function(BuildContext context, ErrorState errorState);


typedef ErrorWidgetBuilder = Function(BuildContext context, ErrorState error, bool showRetry, VoidCallback onRetry);
typedef BlockingDialogBuilder = Function(BuildContext context, Widget child, RequestState state);

class CommonStateHandling {
  static final CommonStateHandling _singleton = CommonStateHandling._internal();

  // todo: we can maybe package-private this
  ErrorWidgetBuilder errorBuilder;
  WidgetBuilder loadingBuilder;
  BlockingDialogBuilder dialogBuilder;

  factory CommonStateHandling() {
    return _singleton;
  }

  CommonStateHandling._internal();

  /// Register the widget that will be built and show in case of the error
  ///
  /// Parameters provided:
  /// ErrorState error - error state that contains data that can be shown to user
  /// bool showRetry - whether you should show retry button
  /// VoidCallback onRetry - callback that should be called after clicking retry
  static registerCommonErrorWidget(ErrorWidgetBuilder builder) {
    CommonStateHandling().errorBuilder = builder;
  }

  /// Register the widget that will be built and show in case of the loading
  /// Usually some kind of progress indicator
  static registerCommonLoadingWidget(WidgetBuilder builder) {
    CommonStateHandling().loadingBuilder = builder;
  }

  /// Register the widget that will be built and show in case of blocking
  /// request. The common error and loading widgets will be provided as
  /// a [child] param and they should be included in dialog.
  static registerBlockingDialogWidget(BlockingDialogBuilder builder) {
    CommonStateHandling().dialogBuilder = builder;
  }


}