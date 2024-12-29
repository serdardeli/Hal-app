part of 'komisyoncu_cubit.dart';

@immutable
abstract class KomisyoncuState {}

class KomisyoncuInitial extends KomisyoncuState {}

class KomisyoncuSatis extends KomisyoncuState {}

class KomisyoncuSevkAlim extends KomisyoncuState {}

class KomisyoncuSevkEtme extends KomisyoncuState {}
