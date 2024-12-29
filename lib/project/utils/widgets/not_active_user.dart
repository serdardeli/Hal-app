import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../cache/user_cache_manager.dart';
import '../../../core/enum/preferences_keys_enum.dart';
import '../../../feature/subscriptions/view/subscriptions_page.dart';
import '../../cache/app_cache_manager.dart';
import '../../service/firebase/auth/fireabase_auth_service.dart';
import 'package:kartal/kartal.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../feature/manage_tc/view/manage_tc_page.dart';

class NotActiveWidget extends StatefulWidget {
  const NotActiveWidget({Key? key}) : super(key: key);

  @override
  State<NotActiveWidget> createState() => NotActiveWidgetState();
}

class NotActiveWidgetState extends State<NotActiveWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AppCacheManager.instance.init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ValueListenableBuilder(
            valueListenable:
                Hive.box<String>(AppCacheManager.instance.key).listenable(),
            builder: (context, Box<String>? box, widget) {
              if (box != null) {
                bool isUserActive =
                    (box.get(PreferencesKeys.isUserActive.name) ?? "") == "true"
                        ? true
                        : false;
                bool userIsNull =
                    FirebaseAuth.instance.currentUser != null ? false : true;
                    //TODO: BUNU FİREBASE YOKSA DİYE TEST İÇİN KOYDUM FİREBASEİN OLMAMASINI DÜZELT VE BUNU KALDIR BÖYLE OLMAZ 
                if (userIsNull) {
                  userIsNull = UserCacheManager.instance.getItem(AppCacheManager
                                  .instance
                                  .getItem(PreferencesKeys.phone.name) ??
                              "") ==
                          null
                      ? true
                      : false;
                }
                return AnimatedCrossFade(
                  duration: context.duration.durationLow,
                  crossFadeState: (!userIsNull && !isUserActive)
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: Container(
                      //height: context.sized.dynamicHeight(0),
                      height: context.sized.dynamicHeight(0.04),
                      color: Colors.black,
                      child: Center(
                        child: Text(
                            "aktif kullanıcı bulunamadı üyelik almalısınız",
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.center,
                            style: context.general.textTheme.bodyLarge
                                ?.copyWith(color: Colors.white, fontSize: 11)),
                      )),
                  secondChild: const SizedBox(),
                );
              } else {
                return const SizedBox();
              }
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
