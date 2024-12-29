import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'remove_saved_notification_state.dart';

class RemoveSavedNotificationCubit extends Cubit<RemoveSavedNotificationState> {
  RemoveSavedNotificationCubit() : super(RemoveSavedNotificationInitial());
}
