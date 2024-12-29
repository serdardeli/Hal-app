part of 'recent_notifications_cubit.dart';

@immutable
abstract class RecentNotificationsState {}

class RecentNotificationsInitial extends RecentNotificationsState {}
class RecentNotificationsLoading extends RecentNotificationsState {}
class RecentNotificationsError extends RecentNotificationsState {
  final String message ;
  RecentNotificationsError({required this.message});
}
