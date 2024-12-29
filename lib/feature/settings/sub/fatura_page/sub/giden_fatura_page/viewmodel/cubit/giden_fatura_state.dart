part of 'giden_fatura_cubit.dart';

@immutable
abstract class GidenFaturaState {}

class GidenFaturaInitial extends GidenFaturaState {}

class GidenFaturaError extends GidenFaturaState {
  final String message;
  GidenFaturaError({required this.message});
}
