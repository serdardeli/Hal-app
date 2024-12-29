import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hal_app/feature/helper/active_tc.dart';
import 'package:hal_app/project/cache/last_custom_notifications_cache_manager.dart';
import 'package:hal_app/project/model/uretici_model/uretici_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kartal/kartal.dart';

import '../../../../../project/model/custom_notification_save_model.dart/custom_notification_save_model.dart';
import '../../../../../project/model/urun/urun.dart';
import '../../../../../project/utils/widgets/expanded_card_item.dart';
import '../../../../../project/utils/widgets/expanded_card_item_for_last_mobile_notifications.dart';
import '../viewmodel/cubit/last_mobile_notifications_cubit.dart';

class LastMobileNotifications extends StatelessWidget {
  static const String name = "lastMobileNotifications";
  const LastMobileNotifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CupertinoNavigationBar(middle: Text("Son Yapılan Bildirimler")),
        body: ValueListenableBuilder(
          valueListenable: Hive.box<List<dynamic>>(
                  LastCustomNotificationSaveCacheManager.instance.key)
              .listenable(),
          builder:
              (BuildContext context, Box<List<dynamic>> box, Widget? child) {
            List<CustomNotificationSaveModel> list =
                LastCustomNotificationSaveCacheManager.instance
                    .getItem(ActiveTc.instance.activeTc);
            //   List<dynamic>   box.get(ActiveTc.instance.activeTc);

            list = list.reversed.toList();
            var longnum = 100500064965849;
            var num = 10000000;
            var longnum2 = 87965100421;
            NumberFormat myFormat = NumberFormat.decimalPattern('en_us');



            if(list.isEmpty){
              return const Center(child: Text("Son yapılan mobil bildirim bulunamadı."),);
            }
            return Padding(
              padding: context.padding.horizontalNormal,
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  Uretici? uretici;
                  if (list[index].uretici != null) {
                    uretici = Uretici.fromJson(
                        Map<String, dynamic>.from(list[index].uretici!));
                  }

                  List<Urun> urunList = [];
                  for (var element in list[index].urunList) {
                    urunList
                        .add(Urun.fromJson(Map<String, dynamic>.from(element)));
                  }
                  CustomNotificationSaveModel item = list[index];
                  return InkWell(
                    onTap: () {
                      showAwesomeDialog(context, item, urunList);
                    },
                    child: ExpandedCardItemLastMobileNotifications(
                      text: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              uretici == null
                                  ? "Toplama Mal"
                                  : (uretici.ureticiAdiSoyadi),
                              style: context.general.textTheme.bodyLarge
                                  ?.apply(color: Colors.green),
                              overflow: TextOverflow.ellipsis),
                          Text(urunList.first.urunAdi,
                              style: context.general.textTheme.bodySmall),
                        ],
                      ),
                      suffix: TextButton(
                        onPressed: () {
                          showAwesomeDialog(context, item, urunList);
                        },
                        style:
                            TextButton.styleFrom(backgroundColor: Colors.green),
                        child: Text("Detay",
                            style: context.general.textTheme.bodyLarge!
                                .apply(color: Colors.white)),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ));
  }

  List<Widget> buildSuccessfulTexts(List<Urun> urunList, BuildContext context) {
    List<Widget> list = [];
    NumberFormat myFormat = NumberFormat.decimalPattern('tr_tr');

    for (var element in urunList) {
      list.add(Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 10,
              child: ListTile(
                trailing: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                title: Text(element.urunAdi),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                            "Kilo: ${(myFormat.format(double.parse(element.urunMiktari)))} ${element.urunBirimAdi}"),
                        Text("   Fiyat: ${element.urunFiyati} TL"),
                      ],
                    ),
                    Text("Künye: ${element.kunyeNo ?? "boş künye"}"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ));
    }
    return list;
  }

  void showAwesomeDialog(BuildContext context, CustomNotificationSaveModel item,
      List<Urun> urunList) {
    AwesomeDialog(
        btnCancelText: "Kapat",
        btnOkText: "Whatsapp ile paylaş",
        btnCancelOnPress: () {
          //    Navigator.pop(context); //Named e dönüp düzeteceğim
        },
        btnOkOnPress: () async {
          //  Navigator.pop(context);
          await context
              .read<LastMobileNotificationsCubit>()
              .shareWithWhatsapp(item);
        },
        context: context,
        dialogType: DialogType.success,
        body: Center(
          child: Column(
            children: [
              Text("İşlem Başarılı", style: context.general.textTheme.titleLarge),
              //  Text(
              //    "Başarılı Künyeler ",
              //    style: context.general.textTheme.headline6,
              //  ),
              ...buildSuccessfulTexts(urunList, context),
              Padding(
                padding: context.padding.verticalLow,
                child: Text("Tarih: ${a(item.date ?? "")}",
                    style: context.general.textTheme.titleLarge),
              ),
              Padding(
                padding: context.padding.verticalLow,
                child: Text("Plaka: ${item.plaka}",
                    style: context.general.textTheme.titleLarge),
              )

              // state.response.kayitCevapList.state.response.message != null
              //     ? Text(state.response.message!.first)
              //     : const SizedBox(),
            ],
          ),
        )).show();
  }

  String a(String time) {
    if (time != "") {
      const dateTimeString = '2020-07-17T03:18:31.177769-04:00';

      final dateTime = DateTime.parse(time);

      final format = DateFormat('yyyy:MM:dd HH:mm');
      final clockString = format.format(dateTime);
      return clockString;
    }
    return "Tarih bulunamadı";
  }
}
