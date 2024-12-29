part of 'subscriptions_cubit.dart';

@immutable
abstract class SubscriptionsState {}

class SubscriptionsInitial extends SubscriptionsState {}
class SubscriptionsSuccessful extends SubscriptionsState {}
class SubscriptionsLoading extends SubscriptionsState {}

class SubscriptionsError extends SubscriptionsState {
  final String message;
  SubscriptionsError({required this.message});
}
