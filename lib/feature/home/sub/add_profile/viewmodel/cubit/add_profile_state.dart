part of 'add_profile_cubit.dart';

@immutable
abstract class AddProfileState {}

class AddProfileInitial extends AddProfileState {}

class AddProfileError extends AddProfileState {
  final String message;
  AddProfileError({required this.message});
}

class AddProfileSuccess extends AddProfileState {
  final String message;
  AddProfileSuccess({required this.message});
}
class AddProfileDeleted extends AddProfileState {
   AddProfileDeleted( );
}