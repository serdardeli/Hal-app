import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hal_app/feature/helper/active_tc.dart';
import 'package:hal_app/project/cache/app_cache_manager.dart';
import 'package:hal_app/project/cache/bildirim_list_cache_manager_new.dart';
import 'package:hal_app/project/cache/bildirimci_cache_manager.dart';
import 'package:kartal/kartal.dart';
import 'package:meta/meta.dart';

import '../../../../../../core/enum/preferences_keys_enum.dart';
import '../../../../../../project/cache/depo_cache_manager.dart';
import '../../../../../../project/cache/hal_ici_isyeri_cache_manager.dart';
import '../../../../../../project/cache/sube_cache_manager.dart';
import '../../../../../../project/cache/user_cache_manager.dart';
import '../../../../../../project/model/bildirimci/bildirimci_model.dart';
import '../../../../../../project/model/custom_notification_save_model.dart/custom_notification_save_model.dart';
import '../../../../../../project/model/depo/depo_model.dart';
import '../../../../../../project/model/hal_ici_isyeri/hal_ici_isyeri_model.dart';
import '../../../../../../project/model/kayitli_kisi_model/kayitli_kisi_model.dart';
import '../../../../../../project/model/sube/sube_model.dart';
import '../../../../../../project/model/user/my_user_model.dart';
import '../../../../../../project/service/firebase/firestore/firestore_service.dart';
import '../../../../../../project/service/hal/bildirim_service.dart';
import '../../../../../../project/service/hal/genel_service.dart';

part 'saved_notifications_state.dart';
part './extension/check_gidecegi_yer_update.dart';

class SavedNotificationsCubit extends Cubit<SavedNotificationsState> {
  SavedNotificationsCubit() : super(SavedNotificationsInitial()) {
    updateFrequentNotificationsBackUpCheck();
   // checkGidecegiYerUpdateExtension();
  }
  List<HalIciIsyeri> halIciIsyerleriNew = [];
  List<Sube> subeler = [];
  List<Depo> depolar = [];
  KayitliKisi? kayitliKisi;

  final AppCacheManager _appCacheManager = AppCacheManager.instance;
  void emitInitial() => emit(SavedNotificationsInitial());
  Future<bool> checkIsFirstApp() async {
    bool isFirstApp = false;

    if (AppCacheManager.instance
            .getBoolValue(PreferencesKeys.IS_FIRST_APP.name) ==
        "true") {
      isFirstApp = true;
      await AppCacheManager.instance
          .putBoolItem(PreferencesKeys.IS_FIRST_APP.name, false);

      return true;
    }
    return false;
  }

  Future<void> updateFrequentNotificationsBackUpCheck() async {
    var result = await checkIsFirstApp();





    if (result) {
      _appCacheManager.putItem(
          PreferencesKeys.weeklyLastBackUpTime.name, DateTime.now().toString());
    } else {
//_appCacheManager.putItem(PreferencesKeys.ID_LIST_LAST_UPDATE.name,
      //    DateTime(2020, 1, 1).toString());
      String? date =
          _appCacheManager.getItem(PreferencesKeys.weeklyLastBackUpTime.name);
      if (date != null) {
        DateTime lastUpdate = DateTime.parse(date);
        DateTime now = DateTime.now();

        //    (1000 * 60));
        int difference =
            (now.millisecondsSinceEpoch - lastUpdate.millisecondsSinceEpoch) ~/
                (1000 *
                    60 *
                    60 *
                    24); //1000 * 60 dakika// * 60 * 24//1000 * 60 * 60 * 24





        if ((difference) >= 7) {


          updateFrequentNotifications().then((value) async {
            await FirestoreService.instance.saveAllUserData();
          });
          _appCacheManager.putItem(PreferencesKeys.weeklyLastBackUpTime.name,
              DateTime.now().toString());
        }
      } else {


        updateFrequentNotifications().then((value) async {
          await FirestoreService.instance.saveAllUserData();
        });
        _appCacheManager.putItem(PreferencesKeys.weeklyLastBackUpTime.name,
            DateTime.now().toString());
      }
    }
  }

  Future<void> updateFrequentNotifications() async {
    List<CustomNotificationSaveModel> notificationList =
        CustomNotificationSaveCacheManager.instance
            .getItem(ActiveTc.instance.activeTc);

    for (var element in notificationList) {




    }


    List<CustomNotificationSaveModel> sortedList =
        sortListCustomByWeeklyAddedCount(notificationList);
    for (var i = 0; i < sortedList.length; i++) {
      sortedList[i].totalAddedCount = (sortedList.length - i);
      sortedList[i].weeklyAddedCount = 0;
    }
    await CustomNotificationSaveCacheManager.instance
        .putItem(ActiveTc.instance.activeTc, sortedList);


    for (var element in sortedList) {




    }


    // GET ALL NOTIFICATIONS
    // SORT BY WEEKLY COUNT
    // REVERSE THE LIST AND ASSIGN THE TOTAL NUMBERS
    // RESET WEEKLY COUNTS
    // AND SAVE SORTED LIST
  }

  List<CustomNotificationSaveModel> sortListCustomByWeeklyAddedCount(
      List<dynamic> list) {
    List<CustomNotificationSaveModel> listForSort = [];
    for (var element in list) {
      if (element.runtimeType ==
          CustomNotificationSaveModel.getFakeModel().runtimeType) {
        listForSort.add(CustomNotificationSaveModel.fromJson(
            (element as CustomNotificationSaveModel).toJson()));
      } else {
        var newItem = CustomNotificationSaveModel.fromJson(
            Map<String, dynamic>.from(element));
        listForSort.add(newItem);
      }
    }
    int lengthOfArray = listForSort.length;
    for (int i = 0; i < lengthOfArray - 1; i++) {
      for (int j = 0; j < lengthOfArray - i - 1; j++) {
        if (listForSort[j].weeklyAddedCount == null) {
          listForSort[j].weeklyAddedCount = 0;
        }
        if (listForSort[j + 1].weeklyAddedCount == null) {
          listForSort[j + 1].weeklyAddedCount = 0;
        }
        if (listForSort[j].weeklyAddedCount! <
            listForSort[j + 1].weeklyAddedCount!) {
          // Swapping using temporary variable
          var temp = listForSort[j];
          listForSort[j] = listForSort[j + 1];
          listForSort[j + 1] = temp;
        }
      }
    }
    return (listForSort);
  }

  Map a = {
    "ACUR ACUR": {"UrunCinsId": "1166", "UrunId": "300"},
    "BADEM (YAŞ-TAZE) BADEM (YAŞ-TAZE)": {
      "UrunCinsId": "1220",
      "UrunId": "311"
    },
    "ANDİVA ANDİVA": {"UrunCinsId": "1187", "UrunId": "306"},
    "AVOKADO AVOKADO": {"UrunCinsId": "1214", "UrunId": "309"},
    "CURUBA CURUBA": {"UrunCinsId": "1310", "UrunId": "329"},
    "AYVA AYVA": {"UrunCinsId": "1217", "UrunId": "310"},
    "BALKABAĞI BALKABAĞI": {"UrunCinsId": "1229", "UrunId": "313"},
    "ANANAS ANANAS": {"UrunCinsId": "1184", "UrunId": "305"},
    "FEJOYA FEJOYA": {"UrunCinsId": "1445", "UrunId": "347"},
    "ADAÇAYI (YAŞ-TAZE) ADAÇAYI (YAŞ-TAZE)": {
      "UrunCinsId": "1169",
      "UrunId": "301"
    },
    "BAKLA TAZE SAKIZ": {"UrunCinsId": "1223", "UrunId": "312"},
    "BAKLA TAZE DİĞER": {"UrunCinsId": "1226", "UrunId": "312"},
    "AHUDUDU(FRAMBUAZ) AHUDUDU(FRAMBUAZ)": {
      "UrunCinsId": "1172",
      "UrunId": "302"
    },
    "BİBER SALÇALIK (KAPYA) BİBER SALÇALIK (KAPYA)": {
      "UrunCinsId": "1286",
      "UrunId": "322"
    },
    "DENİZ BÖRÜLCESİ(DENİZ OTU EGE OTU) DENİZ BÖRÜLCESİ (DENİZ OTU EGE OTU)": {
      "UrunCinsId": "1322",
      "UrunId": "333"
    },
    "ÇAĞLA ÇAĞLA": {"UrunCinsId": "1313", "UrunId": "330"},
    "BEYAZ LAHANA AZMAN": {"UrunCinsId": "1241", "UrunId": "317"},
    "BEYAZ LAHANA HİBRİT": {"UrunCinsId": "1244", "UrunId": "317"},
    "BEYAZ LAHANA DİĞER": {"UrunCinsId": "1247", "UrunId": "317"},
    "ELMA AMASYA ELMA AMASYA": {"UrunCinsId": "1394", "UrunId": "342"},
    "BİBER SİVRİ SÜS": {"UrunCinsId": "1256", "UrunId": "319"},
    "BİBER SİVRİ CİN": {"UrunCinsId": "1259", "UrunId": "319"},
    "BİBER SİVRİ KALİFORNİA": {"UrunCinsId": "1262", "UrunId": "319"},
    "BİBER SİVRİ KIL": {"UrunCinsId": "1265", "UrunId": "319"},
    "BİBER SİVRİ KÖYBİBERİ": {"UrunCinsId": "1268", "UrunId": "319"},
    "BİBER SİVRİ MACAR": {"UrunCinsId": "1271", "UrunId": "319"},
    "BİBER SİVRİ MEKSİKA": {"UrunCinsId": "1274", "UrunId": "319"},
    "BİBER SİVRİ DİĞER": {"UrunCinsId": "1277", "UrunId": "319"},
    "BÖRÜLCE TAZE BÖRÜLCE TAZE": {"UrunCinsId": "1298", "UrunId": "325"},
    "ALIÇ ALIÇ": {"UrunCinsId": "1181", "UrunId": "304"},
    "BROKOLİ BROKOLİ": {"UrunCinsId": "1301", "UrunId": "326"},
    "DOMATES YEŞİL(TURŞU)": {"UrunCinsId": "1328", "UrunId": "335"},
    "DOMATES CHERRY": {"UrunCinsId": "1331", "UrunId": "335"},
    "DOMATES BEEF": {"UrunCinsId": "1334", "UrunId": "335"},
    "DOMATES KOKTEYL": {"UrunCinsId": "1337", "UrunId": "335"},
    "DOMATES SALKIM": {"UrunCinsId": "1340", "UrunId": "335"},
    "DOMATES PEMBE": {"UrunCinsId": "1343", "UrunId": "335"},
    "DOMATES PETEMEK(ERİK)": {"UrunCinsId": "1346", "UrunId": "335"},
    "DOMATES AYAŞ": {"UrunCinsId": "1349", "UrunId": "335"},
    "DOMATES DİĞER": {"UrunCinsId": "1352", "UrunId": "335"},
    "ARMUT SANTAMARİ": {"UrunCinsId": "1190", "UrunId": "307"},
    "ARMUT ANKARA": {"UrunCinsId": "1193", "UrunId": "307"},
    "ARMUT DEVECİ": {"UrunCinsId": "1196", "UrunId": "307"},
    "ARMUT FRENK": {"UrunCinsId": "1199", "UrunId": "307"},
    "ARMUT AKÇA": {"UrunCinsId": "1202", "UrunId": "307"},
    "ARMUT MARGARİT": {"UrunCinsId": "1205", "UrunId": "307"},
    "ARMUT DİĞER": {"UrunCinsId": "1208", "UrunId": "307"},
    "BARBUNYA TAZE BARBUNYA TAZE": {"UrunCinsId": "1235", "UrunId": "315"},
    "GREYFURT KAN": {"UrunCinsId": "1457", "UrunId": "351"},
    "GREYFURT DİĞER": {"UrunCinsId": "1460", "UrunId": "351"},
    "BİBERİYE ROZMARİN": {"UrunCinsId": "1289", "UrunId": "323"},
    "BİBERİYE DİĞER": {"UrunCinsId": "1292", "UrunId": "323"},
    "ISIRGAN (YAŞ-TAZE) ISIRGAN (YAŞ-TAZE)": {
      "UrunCinsId": "1502",
      "UrunId": "361"
    },
    "EBEGÜMECİ EBEGÜMECİ": {"UrunCinsId": "1364", "UrunId": "338"},
    "ELMA STARKING ELMA, STARKİNG": {"UrunCinsId": "1397", "UrunId": "343"},
    "DEFNE YAPRAĞI (YAŞ-TAZE) DEFNE YAPRAĞI (YAŞ-TAZE)": {
      "UrunCinsId": "1319",
      "UrunId": "332"
    },
    "DUT KARA": {"UrunCinsId": "1358", "UrunId": "337"},
    "DUT DİĞER": {"UrunCinsId": "1361", "UrunId": "337"},
    "BRÜKSEL LAHANASI BRÜKSEL LAHANASI": {
      "UrunCinsId": "1304",
      "UrunId": "327"
    },
    "ELMA GRANNY SMITH ELMA GRANNY SMITH": {
      "UrunCinsId": "1391",
      "UrunId": "341"
    },
    "CİBES CİBES": {"UrunCinsId": "1307", "UrunId": "328"},
    "ÇİLEK ÇİLEK": {"UrunCinsId": "1316", "UrunId": "331"},
    "FRENK  ÜZÜMÜ FRENK ÜZÜMÜ": {"UrunCinsId": "1451", "UrunId": "349"},
    "BİBER ÇARLİSTON BİBER ÇARLİSTON": {"UrunCinsId": "1280", "UrunId": "320"},
    "BİBER DOLMALIK BİBER DOLMALIK": {"UrunCinsId": "1283", "UrunId": "321"},
    "KEREVİZ KEREVİZ": {"UrunCinsId": "1598", "UrunId": "377"},
    "HAVUÇ KIRMIZI": {"UrunCinsId": "1472", "UrunId": "355"},
    "HAVUÇ BEYPAZARI": {"UrunCinsId": "1475", "UrunId": "355"},
    "HAVUÇ İRİ (TAKOZ)": {"UrunCinsId": "1478", "UrunId": "355"},
    "HAVUÇ SİYAH": {"UrunCinsId": "1481", "UrunId": "355"},
    "HAVUÇ DİĞER": {"UrunCinsId": "1484", "UrunId": "355"},
    "İĞDE İĞDE": {"UrunCinsId": "1508", "UrunId": "363"},
    "KESTANE KESTANE": {"UrunCinsId": "1604", "UrunId": "379"},
    "ELMA GALA": {"UrunCinsId": "1367", "UrunId": "339"},
    "ELMA ARAPKIZI": {"UrunCinsId": "1370", "UrunId": "339"},
    "ELMA ARJANTİN": {"UrunCinsId": "1373", "UrunId": "339"},
    "ELMA BODUR": {"UrunCinsId": "1376", "UrunId": "339"},
    "ELMA EKŞİ": {"UrunCinsId": "1379", "UrunId": "339"},
    "ELMA FUJİ": {"UrunCinsId": "1382", "UrunId": "339"},
    "ELMA DİĞER": {"UrunCinsId": "1385", "UrunId": "339"},
    "ELMA GOLDEN ELMA GOLDEN": {"UrunCinsId": "1388", "UrunId": "340"},
    "ERİK PAPAZ (CAN)": {"UrunCinsId": "1403", "UrunId": "345"},
    "ERİK ANJELİK": {"UrunCinsId": "1406", "UrunId": "345"},
    "ERİK FREZE": {"UrunCinsId": "1409", "UrunId": "345"},
    "ERİK ALYANAK": {"UrunCinsId": "1412", "UrunId": "345"},
    "ERİK İTALYAN": {"UrunCinsId": "1415", "UrunId": "345"},
    "ERİK KIRMIZI": {"UrunCinsId": "1418", "UrunId": "345"},
    "ERİK MÜRDÜM(KARACA)": {"UrunCinsId": "1421", "UrunId": "345"},
    "ERİK DİĞER": {"UrunCinsId": "1424", "UrunId": "345"},
    "KABAK ÇEREZLİK KABAK ÇEREZLİK": {"UrunCinsId": "1535", "UrunId": "366"},
    "DOMATES SALÇALIK DOMATES SALÇALIK": {
      "UrunCinsId": "1355",
      "UrunId": "336"
    },
    "GUAVA GUAVA": {"UrunCinsId": "1466", "UrunId": "353"},
    "BAMYA TAZE BAMYA TAZE": {"UrunCinsId": "1232", "UrunId": "314"},
    "HÜNNAP HÜNNAP": {"UrunCinsId": "1499", "UrunId": "360"},
    "ENGİNAR ENGİNAR": {"UrunCinsId": "1400", "UrunId": "344"},
    "DEREOTU (YAŞ-TAZE) DEREOTU (YAŞ-TAZE)": {
      "UrunCinsId": "1325",
      "UrunId": "334"
    },
    "KABAK AMPUL": {"UrunCinsId": "1520", "UrunId": "365"},
    "KABAK KARA": {"UrunCinsId": "1523", "UrunId": "365"},
    "KABAK MİNİ": {"UrunCinsId": "1526", "UrunId": "365"},
    "KABAK SARI": {"UrunCinsId": "1529", "UrunId": "365"},
    "KABAK DİĞER": {"UrunCinsId": "1532", "UrunId": "365"},
    "HARDAL OTU (YAŞ-TAZE) HARDAL OTU (YAŞ-TAZE)": {
      "UrunCinsId": "1469",
      "UrunId": "354"
    },
    "KAYISI TOKALI": {"UrunCinsId": "1577", "UrunId": "375"},
    "KAYISI IĞDIR": {"UrunCinsId": "1580", "UrunId": "375"},
    "KAYISI MALATYA": {"UrunCinsId": "1583", "UrunId": "375"},
    "KAYISI MUT": {"UrunCinsId": "1586", "UrunId": "375"},
    "KAYISI ŞEKERPARE": {"UrunCinsId": "1589", "UrunId": "375"},
    "KAYISI DİĞER": {"UrunCinsId": "1592", "UrunId": "375"},
    "KARPUZ ÇEKİRDEKSİZ": {"UrunCinsId": "1556", "UrunId": "372"},
    "KARPUZ DİĞER": {"UrunCinsId": "1559", "UrunId": "372"},
    "KARAMBOLA KARAMBOLA": {"UrunCinsId": "1547", "UrunId": "370"},
    "FASULYE TAZE SARIKIZ": {"UrunCinsId": "1427", "UrunId": "346"},
    "FASULYE TAZE BONCUK": {"UrunCinsId": "1430", "UrunId": "346"},
    "FASULYE TAZE CİNO": {"UrunCinsId": "1433", "UrunId": "346"},
    "FASULYE TAZE ÇALI": {"UrunCinsId": "1436", "UrunId": "346"},
    "FASULYE TAZE AYŞE KADIN": {"UrunCinsId": "1439", "UrunId": "346"},
    "FASULYE TAZE DİĞER": {"UrunCinsId": "1442", "UrunId": "346"},
    "BEZELYE TAZE ARAKA": {"UrunCinsId": "1250", "UrunId": "318"},
    "BEZELYE TAZE DİĞER": {"UrunCinsId": "1253", "UrunId": "318"},
    "HİNDİBA ENDİVYEN HİNDİBA ENDİVYEN": {
      "UrunCinsId": "1490",
      "UrunId": "357"
    },
    "MİZUNA OTU MİZUNA OTU": {"UrunCinsId": "1745", "UrunId": "411"},
    "HİNDİSTAN CEVİZİ HİNDİSTAN CEVİZİ": {
      "UrunCinsId": "1496",
      "UrunId": "359"
    },
    "KEKİK (YAŞ-TAZE) KEKİK (YAŞ-TAZE)": {
      "UrunCinsId": "1595",
      "UrunId": "376"
    },
    "KAVUN KELEK": {"UrunCinsId": "1562", "UrunId": "373"},
    "KAVUN GALYA": {"UrunCinsId": "1565", "UrunId": "373"},
    "KAVUN KIRKAĞAÇ": {"UrunCinsId": "1568", "UrunId": "373"},
    "KAVUN DİĞER": {"UrunCinsId": "1571", "UrunId": "373"},
    "LYCHEE LYCHEE": {"UrunCinsId": "1670", "UrunId": "393"},
    "SEMİZOTU SEMİZOTU": {"UrunCinsId": "1871", "UrunId": "442"},
    "HİNDİBA RADİKA HİNDİBA RADİKA": {"UrunCinsId": "1493", "UrunId": "358"},
    "MAYDANOZ MAYDANOZ": {"UrunCinsId": "1724", "UrunId": "405"},
    "KAMKAT KAMKAT": {"UrunCinsId": "1541", "UrunId": "368"},
    "SALATALIK TURŞULUK SALATALIK TURŞULUK (KORNİŞON)": {
      "UrunCinsId": "1862",
      "UrunId": "439"
    },
    "MANGO MANGO": {"UrunCinsId": "1700", "UrunId": "399"},
    "MARUL GÖBEKLİ MARUL GÖBEKLİ( YAĞLI-KOP SALAT)": {
      "UrunCinsId": "1709",
      "UrunId": "402"
    },
    "LABADA LABADA": {"UrunCinsId": "1649", "UrunId": "390"},
    "KEREVİZ SAP KEREVİZ SAP": {"UrunCinsId": "1601", "UrunId": "378"},
    "MARUL KIVIRCIK KIVIRCIK (LOLOROSSO Y.)": {
      "UrunCinsId": "1715",
      "UrunId": "404"
    },
    "MARUL KIVIRCIK KIVIRCIK KIRMIZI(LOLOROSSO)": {
      "UrunCinsId": "1718",
      "UrunId": "404"
    },
    "MARUL KIVIRCIK DİĞER": {"UrunCinsId": "1721", "UrunId": "404"},
    "MERSİN(YABAN MERSİNİ) MERSİN (YABAN MERSİNİ)": {
      "UrunCinsId": "1736",
      "UrunId": "408"
    },
    "KİVİ KİVİ": {"UrunCinsId": "1637", "UrunId": "386"},
    "KUDRET NARI KUDRET NARI": {"UrunCinsId": "1640", "UrunId": "387"},
    "BÖĞÜRTLEN BÖĞÜRTLEN": {"UrunCinsId": "1295", "UrunId": "324"},
    "ZENCEFİL ZENCEFİL": {"UrunCinsId": "2003", "UrunId": "468"},
    "MANDALİNA KLEMANTIN MANDALİNA KLEMANTIN": {
      "UrunCinsId": "1691",
      "UrunId": "396"
    },
    "KAYA KORUĞU KAYA KORUĞU": {"UrunCinsId": "1574", "UrunId": "374"},
    "HİNDİBA (ÇİKORİ) HİNDİBA(ÇİKORİ)": {"UrunCinsId": "1487", "UrunId": "356"},
    "BERGAMOT BERGAMOT": {"UrunCinsId": "1238", "UrunId": "316"},
    "POMELO POMELO": {"UrunCinsId": "1811", "UrunId": "428"},
    "PİTAHAYA PİTAHAYA": {"UrunCinsId": "1808", "UrunId": "427"},
    "ŞEVKETİ BOSTAN ŞEVKETİ BOSTAN": {"UrunCinsId": "1898", "UrunId": "447"},
    "MUZ MUZ YERLİ(ANAMUR)": {"UrunCinsId": "1751", "UrunId": "413"},
    "MUZ DİĞER": {"UrunCinsId": "1754", "UrunId": "413"},
    "PASSIONFRUIT PASSIONFRUIT": {"UrunCinsId": "1784", "UrunId": "421"},
    "ISPANAK ISPANAK": {"UrunCinsId": "1505", "UrunId": "362"},
    "MANGOSTAN MANGOSTAN": {"UrunCinsId": "1703", "UrunId": "400"},
    "ÜZÜM ÇEKİRDEKSİZ ÜZÜM ÇEKİRDEKSİZ": {
      "UrunCinsId": "1982",
      "UrunId": "461"
    },
    "FESLEĞEN(REYHAN) FESLEĞEN(REYHAN)": {
      "UrunCinsId": "1448",
      "UrunId": "348"
    },
    "İNCİR BEYAZ": {"UrunCinsId": "1511", "UrunId": "364"},
    "İNCİR SİYAH": {"UrunCinsId": "1514", "UrunId": "364"},
    "İNCİR DİĞER": {"UrunCinsId": "1517", "UrunId": "364"},
    "MERCAN KÖŞK KUZU MAJARON": {"UrunCinsId": "1730", "UrunId": "407"},
    "MERCAN KÖŞK DİĞER": {"UrunCinsId": "1733", "UrunId": "407"},
    "KİRİŞ (ÇİRİŞ) KİRİŞ (ÇİRİŞ)": {"UrunCinsId": "1628", "UrunId": "383"},
    "MANDALİNA SATSUMA MANDALİNA SATSUMA": {
      "UrunCinsId": "1697",
      "UrunId": "398"
    },
    "LİMON YATAK": {"UrunCinsId": "1652", "UrunId": "391"},
    "LİMON ENTER": {"UrunCinsId": "1655", "UrunId": "391"},
    "LİMON LEMAS": {"UrunCinsId": "1658", "UrunId": "391"},
    "LİMON MAYER": {"UrunCinsId": "1661", "UrunId": "391"},
    "LİMON DİĞER": {"UrunCinsId": "1664", "UrunId": "391"},
    "TARHUN TARHUN": {"UrunCinsId": "1910", "UrunId": "451"},
    "YEŞİL SOĞAN YEŞİL SOĞAN": {"UrunCinsId": "1997", "UrunId": "466"},
    "PORTAKAL YAFA PORTAKAL YAFA": {"UrunCinsId": "1835", "UrunId": "432"},
    "ÜZÜM BEYAZ SULTANİYE": {"UrunCinsId": "1952", "UrunId": "460"},
    "ÜZÜM BEYAZ ÇAVUŞ": {"UrunCinsId": "1955", "UrunId": "460"},
    "ÜZÜM BEYAZ İNCİ": {"UrunCinsId": "1958", "UrunId": "460"},
    "ÜZÜM BEYAZ KARDİNAL": {"UrunCinsId": "1961", "UrunId": "460"},
    "ÜZÜM BEYAZ KIRMIZI": {"UrunCinsId": "1964", "UrunId": "460"},
    "ÜZÜM BEYAZ MOR": {"UrunCinsId": "1967", "UrunId": "460"},
    "ÜZÜM BEYAZ MÜŞKÜLE": {"UrunCinsId": "1970", "UrunId": "460"},
    "ÜZÜM BEYAZ REZAKİ": {"UrunCinsId": "1973", "UrunId": "460"},
    "ÜZÜM BEYAZ SİYAH": {"UrunCinsId": "1976", "UrunId": "460"},
    "ÜZÜM BEYAZ DİĞER": {"UrunCinsId": "1979", "UrunId": "460"},
    "PORTAKAL SIKMALIK PORTAKAL SIKMALIK": {
      "UrunCinsId": "1829",
      "UrunId": "430"
    },
    "NEKTARİN BEYAZ": {"UrunCinsId": "1763", "UrunId": "416"},
    "NEKTARİN BAYRAMİÇ BEYAZI": {"UrunCinsId": "1766", "UrunId": "416"},
    "NEKTARİN DİĞER": {"UrunCinsId": "1769", "UrunId": "416"},
    "KIZILCIK KIZILCIK": {"UrunCinsId": "1610", "UrunId": "381"},
    "MISIR İNCİRİ MISIR İNCİRİ": {"UrunCinsId": "1742", "UrunId": "410"},
    "LİMON OTU (LİMON GRASS) LİMON OTU(LİMON GRASS)": {
      "UrunCinsId": "1667",
      "UrunId": "392"
    },
    "TATLI PATATES TATLI PATATES": {"UrunCinsId": "1901", "UrunId": "448"},
    "SALATALIK SİLOR": {"UrunCinsId": "1853", "UrunId": "438"},
    "SALATALIK ÇENGELKÖY": {"UrunCinsId": "1856", "UrunId": "438"},
    "SALATALIK DİĞER": {"UrunCinsId": "1859", "UrunId": "438"},
    "YENİ DÜNYA(MALTA ERİĞİ) YENİ DÜNYA (MALTA ERİĞİ)": {
      "UrunCinsId": "1988",
      "UrunId": "463"
    },
    "KİŞNİŞ KİŞNİŞ": {"UrunCinsId": "1631", "UrunId": "384"},
    "KABAK ÇİÇEĞİ KABAK ÇİÇEĞİ": {"UrunCinsId": "1538", "UrunId": "367"},
    "SARIMSAK KURU SARIMSAK KURU": {"UrunCinsId": "1865", "UrunId": "440"},
    "MANDALİNA KING MANDALİNA KING": {"UrunCinsId": "1694", "UrunId": "397"},
    "NOHUT TAZE NOHUT TAZE": {"UrunCinsId": "1772", "UrunId": "417"},
    "PEPİNO PEPİNO": {"UrunCinsId": "1802", "UrunId": "425"},
    "MANTAR MANTAR": {"UrunCinsId": "1706", "UrunId": "401"},
    "PAPAYA PAPAYA": {"UrunCinsId": "1781", "UrunId": "420"},
    "SARIMSAK TAZE SARIMSAK TAZE": {"UrunCinsId": "1868", "UrunId": "441"},
    "RAMBOTAN RAMBOTAN": {"UrunCinsId": "1844", "UrunId": "435"},
    "SOĞAN KURU FRENK": {"UrunCinsId": "1874", "UrunId": "443"},
    "SOĞAN KURU BEYAZ(GÜMÜŞ)": {"UrunCinsId": "1877", "UrunId": "443"},
    "SOĞAN KURU KIRMIZI": {"UrunCinsId": "1880", "UrunId": "443"},
    "SOĞAN KURU MOR": {"UrunCinsId": "1883", "UrunId": "443"},
    "SOĞAN KURU DİĞER": {"UrunCinsId": "1886", "UrunId": "443"},
    "PATLICAN BOSTAN(TOPAK)": {"UrunCinsId": "1793", "UrunId": "423"},
    "PATLICAN DİĞER": {"UrunCinsId": "1796", "UrunId": "423"},
    "NAR NAR": {"UrunCinsId": "1760", "UrunId": "415"},
    "KARALAHANA KARALAHANA": {"UrunCinsId": "1544", "UrunId": "369"},
    "KUZUKULAĞI KUZUKULAĞI": {"UrunCinsId": "1646", "UrunId": "389"},
    "TAMARİND(DEMİRHİNDİ) TAMARİND(DEMİRHİNDİ)": {
      "UrunCinsId": "1907",
      "UrunId": "450"
    },
    "GRANADİLLA GRANADİLLA": {"UrunCinsId": "1454", "UrunId": "350"},
    "KIRMIZI LAHANA KIRMIZI LAHANA": {"UrunCinsId": "1607", "UrunId": "380"},
    "PAKCHOİ PAKCHOI": {"UrunCinsId": "1775", "UrunId": "418"},
    "PAZI PAZI": {"UrunCinsId": "1799", "UrunId": "424"},
    "ZERDALİ ZERDALİ": {"UrunCinsId": "2006", "UrunId": "469"},
    "SOYA FİLİZİ SOYA FİLİZİ": {"UrunCinsId": "1889", "UrunId": "444"},
    "TURP BEYAZ TURP BEYAZ": {"UrunCinsId": "1940", "UrunId": "456"},
    "KUŞKONMAZ KUŞKONMAZ": {"UrunCinsId": "1643", "UrunId": "388"},
    "MANDALİNA MİNOLA": {"UrunCinsId": "1676", "UrunId": "395"},
    "MANDALİNA İZMİR": {"UrunCinsId": "1679", "UrunId": "395"},
    "MANDALİNA RİZE": {"UrunCinsId": "1682", "UrunId": "395"},
    "MANDALİNA NOVA": {"UrunCinsId": "1685", "UrunId": "395"},
    "MANDALİNA DİĞER": {"UrunCinsId": "1688", "UrunId": "395"},
    "PIRASA PIRASA": {"UrunCinsId": "1805", "UrunId": "426"},
    "RAKULA RAKULA": {"UrunCinsId": "1841", "UrunId": "434"},
    "YER ELMASI YER ELMASI": {"UrunCinsId": "1991", "UrunId": "464"},
    "ŞEFTALİ ŞEFTALİ": {"UrunCinsId": "1895", "UrunId": "446"},
    "YILDIZ MEYVESİ YILDIZ MEYVESİ": {"UrunCinsId": "2000", "UrunId": "467"},
    "REZENE (YAŞ-TAZE) REZENE (YAŞ-TAZE)": {
      "UrunCinsId": "1847",
      "UrunId": "436"
    },
    "TURMERİC(ZERDEÇAL) TURMERİC(ZERDEÇAL)": {
      "UrunCinsId": "1922",
      "UrunId": "454"
    },
    "TRABZON HURMASI(CENNET ELMASI) TRABZON HURMASI(CENNET ELMASI)": {
      "UrunCinsId": "1919",
      "UrunId": "453"
    },
    "MADIMAK MADIMAK": {"UrunCinsId": "1673", "UrunId": "394"},
    "ÜVEZ ÜVEZ": {"UrunCinsId": "1949", "UrunId": "459"},
    "MARUL ICEBERG MARUL ICEBERG": {"UrunCinsId": "1712", "UrunId": "403"},
    "PANCAR PANCAR": {"UrunCinsId": "1778", "UrunId": "419"},
    "MISIR TAZE MISIR TAZE": {"UrunCinsId": "1739", "UrunId": "409"},
    "TURP OTU TURP OTU": {"UrunCinsId": "1943", "UrunId": "457"},
    "PSHALİS(GÜVEY FENERİ) PSHALİS(GÜVEY FENERİ)": {
      "UrunCinsId": "1838",
      "UrunId": "433"
    },
    "YEŞİL KABUKLU FINDIK YEŞİL KABUKLU FINDIK": {
      "UrunCinsId": "1994",
      "UrunId": "465"
    },
    "PATATES TAZE": {"UrunCinsId": "1787", "UrunId": "422"},
    "PATATES DİĞER": {"UrunCinsId": "1790", "UrunId": "422"},
    "PORTAKAL VALENCİA": {"UrunCinsId": "1814", "UrunId": "429"},
    "PORTAKAL FİNİKE": {"UrunCinsId": "1817", "UrunId": "429"},
    "PORTAKAL ÇAVDIR": {"UrunCinsId": "1820", "UrunId": "429"},
    "PORTAKAL KAN": {"UrunCinsId": "1823", "UrunId": "429"},
    "PORTAKAL DİĞER": {"UrunCinsId": "1826", "UrunId": "429"},
    "MELİSA (OĞUL OTU YAŞ-TAZE) MELİSA (OĞUL OTU YAŞ-TAZE)": {
      "UrunCinsId": "1727",
      "UrunId": "406"
    },
    "NANE NANE": {"UrunCinsId": "1757", "UrunId": "414"},
    "ŞALGAM ŞALGAM": {"UrunCinsId": "1892", "UrunId": "445"},
    "KİVANO KİVANO": {"UrunCinsId": "1634", "UrunId": "385"},
    "GUANABANA GUANABANA": {"UrunCinsId": "1463", "UrunId": "352"},
    "TAMARİLLO TAMARİLLO": {"UrunCinsId": "1904", "UrunId": "449"},
    "MUŞMULA MUŞMULA": {"UrunCinsId": "1748", "UrunId": "412"},
    "TERE TERE FİLİZİ": {"UrunCinsId": "1913", "UrunId": "452"},
    "TERE DİĞER": {"UrunCinsId": "1916", "UrunId": "452"},
    "TURP KIRMIZI": {"UrunCinsId": "1925", "UrunId": "455"},
    "TURP ÇİN": {"UrunCinsId": "1928", "UrunId": "455"},
    "TURP FINDIK": {"UrunCinsId": "1931", "UrunId": "455"},
    "TURP JAPON": {"UrunCinsId": "1934", "UrunId": "455"},
    "TURP SİYAH": {"UrunCinsId": "1937", "UrunId": "455"},
    "PORTAKAL WASHİNGTON PORTAKAL WASHİNGTON": {
      "UrunCinsId": "1832",
      "UrunId": "431"
    },
    "TURUNÇ TURUNÇ": {"UrunCinsId": "1946", "UrunId": "458"},
    "KİRAZ SALİHLİ": {"UrunCinsId": "1613", "UrunId": "382"},
    "KİRAZ BURLENT": {"UrunCinsId": "1616", "UrunId": "382"},
    "KİRAZ BEYAZ": {"UrunCinsId": "1619", "UrunId": "382"},
    "KİRAZ NAPOLYON": {"UrunCinsId": "1622", "UrunId": "382"},
    "KİRAZ DİĞER": {"UrunCinsId": "1625", "UrunId": "382"},
    "ROKA ROKA": {"UrunCinsId": "1850", "UrunId": "437"},
    "KARNABAHAR MOR": {"UrunCinsId": "1550", "UrunId": "371"},
    "KARNABAHAR DİĞER": {"UrunCinsId": "1553", "UrunId": "371"},
    "VİŞNE VİŞNE": {"UrunCinsId": "1985", "UrunId": "462"},
    "ALABAŞ(KOHLRABİ) KIRMIZI": {"UrunCinsId": "1175", "UrunId": "303"},
    "ALABAŞ(KOHLRABİ) BEYAZ": {"UrunCinsId": "1178", "UrunId": "303"},
    "ASMA YAPRAĞI ASMA YAPRAĞI": {"UrunCinsId": "1211", "UrunId": "308"}
  };
}
