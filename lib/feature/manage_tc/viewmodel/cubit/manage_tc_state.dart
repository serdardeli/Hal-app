part of 'manage_tc_cubit.dart';

@immutable
abstract class ManageTcState {}

class ManageTcInitial extends ManageTcState {}

class ManageTcSubscriptionNotFound extends ManageTcState {}

class ManageTcError extends ManageTcState {
  final String message;
  ManageTcError(this.message);
}
