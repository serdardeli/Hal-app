import 'package:bloc/bloc.dart';
import 'package:hal_app/project/model/custom_notification_save_model.dart/custom_notification_save_model.dart';
import 'package:hal_app/project/model/urun/urun.dart';
import 'package:meta/meta.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

part 'last_mobile_notifications_state.dart';

class LastMobileNotificationsCubit extends Cubit<LastMobileNotificationsState> {
  LastMobileNotificationsCubit() : super(LastMobileNotificationsInitial());
  shareWithWhatsapp(CustomNotificationSaveModel model) async {
    //adı künye plaka kunye

    String messages = "";
    model.urunList.forEach((element) {
      Urun urun = Urun.fromJson(Map<String, dynamic>.from(element));
      var message =
          "Ürün:${urun.urunAdi}\nMiktar:${urun.urunMiktari} ${urun.urunBirimAdi}\nPlaka:${model.plaka}\nKunye No:${urun.kunyeNo ?? "boş"}\n";
      messages = messages + message;
      messages = messages + "\n";
    });
    messages +=
        "Hks Bildir mobil uygulamasından gönderilmiştir.\nhttps://www.hksbildir.net";
    await WhatsappShare.share(
      text: messages,
      //  linkUrl: 'https://flutter.dev/',
      phone: '900',
    );
  }
}
