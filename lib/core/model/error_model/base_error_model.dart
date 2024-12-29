import 'IError_model.dart';

class BaseError extends IErrorModel {
  final String message;
  final int statusCode;

  BaseError({required this.message, required this.statusCode})
      : super(message: message, statusCode: statusCode);
}
