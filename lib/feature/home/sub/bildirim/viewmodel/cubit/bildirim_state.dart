part of 'bildirim_cubit.dart';

@immutable
abstract class BildirimState {}

class BildirimInitial extends BildirimState {}

class BildirimError extends BildirimState {
  final String message;
  BildirimError({required this.message});
}
