part of 'ureticiden_sevk_alim_cubit.dart';

@immutable
abstract class UreticidenSevkAlimState {}

class UreticidenSevkAlimInitial extends UreticidenSevkAlimState {}

class UreticiSevkAlimCompletelySuccessful extends UreticidenSevkAlimState {
  final BildirimKayitResponseModel response;
  UreticiSevkAlimCompletelySuccessful({required this.response});
}

class UreticiSevkAlimLoading extends UreticidenSevkAlimState {}

class UreticiSevkAlimError extends UreticidenSevkAlimState {
  final String message;
  UreticiSevkAlimError({required this.message});
}

class UreticiSevkAlimSuccessHasSomeError extends UreticidenSevkAlimState {
  final BildirimKayitResponseModel response;
  UreticiSevkAlimSuccessHasSomeError({required this.response});
}
