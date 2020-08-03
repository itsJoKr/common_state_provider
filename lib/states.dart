import 'package:flutter/material.dart';


@immutable
abstract class RequestState<T>{ }

@immutable
class InitialState<T> extends RequestState<T>{
}

@immutable
class LoadingState<T> extends RequestState<T>{
}

@immutable
class ErrorState<T> extends RequestState<T>{
  ErrorState(this.error, this.stackTrace);

  final Object error;
  final StackTrace stackTrace;
}

@immutable
class ContentState<T> extends RequestState<T>{
  ContentState(this.content);

  final T content;
}