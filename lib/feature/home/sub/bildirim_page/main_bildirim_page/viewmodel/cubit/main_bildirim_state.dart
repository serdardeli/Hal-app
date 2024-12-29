part of 'main_bildirim_cubit.dart';

@immutable
abstract class MainBildirimState {}

class MainBildirimInitial extends MainBildirimState {}

class MainBildirimSuccess extends MainBildirimState {
  final SifatTypes type;
  final SifatNames activeSifat;
  MainBildirimSuccess({required this.type, required this.activeSifat});
}

class MainBildirimError extends MainBildirimState {
  final String message;
  MainBildirimError({required this.message});
}
