part of 'sevk_etme_for_sanayici_cubit.dart';

@immutable
abstract class SevkEtmeForSanayiciState {}

class SevkEtmeForSanayiciInitial extends SevkEtmeForSanayiciState {}


class SevkEtmeForSanayiciLoading extends SevkEtmeForSanayiciState {}

class SevkEtmeForSanayiciError extends SevkEtmeForSanayiciState {
  final String message;
  SevkEtmeForSanayiciError({required this.message});
}

class SevkEtmeForSanayiciCompletelySuccess
    extends SevkEtmeForSanayiciState {
  final BildirimKayitResponseModel response;
  SevkEtmeForSanayiciCompletelySuccess({required this.response});
}

class SevkEtmeForSanayiciSuccessHasSomeError
    extends SevkEtmeForSanayiciState {
  final BildirimKayitResponseModel response;
  SevkEtmeForSanayiciSuccessHasSomeError({required this.response});
}


