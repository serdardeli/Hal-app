import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hal_app/core/enum/preferences_keys_enum.dart';
import 'package:hal_app/core/extention/user_extension.dart';
import 'package:hal_app/feature/launch/view/launch_view.dart';
import 'package:hal_app/feature/subscriptions/view/subscriptions_page.dart';
import 'package:hal_app/project/cache/app_cache_manager.dart';
import 'package:hal_app/project/cache/user_cache_manager.dart';
import 'package:hal_app/project/model/user/my_user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kartal/kartal.dart';

import '../../../project/cache/bildirimci_cache_manager.dart';
import '../../../project/model/bildirimci/bildirimci_model.dart';
import '../../../project/utils/widgets/settings_page_card_item.dart';
import '../../helper/scaffold_messager.dart';
import '../../settings/sub/update_user_informations/view/update_user_informations_page.dart';
import '../../settings/sub/update_user_informations/viewmodel/cubit/update_user_informations_cubit.dart';

class TempBildirimci {
  bool isActive;
  String tc;
  TempBildirimci({required this.tc, required this.isActive});
}

class RemoveExcessTcPage extends StatefulWidget {
  static const String name = "removeExcessTcPage";
  const RemoveExcessTcPage({Key? key}) : super(key: key);

  @override
  State<RemoveExcessTcPage> createState() => _RemoveExcessTcPageState();
}

class _RemoveExcessTcPageState extends State<RemoveExcessTcPage> {
  List<TempBildirimci> tempBildirimciList = [];
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    BildirimciCacheManager.instance.getkeys()?.forEach((element) {
      tempBildirimciList.add(TempBildirimci(tc: element, isActive: false));
    });
  }

//  =
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text("Bildirimci Sil"),
      ),
      body: ValueListenableBuilder(
          valueListenable:
              Hive.box<MyUser>(UserCacheManager.instance.key).listenable(),
          builder: (BuildContext context, Box<MyUser>? box, Widget? child) {
            String? phone =
                AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
            if (phone != null) {
              MyUser? user = box?.get(phone);
              if (user != null) {
                user.subscriptionNumber ??= user.findSubscriptionNumber;
                return Padding(
                  padding: context.padding.horizontalNormal,
                  child: Column(
                    children: [
                      const Text("Silmek istediğiniz bildirimcileri seçiniz"),
                      Expanded(
                          child:
                              buildTcListBuilder(context, tempBildirimciList)),
                    ],
                  ),
                );

                // return buildTcListBuilder(context);

                return const Center(child: Text("remove data "));
              } else {
                return const Center(child: Text("boş kullanıcı  "));
              }
            }
            return const Center(child: Text("boş   "));
          }),
    );
  }

  Widget buildTcListBuilder(
      BuildContext context, List<TempBildirimci> tempBildirimciList) {
    return ValueListenableBuilder(
        valueListenable:
            Hive.box<Bildirimci>(BildirimciCacheManager.instance.key)
                .listenable(),
        builder: (context, Box<Bildirimci>? box, widget) {
          List<String>? tcs = box?.keys.toList().cast<String>();
          if (tcs != null) {
            return (!tempBildirimciList.ext.isNotNullOrEmpty)
                ? Padding(
                    padding: context.padding.verticalNormal,
                    child: const Text(" Bildirimci Listesi Boş "))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tempBildirimciList.length + 1,
                    itemBuilder: (context, index) {
                      if (tempBildirimciList.length == index) {
                        return Padding(
                          padding: context.padding.verticalNormal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              FloatingActionButton.extended(
                                  heroTag: "aboneligiYukselt",
                                  onPressed: () {
                                    try {
                                      Navigator.pushNamed(
                                          context, SubscriptionsPage.name);
                                    } catch (e) {
                                      log(e.toString());
                                    }
                                  },
                                  label: const Text("Aboneliği Yükselt")),
                              FloatingActionButton.extended(
                                  heroTag: "secilenleriSil",
                                  onPressed: () async {
                                    bool elementExist = false;
                                    for (var element in tempBildirimciList) {
                                      if (element.isActive) {
                                        elementExist = true;
                                      }
                                      if (element.isActive) {
                                        await BildirimciCacheManager.instance
                                            .deleteItem(element.tc);
                                        String? phone = AppCacheManager.instance
                                            .getItem(
                                                PreferencesKeys.phone.name);
                                        UserCacheManager.instance
                                            .deleteBildirimciTc(
                                                phone ?? "", element.tc);
                                      }
                                    }
                                    if (!elementExist) {
                                      ScaffoldMessengerHelper.instance
                                          .showErrorSnackBar(context,
                                              "Silinecek Eleman Seçiniz");
                                    } else {
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          Launch.name, (route) => false);
                                    }
                                  },
                                  label: const Text("Seçilenleri Sil")),
                            ],
                          ),
                        );
                      }
                      return buildTcCard(context,
                          tempBildirimci: tempBildirimciList[index]);
                    },
                  );
          } else {
            return const Text("Kullanıcı bulunamadı ");
          }
        });
  }

  SettingsCardItem buildTcCard(BuildContext context,
      {required TempBildirimci tempBildirimci}) {
    return SettingsCardItem(
      ontap: () async {
        // Bildirimci? bildirimci = BildirimciCacheManager.instance.getItem(tempBildirimci.tc);
        // if (bildirimci != null) {
        //   context
        //       .read<UpdateUserInformationsCubit>()
        //       .setSelectedBildirimciTc(bildirimci);
        //   Navigator.pushNamed(context, UpdateUserInformationPage.name);
        // } else {
        //   ScaffoldMessengerHelper.instance
        //       .showErrorSnackBar(context, "Bildirimci Tc Bulunamadı");
        // }
        setState(() {
          tempBildirimci.isActive = !tempBildirimci.isActive;
        });
      },
      prefix: const Icon(Icons.person),
      text: Text(
        tempBildirimci.tc,
        style: context.general.textTheme.titleLarge,
      ),
      suffix: Checkbox(
          activeColor: Colors.green,
          value: tempBildirimci.isActive,
          onChanged: (value) {
            setState(() {
              tempBildirimci.isActive = value!;
            });
          }),
    );
  }
}
