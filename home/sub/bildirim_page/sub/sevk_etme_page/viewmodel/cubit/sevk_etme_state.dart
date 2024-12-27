part of 'sevk_etme_cubit.dart';

@immutable
abstract class SevkEtmeState {}

class SevkEtmeInitial extends SevkEtmeState {}

class SevkEtmeLoading extends SevkEtmeState {}

class SevkEtmeCompletelySuccessful extends SevkEtmeState {
  final BildirimKayitResponseModel response;
  SevkEtmeCompletelySuccessful({required this.response});
}

class SevkEtmeSuccessfulForJustIrsaliye extends SevkEtmeState {
  SevkEtmeSuccessfulForJustIrsaliye();
}

class SevkEtmeSuccessfulHasSomeError extends SevkEtmeState {
  final BildirimKayitResponseModel response;
  SevkEtmeSuccessfulHasSomeError({required this.response});
}

class SevkEtmeError extends SevkEtmeState {
  final String message;
  SevkEtmeError({required this.message});
}
