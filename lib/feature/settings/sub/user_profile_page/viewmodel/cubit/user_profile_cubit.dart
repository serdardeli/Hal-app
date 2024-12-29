import 'package:bloc/bloc.dart';
import '../../../../../../core/enum/preferences_keys_enum.dart';
import '../../../../../../project/cache/app_cache_manager.dart';
import '../../../../../../project/cache/user_cache_manager.dart';
import '../../../../../../project/model/user/my_user_model.dart';
import 'package:meta/meta.dart';

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit() : super(UserProfileInitial());
 
  void getCurrentUserInfo() {
    MyUser? user;
    String? phoneNubmer =
        AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
    if (phoneNubmer != null) {
      user = UserCacheManager.instance.getItem(phoneNubmer);
    }
  }


}
