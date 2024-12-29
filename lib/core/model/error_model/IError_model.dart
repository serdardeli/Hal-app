import 'dart:ffi';

abstract class IErrorModel<T> {
  String message;
  int statusCode;
  IErrorModel({
    required this.message,
    required this.statusCode
  });
}
