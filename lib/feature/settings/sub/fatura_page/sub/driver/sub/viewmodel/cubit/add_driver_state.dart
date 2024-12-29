part of 'add_driver_cubit.dart';

@immutable
abstract class AddDriverState {}

class AddDriverInitial extends AddDriverState {}

class AddDriverError extends AddDriverState {
  final String message;
  AddDriverError({required this.message});
}

class AddDriverSuccess extends AddDriverState {
  final String message;
  AddDriverSuccess({required this.message});
}

class AddDriverDeleted extends AddDriverState {
  AddDriverDeleted();
}
