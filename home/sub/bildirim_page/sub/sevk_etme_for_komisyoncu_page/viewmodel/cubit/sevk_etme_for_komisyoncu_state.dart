part of 'sevk_etme_for_komisyoncu_cubit.dart';

@immutable
abstract class SevkEtmeForKomisyoncuState {}

class SevkEtmeForKomisyoncuInitial extends SevkEtmeForKomisyoncuState {}

class SevkEtmeForKomisyoncuLoading extends SevkEtmeForKomisyoncuState {}

class SevkEtmeForKomisyoncuError extends SevkEtmeForKomisyoncuState {
  final String message;
  SevkEtmeForKomisyoncuError({required this.message});
}

class SevkEtmeForKomisyoncuCompletelySuccess
    extends SevkEtmeForKomisyoncuState {
  final BildirimKayitResponseModel response;
  SevkEtmeForKomisyoncuCompletelySuccess({required this.response});
}

class SevkEtmeForKomisyoncuSuccessHasSomeError
    extends SevkEtmeForKomisyoncuState {
  final BildirimKayitResponseModel response;
  SevkEtmeForKomisyoncuSuccessHasSomeError({required this.response});
}
