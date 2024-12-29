part of 'sanayici_satin_alim_cubit.dart';

@immutable
abstract class SanayiciSatinAlimState {}

class SanayiciSatinAlimInitial extends SanayiciSatinAlimState {}
 
class SanayiciSatinAlimLoading extends SanayiciSatinAlimState {}

class SanayiciSatinAlimCompletelySuccess extends SanayiciSatinAlimState {
  final BildirimKayitResponseModel response;
  SanayiciSatinAlimCompletelySuccess({required this.response});
}

class SanayiciSatinAlimSuccessHasSomeError extends SanayiciSatinAlimState {
  final BildirimKayitResponseModel response;
  SanayiciSatinAlimSuccessHasSomeError({required this.response});
}

class SanayiciSatinAlimError extends SanayiciSatinAlimState {
  final String message;
  SanayiciSatinAlimError({required this.message});
}
