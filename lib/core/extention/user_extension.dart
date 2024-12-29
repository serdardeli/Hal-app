import '../../project/model/user/my_user_model.dart';

import '../enum/subscription_types_enum.dart';

extension UserExtension on MyUser {
  int get findSubscriptionNumber {
    if (subscriptionId == null) {
      return 0;
    }
    int tempIndex = 0;

    if (subscriptionId == "full_access") {
      tempIndex = 50;
    }
    if (subscriptionId == "basic_trial") {
      tempIndex = 1;
    }
    if (subscriptionId == "trial_1w") {
      tempIndex = 1;
    }
    if (subscriptionId == "one_week_new") {
      tempIndex = 1;
    }
    for (var element in SubscriptionIds.values) {
      print(subscriptionId);  
      print(element.name);
      if (element.name == subscriptionId) {
        tempIndex = element.index + 1;
      }
    }

    return tempIndex;
  }

 int get findSubNumberTest {
    if (subscriptionId == null) {
      return 0;
    }
    int tempIndex = 0;

    // if (subscriptionId == "5 Bildirimci DENEME new") {
    //   tempIndex = 50;
    // }
    // if (subscriptionId == "basic_trial") {
    //   tempIndex = 1;
    // }
    // if (subscriptionId == "trial_1w") {
    //   tempIndex = 1;
    // }
    if (subscriptionId == "5 Bildirimci DENEME new") {
      tempIndex = 5;
    }
    if (subscriptionId == "4 Bildirimci DENEME new") {
      tempIndex = 4;
    }
    if (subscriptionId == "3 Bildirimci DENEME new") {
      tempIndex = 3;
    }
    if (subscriptionId == "2 Bildirimci DENEME new") {
      tempIndex = 2;
    }
    if (subscriptionId == "1 Bildirimci DENEME new") {
      tempIndex = 1;
    }

    return tempIndex;
  }
}
