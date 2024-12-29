part of 'mysoft_user_cubit.dart';

@immutable
abstract class AddMySoftUserState {}

class AddMySoftUserInitial extends AddMySoftUserState {}

class AddMySoftUserAddSuccessful extends AddMySoftUserState {}

class AddMySoftUserUpdateSuccessful extends AddMySoftUserState {}

class AddMySoftUserError extends AddMySoftUserState {
  final String message;
  AddMySoftUserError({required this.message});
}
