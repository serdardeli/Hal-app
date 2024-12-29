import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kartal/kartal.dart';

import '../../../../../project/service/firebase/firestore/firestore_service.dart';
import '../../../../../project/utils/widgets/settings_page_card_item.dart';
import '../../../../helper/scaffold_messager.dart';

class BackupPage extends StatelessWidget {
  const BackupPage({Key? key}) : super(key: key);
  static const String name = "backupPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(middle: Text("Yedekleme")),
      body: Padding(
        padding: context.padding.normal,
        child: SingleChildScrollView(
            child: Column(
          children: [
            SettingsCardItem(
                prefix: Icon(Icons.person_outline_outlined),
                text: Text("Kullanıcı Datalarını yedekle"),
                ontap: () async {
                  ScaffoldMessengerHelper.instance.showSuccessfulSnackBar(
                      context, "Yedekleme Başarılı ");

                  await FirestoreService.instance.saveAllUserData();
                }),
                SizedBox(height: context.general.mediaSize.height*.03,),
            SettingsCardItem(
                prefix: Icon(Icons.person_outline_outlined),
                text: Text("Kullanıcı Datalarını Çek"),
                ontap: () async {
                   ScaffoldMessengerHelper.instance.showSuccessfulSnackBar(
                     context, "Yükleme başarılı");

                  await FirestoreService.instance.fetchUserAllData();
                }),
          ],
        )),
      ),
    );
  }
}
