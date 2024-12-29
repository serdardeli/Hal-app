part of 'add_musteri_sub_cubit.dart';

@immutable
abstract class AddMusteriSubState {}
class AddMusteriSubLoading extends AddMusteriSubState {}

class AddMusteriSubInitial extends AddMusteriSubState {}

class AddMusteriSubSuccessful extends AddMusteriSubState {}
class AddMusteriSubDeleted extends AddMusteriSubState {}

class AddMusteriSubUserInfoFound extends AddMusteriSubState {}

class AddMusteriSubError extends AddMusteriSubState {
  final String message;
  AddMusteriSubError({required this.message});
}
