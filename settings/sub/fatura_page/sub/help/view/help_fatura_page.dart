import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kartal/kartal.dart';

class HelpFaturaPage extends StatelessWidget {
  static final String name = "helpFaturaPage";
  const HelpFaturaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text("E-Belge Aktivasyon"),
      ),
      body: Padding(
        padding: context.padding.normal,
        child: Column(
          children: [
            Text(
                "E-Belge işlemlerinde kurgumuzu çift entegratör olarak yapmış bulunmaktayız. Yetkili entegratör firma MYSOFT DİJİTAL DÖNÜŞÜM firması ile çalışmaktayız. Mali Mühürünüzü bilgisayarınıza takıp 0 850 600 06 61 müşteri hizmetlerini aradığınızda birkaç dakika içinde aktivasyon işlemi gerçekleşecektir. Daha sonrasında size verilen şifreyi Mali Müşavirinize ilettiğinizde tüm resmi evraklarınıza ulaşabilecektir. Mevcut entegratör firmanız ve programınız aynı devam edecektir,  HKS Bildir uygulamasından yapılan e-belge işlemlerinde 2. Entegratör Firma ile çalışmış olacaksınız."),
            Padding(
              padding: context.padding.verticalNormal,
              child: SelectableText("0 850 600 06 61",
                  style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }
}
