// dropdown done

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hal_app/core/utils/dropdown2_style/dropdown2_style.dart';
import 'package:hal_app/project/cache/musteri_list_cache_manager.dart';
import 'package:hal_app/project/model/musteri_model/musteri_model.dart';
import 'package:hal_app/project/utils/component/dropdown2_driver_search.dart';
import 'package:hal_app/project/utils/component/dropdown2_musteri_search.dart';
import 'package:hal_app/project/utils/widgets/custom_dropdown2.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kartal/kartal.dart';
import 'package:turkish/turkish.dart';

import '../../../../../../../project/cache/driver_list_cache_manager.dart';
import '../../../../../../../project/cache/musteri_depo_cache_manager.dart';
import '../../../../../../../project/cache/musteri_hal_ici_isyeri_cache_manager.dart';
import '../../../../../../../project/cache/musteri_sube_cache_manager.dart';
import '../../../../../../../project/cache/mysoft_user_cache_mananger.dart';
import '../../../../../../../project/model/MySoft_user_model/mysoft_user_model.dart';
import '../../../../../../../project/model/bildirim_kayit_response_model.dart/sub/bildirim_kayit_cevap_model.dart';
import '../../../../../../../project/model/depo/depo_model.dart';
import '../../../../../../../project/model/driver_model/driver_model.dart';
import '../../../../../../../project/model/hal_ici_isyeri/hal_ici_isyeri_model.dart';
import '../../../../../../../project/model/malin_gidecegi_yer/malin_gidecegi_yer_model.dart';
import '../../../../../../../project/model/referans_kunye/referans_kunye_model.dart';
import '../../../../../../../project/model/sube/sube_model.dart';
import '../../../../../../../project/utils/widgets/dropdown_selection.dart';
import '../../../../../../helper/active_tc.dart';
import '../../../../../../helper/scaffold_messager.dart';
import '../../../../../viewmodel/cubit/home_cubit.dart';
import '../viewmodel/cubit/satis_cubit.dart';

class SatisPage extends StatelessWidget {
  const SatisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            BlocConsumer<SatisCubit, SatisState>(
              listener: blocListener,
              builder: (context, state) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: context.padding.horizontalNormal,
                          child: buildCustomerNameField(context),
                        ),
                        buildSelectedCustomerAdjectiveDropDown(context),
                        //malin gideceği yeri seç
                        //kişiye ait yerleri çek
                        //marketse dağıtım merkezlerini filtrele bir taneyse gösterme
                        //market değilse gideceği her yeri göster
                      ],
                    ),
                    buildMalinGidecegiYerDropDown(context),
                    context.read<SatisCubit>().selectedMusteri == null
                        ? const SizedBox()
                        : Column(
                            children: [
                              //market
                              //

                              buildDateField(context),
                              sorgulamaAraligiError(),
//satış-irsaliye
                              buildKunyeSorgulama(context),
                              buildTable2(context),
                            ],
                          )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  BlocBuilder<SatisCubit, SatisState> sorgulamaAraligiError() {
    return BlocBuilder<SatisCubit, SatisState>(
      builder: (context, state) {
        int difference = context
            .read<SatisCubit>()
            .endDay
            .difference(context.read<SatisCubit>().startDay)
            .inDays;
        if (difference > 90) {
          return const Text(
            "Sorgulama aralığı 3 aydan büyük olamaz",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  void blocListener(BuildContext context, SatisState state) {
    if (state is SatisLoading) {
      EasyLoading.instance
        ..indicatorType = EasyLoadingIndicatorType.pouringHourGlass
        ..loadingStyle = EasyLoadingStyle.light
        ..userInteractions = false;
      EasyLoading.show(status: 'HKS Bekleniyor...');
    } else {
      EasyLoading.dismiss();
    }
    if (state is SatisError) {
      ScaffoldMessengerHelper.instance
          .showErrorSnackBar(context, state.message);
    }
    if (state is SatisSuccessHasSomeError) {
      if (state.response.kayitCevapList == null) {}
      List<Widget> basarili =
          buildSuccessfulTexts(state.response.kayitCevapList!, context);

      AwesomeDialog(
          btnCancelText: "Kapat",
          btnOkText: "Whatsapp ile paylaş",
          btnCancelOnPress: () {
            context.read<SatisCubit>().clearFaturaInfo();
            //    Navigator.pop(context); //Named e dönüp düzeteceğim
          },
          btnOkOnPress: () async {
            context.read<SatisCubit>().clearFaturaInfo();

            //  Navigator.pop(context);
            await context.read<SatisCubit>().shareWithWhatsapp(state.response);
          },
          context: context,
          dialogType: DialogType.error,
          body: Center(
            child: Column(
              children: [
                Text(
                  "Başarız Künyeler ",
                  style: context.general.textTheme.titleLarge,
                ),

                ...buildErrorTexts(state.response.kayitCevapList!, context),
                basarili.isNotEmpty
                    ? Text(
                        "Başarılı Künyeler ",
                        style: context.general.textTheme.titleLarge,
                      )
                    : const SizedBox(),
                ...basarili,
                Padding(
                  padding: context.padding.low * 1.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            "E-Müstahsil  ",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "E-İrsaliye  ",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          context.read<SatisCubit>().isIrsaliyeKesSuccess
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const SizedBox(),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "E-Fatura  ",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          context.read<SatisCubit>().isFaturaKesSuccess
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ],
                  ),
                )
                // state.response.kayitCevapList.state.response.message != null
                //     ? Text(state.response.message!.first)
                //     : const SizedBox(),
              ],
            ),
          )).show();

      ScaffoldMessengerHelper.instance
          .showErrorSnackBar(context, "Bildirim başarısız");
    }
    if (state is SatisCompletelySuccess) {
      AwesomeDialog(
          btnCancelText: "Kapat",
          btnOkText: "Whatsapp ile paylaş",
          btnCancelOnPress: () {
            context.read<SatisCubit>().clearFaturaInfo();

            //    Navigator.pop(context); //Named e dönüp düzeteceğim
          },
          btnOkOnPress: () async {
            context.read<SatisCubit>().clearFaturaInfo();

            //  Navigator.pop(context);
            await context.read<SatisCubit>().shareWithWhatsapp(state.response);
          },
          context: context,
          dialogType: DialogType.success,
          body: Center(
            child: Column(
              children: [
                Text(
                  "İşlem Başarılı",
                  style: context.general.textTheme.titleLarge,
                ),
                //  Text(
                //    "Başarılı Künyeler ",
                //    style: context.general.textTheme.headline6,
                //  ),
                ...buildSuccessfulTexts(
                    state.response.kayitCevapList!, context),
                Padding(
                  padding: context.padding.low * 1.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            "E-Müstahsil  ",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "E-İrsaliye  ",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          context.read<SatisCubit>().isIrsaliyeKesSuccess
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const SizedBox(),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "E-Fatura  ",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          context.read<SatisCubit>().isFaturaKesSuccess
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ],
                  ),
                )
                // state.response.kayitCevapList.state.response.message != null
                //     ? Text(state.response.message!.first)
                //     : const SizedBox(),
              ],
            ),
          )).show();
      ScaffoldMessengerHelper.instance
          .showSuccessfulSnackBar(context, "Bildirim başarılı");
    }
  }

  List<Widget> buildSuccessfulTexts(
      List<BildirimKayitCevapModel> cevapList, BuildContext context) {
    List<Widget> list = [];
    for (var element in cevapList) {
      if (!(element.kunyeNo == "0" || element.kunyeNo == null)) {
        String malAdi = "";
        context.read<SatisCubit>().getMallar.forEach((key, value) {
          if (element.malinId == key) {
            malAdi = value;
          }
        });
        list.add(Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 10,
                child: ListTile(
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text("$malAdi \nPlaka: ${element.aracPlakaNo}"),
                  subtitle: Text("Kunye: ${element.kunyeNo ?? "boş künye"}"),
                ),
              ),
            ),
          ],
        ));
      }
    }
    return list;
  }

  List<Widget> buildErrorTexts(
      List<BildirimKayitCevapModel> cevapList, BuildContext context) {
    List<Widget> list = [];
    for (var element in cevapList) {
      if ((element.kunyeNo == "0" || element.kunyeNo == null)) {
        list.add(Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 10,
                child: ListTile(
                  trailing: const Icon(
                    Icons.error,
                  ),
                  title: const Text("Error"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Kunye: ${element.kunyeNo ?? "boş künye"}"),
                      Text(
                        "Hata Mesajı: ${element.message ?? "boş mesaj"}",
                        style: context.general.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
      }
    }
    return list;
  }

  Widget buildMalinGidecegiYerDropDown(BuildContext context) {
    if (context.read<SatisCubit>().selectedMusteri != null &&
        context.read<SatisCubit>().selectedMusteri!.isregisteredToHks) {
      List<String> nameList = [];
      List<GidecegiYer> gidecegiYerList = [];
      List<GidecegiYer> dagitimMerkezleri = [];

      List<Sube> subeler = MusteriSubelerCacheManager.instance
          .getItem(context.read<SatisCubit>().selectedMusteri!.musteriTc);
      List<Depo> depolar = MusteriDepolarCacheManager.instance
          .getItem(context.read<SatisCubit>().selectedMusteri!.musteriTc);
      List<HalIciIsyeri> halIciIsyerleri = MusteriHalIciIsyeriCacheManager
          .instance
          .getItem(context.read<SatisCubit>().selectedMusteri!.musteriTc);
      if ((subeler.length + depolar.length + halIciIsyerleri.length) == 0) {
        return const Text(
            "Gidilecek yer bulunumadı lütfen ayarlardan kullanıcı bilgilerini güncelleyiniz",
            style: TextStyle(color: Colors.red));
      } else if ((subeler.length + depolar.length + halIciIsyerleri.length) ==
          1) {
        for (var element in subeler) {
          context.read<SatisCubit>().gidecegiYer = GidecegiYer(
              type: "Şube",
              name: element.adres.toString(),
              isletmeTuru: element.isletmeTuruAdi ?? "null",
              isletmeTuruId: element.isletmeTuruId ?? "null",
              isyeriId: element.subeId ?? "null",
              adres: element.adres.toString());
        }
        for (var element in depolar) {
          context.read<SatisCubit>().gidecegiYer = GidecegiYer(
              type: "Depo",
              name: element.adres.toString(),
              isletmeTuru: element.isletmeTuruAdi ?? "null",
              isletmeTuruId: element.isletmeTuruId ?? "null",
              isyeriId: element.depoId ?? "null",
              adres: element.adres.toString());
        }
        for (var element in halIciIsyerleri) {
          context.read<SatisCubit>().gidecegiYer = GidecegiYer(
              type: "Hal içi işyeri",
              name: element.isyeriAdi.toString(),
              isletmeTuru: element.isletmeTuruAdi,
              isletmeTuruId: element.isletmeTuruId,
              isyeriId: element.isyeriId ?? "null",
              adres: element.halAdi.toString());
        }
        return const SizedBox();
      } else {
        for (var element in subeler) {
          gidecegiYerList.add(GidecegiYer(
              type: "Şube",
              name: element.adres.toString(),
              isletmeTuru: element.isletmeTuruAdi ?? "null",
              isletmeTuruId: element.isletmeTuruId ?? "null",
              isyeriId: element.subeId ?? "null",
              adres: element.adres.toString()));
        }
        for (var element in depolar) {
          gidecegiYerList.add(GidecegiYer(
              type: "Depo",
              name: element.adres.toString(),
              isletmeTuru: element.isletmeTuruAdi ?? "null",
              isletmeTuruId: element.isletmeTuruId ?? "null",
              isyeriId: element.depoId ?? "null",
              adres: element.adres.toString()));
        }
        for (var element in halIciIsyerleri) {
          gidecegiYerList.add(GidecegiYer(
              type: "Hal içi işyeri",
              name: element.isyeriAdi.toString(),
              isletmeTuru: element.isletmeTuruAdi,
              isletmeTuruId: element.isletmeTuruId,
              isyeriId: element.isyeriId ?? "null",
              adres: element.halAdi.toString()));
        }
      }
      if (context
              .read<SatisCubit>()
              .selectedSatisYapilacakSifatName
              ?.toLowerCaseTr() ==
          "market") {
        for (var element in gidecegiYerList) {
          if (element.isletmeTuru.toLowerCaseTr() == "dağıtım merkezi" ||
              element.isletmeTuruId.toLowerCaseTr() == "12") {
            dagitimMerkezleri.add(element);
          }
        }
        if (dagitimMerkezleri.isEmpty) {
        } else if (dagitimMerkezleri.length == 1) {
          context.read<SatisCubit>().gidecegiYer = dagitimMerkezleri.first;
          return const SizedBox();
        } else {
          if (context.read<SatisCubit>().gidecegiYer != null) {
            if (!gidecegiYerList
                .contains(context.read<SatisCubit>().gidecegiYer)) {
              context.read<SatisCubit>().gidecegiYer = null;
            }
          }
          return Padding(
            padding: context.padding.verticalLow,
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                dropdownStyleData: DropDown2Style.dropdownStyleData(context,
                    width: context.general.mediaSize.width * .9),
                buttonStyleData: DropDown2Style.buttonStyleData(context,
                    width: context.general.mediaSize.width * .9),
                hint: Text('Gidilecek Yer Seç',
                    style: TextStyle(
                        fontSize: 14, color: Theme.of(context).hintColor)),
                items: dagitimMerkezleri
                    .map((item) => DropdownMenuItem<GidecegiYer>(
                          value: item,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("  ${item.type}  ${item.isletmeTuru}"),
                              Text(
                                "   ${item.name}",
                                style: const TextStyle(
                                    fontSize: 14,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
                value: context.read<SatisCubit>().gidecegiYer,
                onChanged: (value) {
                  context.read<SatisCubit>().gidecegiYer =
                      (value as GidecegiYer);
                  context.read<SatisCubit>().gidecegiYerSelected();
                },
              ),
            ),
          );
        }
      }
      if (context.read<SatisCubit>().gidecegiYer != null) {
        if (!gidecegiYerList.contains(context.read<SatisCubit>().gidecegiYer)) {
          context.read<SatisCubit>().gidecegiYer = null;
        }
      }
      return Padding(
        padding: context.padding.verticalLow,
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            dropdownStyleData: DropDown2Style.dropdownStyleData(context,
                width: context.general.mediaSize.width * .9),
            buttonStyleData: DropDown2Style.buttonStyleData(context,
                width: context.general.mediaSize.width * .9),
            hint: Text('Gidilecek Yer Seç',
                style: TextStyle(
                    fontSize: 14, color: Theme.of(context).hintColor)),
            items: gidecegiYerList
                .map((item) => DropdownMenuItem<GidecegiYer>(
                      value: item,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("  ${item.type}  ${item.isletmeTuru}"),
                          Text(
                            "   ${item.name}",
                            style: const TextStyle(
                                fontSize: 14, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ))
                .toList(),
            value: context.read<SatisCubit>().gidecegiYer,
            onChanged: (value) {
              context.read<SatisCubit>().gidecegiYer = (value as GidecegiYer);
              context.read<SatisCubit>().gidecegiYerSelected();
            },
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget buildSelectedCustomerAdjectiveDropDown(BuildContext context) {
    if (context.read<SatisCubit>().selectedMusteri != null &&
        context.read<SatisCubit>().selectedMusteri!.isregisteredToHks) {
      if (context
              .read<SatisCubit>()
              .musterideOlanSatisYapilabilecekSifatlar
              .length >
          1) {
        return Padding(
          padding: context.padding.verticalLow,
          child: CustomDropdownButton2(
            hint: 'Gidecek Kişi Sıfatı',
            itemHeight: 60,
            dropdownItems: context
                .read<SatisCubit>()
                .musterideOlanSatisYapilabilecekSifatlar
                .values
                .toList(),
            buttonWidth: context.general.mediaSize.width * .4,
            icon: const Icon(Icons.arrow_drop_down_sharp, size: 24),
            value: context.watch<SatisCubit>().selectedSatisYapilacakSifatName,
            onChanged: (value) {
              context.read<SatisCubit>().selectedSatisYapilacakSifatName =
                  value!;

              context.read<SatisCubit>().satisYapilacakSifatSelected();
            },
          ),
        );
      } else {
        return const SizedBox();
      }
    } else {
      return const SizedBox();
    }
  }

  BlocBuilder<SatisCubit, SatisState> buildTable2(BuildContext context) {
    return BlocBuilder<SatisCubit, SatisState>(
      builder: (context, state) {
        return context.read<SatisCubit>().selectedKunyeler.ext.isNullOrEmpty
            ? Container()
            : Column(
                children: [
                  Text(
                      "Toplam Künye Sayısı ${context.watch<SatisCubit>().selectedKunyeler.length}"),
                  Padding(
                    padding: context.padding.horizontalNormal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Tüm Fiyatlara Uygula"),
                        Checkbox(
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                            value: context.read<SatisCubit>().fiyatTumunuSec,
                            onChanged: (value) {
                              context.read<SatisCubit>().fiyatTumunuSec =
                                  value!;
                              context.read<SatisCubit>().emitInitialState();
                            }),
                        context.read<SatisCubit>().fiyatTumunuSec
                            ? Form(
                                key:
                                    context.read<SatisCubit>().allPricesFormKey,
                                child: Expanded(
                                  child: TextFormField(
                                    autovalidateMode: AutovalidateMode.always,
                                    keyboardType: Platform.isAndroid
                                        ? TextInputType.number
                                        : TextInputType.datetime,
                                    maxLines: 1,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        value = "0";
                                      }

                                      value = value.replaceAll(",", ".");
                                      value = value.trim();

                                      if (value.trim() != "") {
                                        if (!context
                                            .read<SatisCubit>()
                                            .isNumeric(value.trim())) {
                                          return "rakam ve . , kullanabilirsiniz";
                                        }
                                      }
                                      if (value == "" || value == "0") {
                                        value = "0";
                                        context
                                            .read<SatisCubit>()
                                            .selectedKunyeler
                                            .forEach((element) {
                                          element.gonderilmekIstenenFiyat =
                                              value;
                                        });
                                        return "Fiyat Boş Olamaz";
                                      }

                                      if (!(value == null)) {
                                        if (value == "") {
                                          value = "0";
                                        }

                                        if (double.parse(value) >= 0) {
                                          if (context
                                              .read<SatisCubit>()
                                              .fiyatTumunuSec) {
                                            context
                                                .read<SatisCubit>()
                                                .selectedKunyeler
                                                .forEach((element) {
                                              element.gonderilmekIstenenFiyat =
                                                  value;
                                            });
                                          }

                                          //  e.gonderilmekIstenenFiyat = value;
                                        }
                                      }

                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: context.padding.low,
                                      constraints: BoxConstraints(
                                          maxHeight:
                                              context.sized.normalValue * 3),
                                      hintText: "Fiyat Giriniz",
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50 +
                        (context.read<SatisCubit>().selectedKunyeler.length *
                            60),
                    child: DataTable2(
                        dataRowHeight: 60,
                        headingRowHeight: 50,
                        columnSpacing: 12,
                        horizontalMargin: 12,
                        // minWidth: 600,
                        showBottomBorder: true,
                        columns: const [
                          DataColumn2(
                            label: Text('Ürün Adı'),
                          ),
                          DataColumn(label: Text('Miktar')),
                          DataColumn(label: Text('Fiyat')),
                          DataColumn2(
                            label: Icon(
                              Icons.delete_forever_outlined,
                              color: Colors.green,
                            ),
                            fixedWidth: 30,
                            size: ColumnSize.S,
                          ),
                        ],
                        rows: <DataRow>[
                          ...(context.read<SatisCubit>().selectedKunyeler.map(
                            (e) {
                              return DataRow(cells: <DataCell>[
                                DataCell(Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.malinAdi ?? "BOŞ",
                                      overflow: TextOverflow.visible,
                                      style: context
                                          .general.textTheme.labelSmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      e.malinAdi ?? "BOŞ",
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          context.general.textTheme.labelSmall,
                                    )
                                  ],
                                )),
                                DataCell(Padding(
                                  padding: context.padding.verticalLow,
                                  child: TextFormField(
                                    autovalidateMode: AutovalidateMode.always,
                                    keyboardType: Platform.isAndroid
                                        ? TextInputType.number
                                        : TextInputType.datetime,
                                    maxLines: 1,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        value = "0";
                                      }
                                      value = value.replaceAll(",", ".");
                                      value = value.trim();

                                      if (value.trim() != "") {
                                        if (!context
                                            .read<SatisCubit>()
                                            .isNumeric(value.trim())) {
                                          return "rakam ve . , kullanabilirsiniz";
                                        }
                                      }
                                      if (!(double.parse(
                                              (value.isEmpty || value == "")
                                                  ? e.kalanMiktar!
                                                  : value) <=
                                          double.parse(e.kalanMiktar!))) {
                                        return "büyük değer";
                                      }

                                      if (!(value == null)) {
                                        if (value == "") {
                                          value = "0";
                                        }

                                        if (double.parse(value) >= 0) {
                                          e.gonderilmekIstenenMiktar = value;
                                        }
                                      }

                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: context.padding.low,
                                      constraints: BoxConstraints(
                                          maxHeight:
                                              context.sized.normalValue * 3),
                                      hintText:
                                          "${e.kalanMiktar ?? "boş"} ${e.malinMiktarBirimAd ?? "boş"}",
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                )),
                                DataCell((context
                                        .read<SatisCubit>()
                                        .fiyatTumunuSec)
                                    ? const SizedBox()
                                    : Padding(
                                        padding: context.padding.verticalLow,
                                        child: TextFormField(
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                          keyboardType: Platform.isAndroid
                                              ? TextInputType.number
                                              : TextInputType.datetime,
                                          maxLines: 1,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              value = "0";
                                            }
                                            value = value.replaceAll(",", ".");
                                            value = value.trim();

                                            if (value.trim() != "") {
                                              if (!context
                                                  .read<SatisCubit>()
                                                  .isNumeric(value.trim())) {
                                                return "rakam ve . , kullanabilirsiniz";
                                              }
                                            }

                                            if (!(value == null)) {
                                              if (value == "") {
                                                value = "0";
                                              }

                                              if (double.parse(value) >= 0) {
                                                if (context
                                                    .read<SatisCubit>()
                                                    .fiyatTumunuSec) {
                                                  context
                                                      .read<SatisCubit>()
                                                      .selectedKunyeler
                                                      .forEach((element) {
                                                    element.gonderilmekIstenenFiyat =
                                                        value;
                                                  });
                                                }
                                                e.gonderilmekIstenenFiyat =
                                                    value;
                                              }
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            contentPadding: context.padding.low,
                                            constraints: BoxConstraints(
                                                maxHeight:
                                                    context.sized.normalValue *
                                                        3),
                                            hintText:
                                                "${e.malinSatisFiyati ?? "boş"}  ",
                                            border: const OutlineInputBorder(),
                                          ),
                                        ),
                                      )),
                                DataCell(
                                    const Center(
                                        child: Icon(
                                      Icons.delete_rounded,
                                      color: Colors.green,
                                    )), onTap: () {
                                  context
                                      .read<SatisCubit>()
                                      .removeFromSelectedKunyeList(e);
                                })
                              ]);
                            },
                          ).toList()),
                        ]),
                  ),
                  buildAracPlakaField(context),
                  buildFaturaColumn(context),
                  buildDriverMain(context),
                  buildBildirimYapButton(context),
                ],
              );
      },
    );
  }

  Padding buildDriverMain(BuildContext context) {
    return Padding(
      padding: context.padding.low,
      child: !context.read<SatisCubit>().isIrsaliye
          ? const SizedBox()
          : Column(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        !context.read<SatisCubit>().isSurucuManual
                            ? buildDriverDropDown(context)
                            : const SizedBox(),
                        buildeEnterDriverInfos(context),
                      ],
                    )
                  ],
                ),
                buildDriverForm(context),
              ],
            ),
    );
  }

  Widget buildDriverDropDown(BuildContext context) {
    return BlocBuilder<SatisCubit, SatisState>(
      builder: (context, state) {
        return DropDown2DriverSearch(
          controller: context.read<SatisCubit>().driverAdiControllerForDropDown,
          onChanged: (value) {
            context.read<SatisCubit>().selectedDriver = value;
            context.read<SatisCubit>().emitInitialState();
          },
          selectedValue: context.read<SatisCubit>().selectedDriver,
          onMenuStateChange: () {
            context.read<SatisCubit>().driverAdiControllerForDropDown.clear();
          },
        );
      },
    );
  }

  Widget buildDriverForm(BuildContext context) {
    return !context.read<SatisCubit>().isSurucuManual
        ? const SizedBox()
        : Form(
            key: context.read<SatisCubit>().driverFormKey,
            child: Column(
              children: [
                Padding(
                  padding: context.padding.normal,
                  child: TextFormField(
                    controller: context.read<SatisCubit>().driverIdController,
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'lütfen Tc giriniz';
                      }
                      if (!context.read<SatisCubit>().isNumeric(value)) {
                        return "Tc sadece numara içerebilir";
                      }
                      if (value.length <= 9) {
                        return "Tc 9 karaterden küçük olamaz";
                      }
                      return null;
                    }),
                    keyboardType: Platform.isAndroid
                        ? TextInputType.number
                        : TextInputType.datetime,
                    autovalidateMode:
                        context.read<SatisCubit>().isAutoValidateModeForDriver,
                    decoration: InputDecoration(
                        constraints: BoxConstraints(
                            maxHeight: context.sized.normalValue * 3),
                        labelText: "Sürücü Tc",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                ),
                Padding(
                  padding: context.padding.normal,
                  child: TextFormField(
                    controller: context.read<SatisCubit>().driverNameController,
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'lütfen Ad Soyad giriniz';
                      }

                      if (value.length <= 9) {
                        return "En Az 5 karakter giriniz";
                      }
                      return null;
                    }),
                    autovalidateMode:
                        context.read<SatisCubit>().isAutoValidateModeForDriver,
                    decoration: InputDecoration(
                        constraints: BoxConstraints(
                            maxHeight: context.sized.normalValue * 3),
                        labelText: "Sürücü Adı Soyadı",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                ),
              ],
            ),
          );
  }

  Expanded buildeEnterDriverInfos(BuildContext context) {
    return Expanded(
      child: CheckboxListTile(
        activeColor: Colors.green,
        value: context.read<SatisCubit>().isSurucuManual,
        onChanged: (value) {
          context.read<SatisCubit>().isSurucuManual = value!;
          context.read<SatisCubit>().emitInitialState();
        },
        title: Text(
          "Sürücü Bilgilerini Manuel Gir",
          style: context.general.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildFaturaColumn(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable:
            Hive.box<MySoftUserModel>(MySoftUserCacheManager.instance.key)
                .listenable(),
        builder:
            (BuildContext context, Box<MySoftUserModel> box, Widget? child) {
          MySoftUserModel? user = box.get(ActiveTc.instance.activeTc);
          //  context.read<AddMySoftUserCubit>().currentMySoftUser = user;
          if (user != null) {
            return BlocBuilder<SatisCubit, SatisState>(
              builder: (context, state) {
                return Row(
                  children: [
                    Expanded(child: builSatisFaturaCheckBox(context)),
                    Expanded(child: buildIrasaliyeCheckBox(context))
                  ],
                );
              },
            );
          } else {
            return const SizedBox();
          }
        });
  }

  Widget builSatisFaturaCheckBox(BuildContext context) {
    return CheckboxListTile(
      activeColor: Colors.green,
      value: context.read<SatisCubit>().isSatisFatura,
      onChanged: (value) {
        context.read<SatisCubit>().isSatisFatura = value!;
        context.read<SatisCubit>().emitInitialState();
      },
      title: const Text(
        "Satış Faturası Kes",
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildIrasaliyeCheckBox(BuildContext context) {
    return CheckboxListTile(
      activeColor: Colors.green,
      value: context.read<SatisCubit>().isIrsaliye,
      onChanged: (value) {
        context.read<SatisCubit>().isIrsaliye = value!;
        context.read<SatisCubit>().emitInitialState();
      },
      title: const Text(
        "İrsaliye Kes",
        textAlign: TextAlign.center,
      ),
    );
  }

  Padding buildBildirimYapButton(BuildContext context) {
    return Padding(
      padding: context.padding.verticalNormal,
      child: FloatingActionButton.extended(
          heroTag: "sevk bildirim",
          backgroundColor: Colors.green,
          onPressed: () async {
            context.read<SatisCubit>().activateAutoValidateModeForPlaka();
            if (context.read<SatisCubit>().isIrsaliye) {
              if (context.read<SatisCubit>().isSurucuManual) {
                context.read<SatisCubit>().activateAutoValidateModeForDriver();

                if (context
                    .read<SatisCubit>()
                    .driverFormKey
                    .currentState!
                    .validate()) {
                  context.read<SatisCubit>().selectedDriver = DriverModel(
                      tc: context
                          .read<SatisCubit>()
                          .driverIdController
                          .text
                          .trim(),
                      userName: context
                          .read<SatisCubit>()
                          .driverNameController
                          .text
                          .trim()
                          .toUpperCaseTr());
                  if (context
                      .read<SatisCubit>()
                      .plakaFormKey
                      .currentState!
                      .validate()) {
                    context
                        .read<SatisCubit>()
                        .disableAutoValidateModeForPlaka();
                    await context.read<SatisCubit>().bildirimYap(context);
                  }
                }
              } else {
                if (context.read<SatisCubit>().selectedDriver == null) {
                  context.read<SatisCubit>().emitError(
                      "Sürücü Seçiniz ve ya manuel olarak ekleyiniz");
                } else {
                  if (context
                      .read<SatisCubit>()
                      .plakaFormKey
                      .currentState!
                      .validate()) {
                    context
                        .read<SatisCubit>()
                        .disableAutoValidateModeForPlaka();
                    await context.read<SatisCubit>().bildirimYap(context);
                  }
                }
                //check selected driver
              }
            } else {
              if (context
                  .read<SatisCubit>()
                  .plakaFormKey
                  .currentState!
                  .validate()) {
                context.read<SatisCubit>().disableAutoValidateModeForPlaka();
                await context.read<SatisCubit>().bildirimYap(context);
              }
            }
          },
          label: const Text("Bildirim Yap")),
    );
  }

  Padding buildAracPlakaField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<SatisCubit, SatisState>(
        builder: (context, state) {
          return Form(
            key: context.read<SatisCubit>().plakaFormKey,
            child: TextFormField(
              autovalidateMode:
                  context.read<SatisCubit>().isAutoValidateModeForPlaka,
              validator: ((value) {
                if (value == null || value.isEmpty) {
                  return 'lütfen plaka bilgisi giriniz';
                }
                return null;
              }),
              controller: context.read<SatisCubit>().plakaController,
              decoration: InputDecoration(
                  constraints:
                      BoxConstraints(maxHeight: context.sized.normalValue * 3),
                  labelText: "Araç Plaka",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  )),
            ),
          );
        },
      ),
    );
  }

  Row buildDateField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildStartDate(),
        const Text("   "),
        buildBitisDate(context),
      ],
    );
  }

  Row buildBitisDate(BuildContext context) {
    return Row(
      children: [
        Text("Bitiş: ",
            style: context.general.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        BlocBuilder<SatisCubit, SatisState>(
          builder: (context, state) {
            return CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => _showDialog(
                  CupertinoDatePicker(
                    initialDateTime: context.read<SatisCubit>().endDay,
                    dateOrder: DatePickerDateOrder.dmy,
                    maximumDate: context.read<SatisCubit>().maxDate,
                    mode: CupertinoDatePickerMode.date,
                    use24hFormat: true,
                    onDateTimeChanged: (DateTime newDate) {
                      context.read<SatisCubit>().endDay = newDate;
                      context.read<SatisCubit>().emitInitialState();
                    },
                  ),
                  context),
              child: Text(
                '${context.read<SatisCubit>().endDay.day}-${context.read<SatisCubit>().endDay.month}-${context.read<SatisCubit>().endDay.year}',
                style: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  BlocBuilder<SatisCubit, SatisState> buildStartDate() {
    return BlocBuilder<SatisCubit, SatisState>(
      builder: (context, state) {
        return Row(
          children: [
            Text("Başlangıç: ",
                style: context.general.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => _showDialog(
                  CupertinoDatePicker(
                    dateOrder: DatePickerDateOrder.dmy,
                    initialDateTime: context.read<SatisCubit>().startDay,
                    maximumDate: context.read<SatisCubit>().maxDate,
                    mode: CupertinoDatePickerMode.date,
                    use24hFormat: true,
                    onDateTimeChanged: (DateTime newDate) {
                      context.read<SatisCubit>().startDay = newDate;
                      context.read<SatisCubit>().emitInitialState();
                    },
                  ),
                  context),
              child: Text(
                '${context.read<SatisCubit>().startDay.day}-${context.read<SatisCubit>().startDay.month}-${context.read<SatisCubit>().startDay.year}',
                style: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void _showDialog(Widget child, BuildContext context) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  Widget buildCustomerNameField(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable:
          Hive.box<List<dynamic>>(MusteriListCacheManager.instance.key)
              .listenable(),
      builder: (BuildContext context, Box<List<dynamic>>? box, Widget? child) {
        List<Musteri>? musteriList = [];

        for (var element in (box
                ?.get(ActiveTc.instance.activeTc)
                ?.map((e) => Musteri.fromJson(Map<String, dynamic>.from(e)))
                .toList() ??
            [])) {
          for (var item in element.musteriSifatIdList) {
            if (context
                .read<SatisCubit>()
                .satisYapilabilecekSifatlar
                .keys
                .contains(item)) {
              musteriList.add(element);

              break;
            }
          }
        }

        if (musteriList.isEmpty) {
          return ElevatedButton(
              onPressed: () {
                context.read<HomeCubit>().currentIndex = 2;
                context.read<HomeCubit>().pageController.jumpToPage(2);
              },
              child: const Text("Müşteri Ekle"));
        }
        return DropDown2CustomerSearch(
          items: musteriList,
          controller: context.read<SatisCubit>().musteriAdiController,
          selectedValue: context.read<SatisCubit>().selectedMusteri,
          onChanged: (value) {
            context.read<SatisCubit>().clearMusteriSifatInfos();
            context.read<SatisCubit>().selectedMusteri = value;
            context.read<SatisCubit>().musteriSelected();
          },
          onMenuStateChange: () {
            context.read<SatisCubit>().musteriAdiController.clear();
          },
        );
      },
    );
  }

  Widget buildKunyeSorgulama(BuildContext context) {
    return Padding(
      padding: context.padding.verticalNormal,
      child: FloatingActionButton.extended(
          heroTag: "Künye Sorgula",
          backgroundColor: Colors.green,
          onPressed: () async {
            context
                .read<SatisCubit>()
                .fetchKunyeTransActionsWithNewDate(
                    context.read<SatisCubit>().startDay,
                    context.read<SatisCubit>().endDay)
                .then((value) {
              context.read<SatisCubit>().emitInitialState();
              DropDownState(
                DropDown(
                  submitButtonText: "Seçimi tamala",
                  submitButtonColor: const Color.fromRGBO(70, 76, 222, 1),
                  searchHintText: "Ürün arat",
                  bottomSheetTitle: "Referans Künyeler",
                  searchBackgroundColor: Colors.black12,
                  dataList: context
                      .read<SatisCubit>()
                      .allReferansKunyeler
                      .map((e) => SelectedListItem(
                          context.read<SatisCubit>().kunyeSelectedOrNot(e),
                          referansKunye: e))
                      .toList(),
                  selectedItems: (List<ReferansKunye> selectedList) {
                    context.read<SatisCubit>().selectedKunyeler = selectedList;
                    context.read<SatisCubit>().kunyelerSelected();

                    context
                        .read<SatisCubit>()
                        .searchKunyeTextEditingController
                        .clear();
                  },
                  enableMultipleSelection: true,
                  searchController: context
                      .read<SatisCubit>()
                      .searchKunyeTextEditingController,
                ),
              ).showModal(context);
            });
          },
          label: const Text("Künye Sorgula")),
    );
  }
}
