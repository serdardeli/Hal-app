import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:hal_app/project/model/bildirimci/bildirimci_model.dart';
import 'package:hal_app/project/model/subscription_start_model/subscription_start_model.dart';
import 'package:hal_app/project/model/user/my_user_for_sort.dart';
import 'package:hal_app/project/service/firebase/firestore/firestore_service.dart';
import 'package:hal_app/project/utils/widgets/settings_page_card_item.dart';

class UserActivityPage extends StatefulWidget {
  static const String name = "userActivityPage";
  const UserActivityPage({super.key});

  @override
  State<UserActivityPage> createState() => _UserActivityPageState();
}

class _UserActivityPageState extends State<UserActivityPage> {
  List<MyUserForSort> list = [];
  List<Bildirimci> bildirimciList = [];
  List<MyUserForSort> listToRemove = [];

  int revenueCount = 0;
  String findBildirimci(String phone) {
    String total = "";

    for (var element in bildirimciList) {
      if (element.phoneNumber == phone) {
        total +=
            "${element.bildirimciTc} \n${element.webServiceSifre} \n${element.hksSifre} \n";
      }
    }
    return total;
  }

  String printBildirimci(List<Bildirimci> bildirimci) {
    String total = "";

    for (var element in bildirimci) {
      total +=
          "${element.bildirimciTc} \n${element.webServiceSifre} \n${element.hksSifre} \n";
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Activity"),
      ),
      body: Column(
        children: [
          Text(list.length.toString()),
          Text(revenueCount.toString()),
          Expanded(
            child: ListView.builder(
                itemBuilder: (context, index) {
                  list.sort((b, a) => (a.revenueCatSubscriptionId ?? "")
                      .compareTo((b.revenueCatSubscriptionId ?? "")));
                  listToRemove = [];
                  for (var element in list) {
                    if (element.revenueCatSubscriptionId != null ||
                        (element.bildirimci ?? []).isEmpty) {
                      listToRemove.add(element);
                    }
                  }


                  MyUserForSort currentUser = list[index];
                  return SettingsCardItem(
                      text: Text(
                          "${currentUser.phoneNumber ?? "null"} \n${currentUser.revenueCatSubscriptionId ?? "null"} \n${(currentUser.updatedAt != null ? currentUser.updatedAt.toDate() : "")} \n${currentUser.bildirimci != null ? printBildirimci(currentUser.bildirimci!) : ""} \n${currentUser.startModel?.isFreeSubscriptionUsed ?? "null".toString()} \n${currentUser.startModel?.subscriptionStartDate ?? "null".toString()}"),
                      prefix: IconButton(
                          onPressed: () async {
                            /*   var result = await FirebaseFirestore.instance
                                .collection("users")
                                .doc(list[index].phoneNumber)
                                .collection("tc")
                                .get();*/
                          },
                          icon: const Icon(Icons.abc)));
                },
                itemCount: list.length),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              heroTag: "aa",
              onPressed: () async {
                try {
                  for (var element in listToRemove) {
                    list.remove(element);
                  }
                } catch (e) {

                }
              },
              child: const Icon(Icons.delete)),
          FloatingActionButton(onPressed: () async {
            var result = await FirestoreService.instance.fetchAllUsersData();
            
            for (var item in result) {
              var a = MyUserForSort.fromJson(item.data());
              list.add(a);
            }

            for (var element in list) {
              if (element.revenueCatSubscriptionId != null) {
                revenueCount++;
              }
            }
            var resultsub = await FirebaseFirestore.instance
                .collection("subscriptionStartInfo")
                .get();
            for (var element in list) {
              var result = await FirebaseFirestore.instance
                  .collection("users")
                  .doc(element.phoneNumber)
                  .collection("tc")
                  .get();
              var user = list.firstWhere(
                  (element1) => element1.phoneNumber == element.phoneNumber);

              for (var element in result.docs) {
                Bildirimci a = Bildirimci.fromJson(element.data());
                user.addBildirimci(a);
              }




              for (var element2 in resultsub.docs) {
                if (element2.id.contains(element.phoneNumber ?? "")) {
                  user.startModel =
                      SubscriptionStartModel.fromJson(element2.data());
                  break;
                }
              }
            }

            setState(() {});
          }),
        ],
      ),
    );
  }
}
