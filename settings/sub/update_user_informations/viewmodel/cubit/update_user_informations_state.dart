part of 'update_user_informations_cubit.dart';

@immutable
abstract class UpdateUserInformationsState {}

class UpdateUserInformationsInitial extends UpdateUserInformationsState {}

class UpdateUserInformationsLoading extends UpdateUserInformationsState {}

class UpdateUserInformationsError extends UpdateUserInformationsState {
  final String message;
  UpdateUserInformationsError({required this.message});
}

class UpdateUserInformationsSuccessful extends UpdateUserInformationsState {
  final String? message;
  UpdateUserInformationsSuccessful({this.message});
}

class UpdateUserInformationsUserFound extends UpdateUserInformationsState {}
