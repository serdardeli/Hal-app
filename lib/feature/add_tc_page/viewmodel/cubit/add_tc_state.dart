part of 'add_tc_cubit.dart';

@immutable
abstract class AddTcState {}

class AddTcInitial extends AddTcState {}

class AddTcSuccessful extends AddTcState {}

class AddTcLoading extends AddTcState {}

class AddTcError extends AddTcState {
  final String message;
  AddTcError({required this.message});
}
