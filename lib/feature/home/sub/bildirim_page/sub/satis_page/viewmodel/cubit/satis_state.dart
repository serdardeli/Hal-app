part of 'satis_cubit.dart';

@immutable
abstract class SatisState {}

class SatisInitial extends SatisState {}

class SatisError extends SatisState {
  final String message;
  SatisError({required this.message});
}

class SatisLoading extends SatisState {}

class SatisCompletelySuccess extends SatisState {
  final BildirimKayitResponseModel response;
  SatisCompletelySuccess({required this.response});
}

class SatisSuccessHasSomeError extends SatisState {
  final BildirimKayitResponseModel response;
  SatisSuccessHasSomeError({required this.response});
}
