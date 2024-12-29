import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hal_app/feature/settings/sub/fatura_page/sub/driver/view/driver_page.dart';
import 'package:hal_app/feature/settings/sub/fatura_page/sub/giden_fatura_page/view/giden_fatura_page.dart';
import 'package:hal_app/feature/settings/sub/fatura_page/sub/help/view/help_fatura_page.dart';
import 'package:hal_app/feature/settings/sub/fatura_page/sub/view/mysoft_user_page.dart';
import 'package:kartal/kartal.dart';

import '../../../../../project/utils/widgets/settings_page_card_item.dart';

class FaturaPage extends StatelessWidget {
  static const String name = "faturaPage";
  const FaturaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(middle: Text("Fatura")),
      body: Padding(
        padding: context.padding.horizontalLow,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SettingsCardItem(
                  prefix: const Icon(Icons.person_outline_outlined),
                  text: const Text("MySoft Bilgilerini Giriniz"),
                  ontap: () {
                    Navigator.pushNamed(context, MySoftUserPage.name);
                  }),
              SettingsCardItem(
                  prefix: const Icon(Icons.person_outline_outlined),
                  text: const Text("Sürücüler"),
                  ontap: () {
                    Navigator.pushNamed(context, DriverGeneral.name);
                  }),
              SettingsCardItem(
                  prefix: const Icon(Icons.person_outline_outlined),
                  text: const Text("Giden Faturalar"),
                  ontap: () {
                    Navigator.pushNamed(context, GidenFaturaPage.name);
                  }),
              SettingsCardItem(
                  prefix: const Icon(Icons.person_outline_outlined),
                  text: const Text("E-Belge Aktivasyon"),
                  ontap: () {
                    Navigator.pushNamed(context, HelpFaturaPage.name);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
