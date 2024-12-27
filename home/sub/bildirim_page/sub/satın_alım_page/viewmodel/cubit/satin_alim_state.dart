part of 'satin_alim_cubit.dart';

@immutable
abstract class SatinAlimState {}

class SatinAlimInitial extends SatinAlimState {}

class SatinAlimLoading extends SatinAlimState {}

class SatinAlimCompletelySuccess extends SatinAlimState {
  final BildirimKayitResponseModel response;
  SatinAlimCompletelySuccess({required this.response});
}

class SatinAlimSuccessHasSomeError extends SatinAlimState {
  final BildirimKayitResponseModel response;
  SatinAlimSuccessHasSomeError({required this.response});
}

class SatinAlimError extends SatinAlimState {
  final String message;
  SatinAlimError({required this.message});
}
