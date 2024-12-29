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
import 'package:hal_app/feature/home/sub/bildirim_page/sub/sevk_etme_for_komisyoncu_page/viewmodel/cubit/sevk_etme_for_komisyoncu_cubit.dart';
import 'package:hal_app/feature/home/viewmodel/cubit/home_cubit.dart';
import 'package:hal_app/project/utils/component/dropdown2_driver_search.dart';
import 'package:hal_app/project/utils/component/dropdown2_musteri_search.dart';
import 'package:hal_app/project/utils/widgets/custom_dropdown2.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kartal/kartal.dart';
import 'package:turkish/turkish.dart';

import '../../../../../../../project/cache/driver_list_cache_manager.dart';
import '../../../../../../../project/cache/musteri_depo_cache_manager.dart';
import '../../../../../../../project/cache/musteri_hal_ici_isyeri_cache_manager.dart';
import '../../../../../../../project/cache/musteri_list_cache_manager.dart';
import '../../../../../../../project/cache/musteri_sube_cache_manager.dart';
import '../../../../../../../project/cache/mysoft_user_cache_mananger.dart';
import '../../../../../../../project/model/MySoft_user_model/mysoft_user_model.dart';
import '../../../../../../../project/model/bildirim_kayit_response_model.dart/sub/bildirim_kayit_cevap_model.dart';
import '../../../../../../../project/model/depo/depo_model.dart';
import '../../../../../../../project/model/driver_model/driver_model.dart';
import '../../../../../../../project/model/hal_ici_isyeri/hal_ici_isyeri_model.dart';
import '../../../../../../../project/model/malin_gidecegi_yer/malin_gidecegi_yer_model.dart';
import '../../../../../../../project/model/musteri_model/musteri_model.dart';
import '../../../../../../../project/model/referans_kunye/referans_kunye_model.dart';
import '../../../../../../../project/model/sube/sube_model.dart';
import '../../../../../../../project/utils/widgets/dropdown_selection.dart';
import '../../../../../../helper/active_tc.dart';
import '../../../../../../helper/scaffold_messager.dart';

class SevkEtmeForKomisyoncuPage extends StatelessWidget {
  const SevkEtmeForKomisyoncuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: BlocListener<SevkEtmeForKomisyoncuCubit,
              SevkEtmeForKomisyoncuState>(
        listener: blocListener,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: context.padding.horizontalNormal,
                  child: buildUreticiAdiField(context),
                ),
                buildSelectedCustomerAdjectiveDropDown(context),
              ],
            ),
            buildMalinGidecegiYerDropDown(context),
            buildDateField(context),
            sorgulamaAraligiError(),
            buildSadeceSecilenleriSorgulaCheckBox(),
            buildKunyeSorgulama(context),
            buildTable2(context),
          ],
        ),
      )),
    );
  }

  BlocBuilder<SevkEtmeForKomisyoncuCubit, SevkEtmeForKomisyoncuState>
      sorgulamaAraligiError() {
    return BlocBuilder<SevkEtmeForKomisyoncuCubit, SevkEtmeForKomisyoncuState>(
      builder: (context, state) {
        int difference = context
            .read<SevkEtmeForKomisyoncuCubit>()
            .endDay
            .difference(context.read<SevkEtmeForKomisyoncuCubit>().startDay)
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

  void blocListener(BuildContext context, SevkEtmeForKomisyoncuState state) {
    if (state is SevkEtmeForKomisyoncuLoading) {
      EasyLoading.instance
        ..indicatorType = EasyLoadingIndicatorType.pouringHourGlass
        ..loadingStyle = EasyLoadingStyle.light
        ..userInteractions = false;
      EasyLoading.show(status: 'HKS Bekleniyor...');
    } else {
      EasyLoading.dismiss();
    }
    if (state is SevkEtmeForKomisyoncuError) {
      ScaffoldMessengerHelper.instance
          .showErrorSnackBar(context, state.message);
    }
    if (state is SevkEtmeForKomisyoncuSuccessHasSomeError) {
      if (state.response.kayitCevapList == null) {}
      List<Widget> basarili =
          buildSuccessfulTexts(state.response.kayitCevapList!, context);

      AwesomeDialog(
          btnCancelText: "Kapat",
          btnOkText: "Whatsapp ile paylaş",
          btnCancelOnPress: () {
            context.read<SevkEtmeForKomisyoncuCubit>().clearFaturaInfo();

            //    Navigator.pop(context); //Named e dönüp düzeteceğim
          },
          btnOkOnPress: () async {
            //  Navigator.pop(context);
            context.read<SevkEtmeForKomisyoncuCubit>().clearFaturaInfo();

            await context
                .read<SevkEtmeForKomisyoncuCubit>()
                .shareWithWhatsapp(state.response);
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
                          context
                                  .read<SevkEtmeForKomisyoncuCubit>()
                                  .isIrsaliyeKesSuccess
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const SizedBox(),
                        ],
                      ),
                      const Text(
                        "E-Fatura  ",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.bold),
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
    if (state is SevkEtmeForKomisyoncuCompletelySuccess) {
      AwesomeDialog(
          btnCancelText: "Kapat",
          btnOkText: "Whatsapp ile paylaş",
          btnCancelOnPress: () {
            context.read<SevkEtmeForKomisyoncuCubit>().clearFaturaInfo();

            //    Navigator.pop(context); //Named e dönüp düzeteceğim
          },
          btnOkOnPress: () async {
            context.read<SevkEtmeForKomisyoncuCubit>().clearFaturaInfo();

            //  Navigator.pop(context);
            await context
                .read<SevkEtmeForKomisyoncuCubit>()
                .shareWithWhatsapp(state.response);
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
                          context
                                  .read<SevkEtmeForKomisyoncuCubit>()
                                  .isIrsaliyeKesSuccess
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : const SizedBox(),
                        ],
                      ),
                      const Text(
                        "E-Fatura  ",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.bold),
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
        context
            .read<SevkEtmeForKomisyoncuCubit>()
            .getMallar
            .forEach((key, value) {
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
                  trailing: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
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

  Widget buildSelectedCustomerAdjectiveDropDown(BuildContext context) {
    return BlocBuilder<SevkEtmeForKomisyoncuCubit, SevkEtmeForKomisyoncuState>(
      builder: (context, state) {
        if (context.read<SevkEtmeForKomisyoncuCubit>().selectedMusteri !=
                null &&
            context
                .read<SevkEtmeForKomisyoncuCubit>()
                .selectedMusteri!
                .isregisteredToHks) {
          if (context
                  .read<SevkEtmeForKomisyoncuCubit>()
                  .musterideOlanSatisYapilabilecekSifatlar
                  .length >
              1) {
            return Padding(
              padding: context.padding.verticalLow,
              child: CustomDropdownButton2(
                hint: 'Gidecek Kişi Sıfatı',
                dropdownItems: context
                    .read<SevkEtmeForKomisyoncuCubit>()
                    .musterideOlanSatisYapilabilecekSifatlar
                    .values
                    .toList(),
                buttonWidth: context.general.mediaSize.width * .4,
                icon: const Icon(Icons.arrow_drop_down_sharp, size: 24),
                value: context
                    .watch<SevkEtmeForKomisyoncuCubit>()
                    .selectedSatisYapilacakSifatName,
                onChanged: (value) {
                  context
                      .read<SevkEtmeForKomisyoncuCubit>()
                      .selectedSatisYapilacakSifatName = value!;

                  context
                      .read<SevkEtmeForKomisyoncuCubit>()
                      .satisYapilacakSifatSelected();
                },
              ),
            );
          } else {
            return const SizedBox();
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget buildMalinGidecegiYerDropDown(BuildContext context) {
    return BlocBuilder<SevkEtmeForKomisyoncuCubit, SevkEtmeForKomisyoncuState>(
      builder: (context, state) {
        if (context.read<SevkEtmeForKomisyoncuCubit>().selectedMusteri ==
            null) {
          return const SizedBox();
        }

        List<GidecegiYer> gidecegiYerList = [];
        List<Sube> subeler = MusteriSubelerCacheManager.instance.getItem(context
            .read<SevkEtmeForKomisyoncuCubit>()
            .selectedMusteri!
            .musteriTc);
        List<Depo> depolar = MusteriDepolarCacheManager.instance.getItem(context
            .read<SevkEtmeForKomisyoncuCubit>()
            .selectedMusteri!
            .musteriTc);
        List<HalIciIsyeri> halIciIsyerleri =
            MusteriHalIciIsyeriCacheManager.instance.getItem(context
                .read<SevkEtmeForKomisyoncuCubit>()
                .selectedMusteri!
                .musteriTc);
        if ((subeler.length + depolar.length + halIciIsyerleri.length) == 0) {
          return const Text(
            "Gidilecek yer bulunumadı lütfen ayarlardan kullanıcı bilgilerini güncelleyiniz",
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          );
        } else if ((subeler.length + depolar.length + halIciIsyerleri.length) ==
            1) {
          late GidecegiYer gidecegiYer;
          for (var element in subeler) {
            gidecegiYer = GidecegiYer(
                type: "Şube",
                name: element.adres.toString(),
                isletmeTuru: element.isletmeTuruAdi ?? "null",
                isletmeTuruId: element.isletmeTuruId ?? "null",
                isyeriId: element.subeId ?? "null",
                adres: element.adres.toString());
          }
          for (var element in depolar) {
            gidecegiYer = GidecegiYer(
                type: "Depo",
                name: element.adres.toString(),
                isletmeTuru: element.isletmeTuruAdi ?? "null",
                isletmeTuruId: element.isletmeTuruId ?? "null",
                isyeriId: element.depoId ?? "null",
                adres: element.adres.toString());
          }
          for (var element in halIciIsyerleri) {
            gidecegiYer = GidecegiYer(
                type: "Hal içi işyeri",
                name: element.isyeriAdi.toString(),
                isletmeTuru: element.isletmeTuruAdi,
                isletmeTuruId: element.isletmeTuruId,
                isyeriId: element.isyeriId ?? "null",
                adres: element.halAdi.toString());
          }

          context
              .read<SevkEtmeForKomisyoncuCubit>()
              .gidecegiYerSelectedSingle(gidecegiYer);

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

        return Padding(
          padding: context.padding.verticalLow,
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<GidecegiYer>(
              isExpanded: true,
              dropdownSearchData: DropdownSearchData(
                searchController: context
                    .read<SevkEtmeForKomisyoncuCubit>()
                    .gidecegiYerController,
                searchInnerWidget: Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 4,
                    right: 8,
                    left: 8,
                  ),
                  child: TextFormField(
                    controller: context
                        .read<SevkEtmeForKomisyoncuCubit>()
                        .gidecegiYerController,
                    autofocus: true,
                    decoration: InputDecoration(
                      // isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      hintText: 'Adress Ara',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                searchInnerWidgetHeight: 50,
                searchMatchFn: (item, searchValue) {
                  return ((item.value as GidecegiYer)
                      .name
                      .toString()
                      .toLowerCaseTr()
                      .contains(searchValue.toLowerCaseTr()));
                },
              ),
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
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
              value: context.read<SevkEtmeForKomisyoncuCubit>().gidecegiYer,
              onChanged: (value) {
                context.read<SevkEtmeForKomisyoncuCubit>().gidecegiYer =
                    (value as GidecegiYer);
                context
                    .read<SevkEtmeForKomisyoncuCubit>()
                    .gidecegiYerSelected();
              },
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  context
                      .read<SevkEtmeForKomisyoncuCubit>()
                      .gidecegiYerController
                      .clear();
                }
              },
            ),
          ),
        );
      },
    );
  }

  BlocBuilder<SevkEtmeForKomisyoncuCubit, SevkEtmeForKomisyoncuState>
      buildSadeceSecilenleriSorgulaCheckBox() {
    return BlocBuilder<SevkEtmeForKomisyoncuCubit, SevkEtmeForKomisyoncuState>(
      builder: (context, state) {
        return (context.read<SevkEtmeForKomisyoncuCubit>().selectedMusteri !=
                    null &&
                context.read<SevkEtmeForKomisyoncuCubit>().gidecegiYer != null)
            ? CheckboxListTile(
                title: const Text(
                    "Sadece Seçilen Üreticiye Ait Kalan Künyeleri Sorgula",
                    textAlign: TextAlign.center),
                value: context
                    .read<SevkEtmeForKomisyoncuCubit>()
                    .sadeceSelectedUreticiyeAitKunyeleriSorgula,
                onChanged: (value) {
                  context
                      .read<SevkEtmeForKomisyoncuCubit>()
                      .sadeceSelectedUreticiyeAitKunyeleriSorgula = value!;
                  context.read<SevkEtmeForKomisyoncuCubit>().emitInitialState();
                })
            : const SizedBox();
      },
    );
  }

  BlocBuilder<SevkEtmeForKomisyoncuCubit, SevkEtmeForKomisyoncuState>
      buildTable2(BuildContext context) {
    return BlocBuilder<SevkEtmeForKomisyoncuCubit, SevkEtmeForKomisyoncuState>(
      builder: (context, state) {
        return context
                .watch<SevkEtmeForKomisyoncuCubit>()
                .selectedKunyeler
                .ext
                .isNullOrEmpty
            ? Container()
            : Column(
                children: [
                  Text(
                      "Toplam Künye Sayısı ${context.watch<SevkEtmeForKomisyoncuCubit>().selectedKunyeler.length}"),
                  SizedBox(
                    height: 50 +
                        (context
                                .read<SevkEtmeForKomisyoncuCubit>()
                                .selectedKunyeler
                                .length *
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
                            // size: ColumnSize.L,
                          ),
                          //   DataColumn(
                          //     label: Text('Cins'),
                          //   ),
                          DataColumn(
                            label: Text('Miktar'),
                          ),

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
                          ...(context
                              .read<SevkEtmeForKomisyoncuCubit>()
                              .selectedKunyeler
                              .map(
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
                                            .read<SevkEtmeForKomisyoncuCubit>()
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
                                DataCell(
                                    const Center(
                                        child: Icon(
                                      Icons.delete_rounded,
                                      color: Colors.green,
                                    )), onTap: () {
                                  context
                                      .read<SevkEtmeForKomisyoncuCubit>()
                                      .removeFromSelectedKunyeList(e);
                                })
                              ]);
                            },
                          ).toList()),
                        ]),
                  ),
                  buildAracPlakaField(context),
                  buildFaturaColumn(context), buildDriverMain(context),

                  buildBildirimYapButton(context),
                  // Expanded(child: SizedBox())
                ],
              );
      },
    );
  }

  Padding buildDriverMain(BuildContext context) {
    return Padding(
      padding: context.padding.low,
      child: !context.read<SevkEtmeForKomisyoncuCubit>().isIrsaliye
          ? const SizedBox()
          : Column(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        !context
                                .read<SevkEtmeForKomisyoncuCubit>()
                                .isSurucuManual
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
    return BlocBuilder<SevkEtmeForKomisyoncuCubit, SevkEtmeForKomisyoncuState>(
      builder: (context, state) {
        return DropDown2DriverSearch(
          controller: context
              .read<SevkEtmeForKomisyoncuCubit>()
              .driverAdiControllerForDropDown,
          onChanged: (value) {
            context.read<SevkEtmeForKomisyoncuCubit>().selectedDriver = value;
            context.read<SevkEtmeForKomisyoncuCubit>().emitInitialState();
          },
          selectedValue:
              context.read<SevkEtmeForKomisyoncuCubit>().selectedDriver,
          onMenuStateChange: () {
            context
                .read<SevkEtmeForKomisyoncuCubit>()
                .driverAdiControllerForDropDown
                .clear();
          },
        );
      },
    );
  }

  Widget buildDriverForm(BuildContext context) {
    return !context.read<SevkEtmeForKomisyoncuCubit>().isSurucuManual
        ? const SizedBox()
        : Form(
            key: context.read<SevkEtmeForKomisyoncuCubit>().driverFormKey,
            child: Column(
              children: [
                Padding(
                  padding: context.padding.normal,
                  child: TextFormField(
                    controller: context
                        .read<SevkEtmeForKomisyoncuCubit>()
                        .driverIdController,
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'lütfen Tc giriniz';
                      }
                      if (!context
                          .read<SevkEtmeForKomisyoncuCubit>()
                          .isNumeric(value)) {
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
                    autovalidateMode: context
                        .read<SevkEtmeForKomisyoncuCubit>()
                        .isAutoValidateModeForDriver,
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
                    controller: context
                        .read<SevkEtmeForKomisyoncuCubit>()
                        .driverNameController,
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'lütfen Ad Soyad giriniz';
                      }

                      if (value.length <= 9) {
                        return "En Az 5 karakter giriniz";
                      }
                      return null;
                    }),
                    autovalidateMode: context
                        .read<SevkEtmeForKomisyoncuCubit>()
                        .isAutoValidateModeForDriver,
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
        value: context.read<SevkEtmeForKomisyoncuCubit>().isSurucuManual,
        onChanged: (value) {
          context.read<SevkEtmeForKomisyoncuCubit>().isSurucuManual = value!;
          context.read<SevkEtmeForKomisyoncuCubit>().emitInitialState();
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
            return BlocBuilder<SevkEtmeForKomisyoncuCubit,
                SevkEtmeForKomisyoncuState>(
              builder: (context, state) {
                return SizedBox(
                    width: context.general.mediaSize.width * .5,
                    child: buildIrasaliyeCheckBox(context));
              },
            );
          } else {
            return const SizedBox();
          }
        });
  }

  Widget buildIrasaliyeCheckBox(BuildContext context) {
    return CheckboxListTile(
      activeColor: Colors.green,
      value: context.read<SevkEtmeForKomisyoncuCubit>().isIrsaliye,
      onChanged: (value) {
        context.read<SevkEtmeForKomisyoncuCubit>().isIrsaliye = value!;
        context.read<SevkEtmeForKomisyoncuCubit>().emitInitialState();
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
            context
                .read<SevkEtmeForKomisyoncuCubit>()
                .activateAutoValidateModeForPlaka();
            if (context.read<SevkEtmeForKomisyoncuCubit>().isIrsaliye) {
              if (context.read<SevkEtmeForKomisyoncuCubit>().isSurucuManual) {
                context
                    .read<SevkEtmeForKomisyoncuCubit>()
                    .activateAutoValidateModeForDriver();

                if (context
                    .read<SevkEtmeForKomisyoncuCubit>()
                    .driverFormKey
                    .currentState!
                    .validate()) {
                  context.read<SevkEtmeForKomisyoncuCubit>().selectedDriver =
                      DriverModel(
                          tc: context
                              .read<SevkEtmeForKomisyoncuCubit>()
                              .driverIdController
                              .text
                              .trim(),
                          userName: context
                              .read<SevkEtmeForKomisyoncuCubit>()
                              .driverNameController
                              .text
                              .trim()
                              .toUpperCaseTr());
                  if (context
                      .read<SevkEtmeForKomisyoncuCubit>()
                      .plakaFormKey
                      .currentState!
                      .validate()) {
                    context
                        .read<SevkEtmeForKomisyoncuCubit>()
                        .disableAutoValidateModeForPlaka();
                    await context
                        .read<SevkEtmeForKomisyoncuCubit>()
                        .bildirimYap(context);
                  }
                }
              } else {
                if (context.read<SevkEtmeForKomisyoncuCubit>().selectedDriver ==
                    null) {
                  context.read<SevkEtmeForKomisyoncuCubit>().emitError(
                      "Sürücü Seçiniz ve ya manuel olarak ekleyiniz");
                } else {
                  if (context
                      .read<SevkEtmeForKomisyoncuCubit>()
                      .plakaFormKey
                      .currentState!
                      .validate()) {
                    context
                        .read<SevkEtmeForKomisyoncuCubit>()
                        .disableAutoValidateModeForPlaka();
                    await context
                        .read<SevkEtmeForKomisyoncuCubit>()
                        .bildirimYap(context);
                  }
                }
                //check selected driver
              }
            } else {
              if (context
                  .read<SevkEtmeForKomisyoncuCubit>()
                  .plakaFormKey
                  .currentState!
                  .validate()) {
                context
                    .read<SevkEtmeForKomisyoncuCubit>()
                    .disableAutoValidateModeForPlaka();
                await context
                    .read<SevkEtmeForKomisyoncuCubit>()
                    .bildirimYap(context);
              }
            }
          },
          label: const Text("Bildirim Yap")),
    );
  }

  Padding buildAracPlakaField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:
          BlocBuilder<SevkEtmeForKomisyoncuCubit, SevkEtmeForKomisyoncuState>(
        builder: (context, state) {
          return Form(
            key: context.read<SevkEtmeForKomisyoncuCubit>().plakaFormKey,
            child: TextFormField(
              autovalidateMode: context
                  .read<SevkEtmeForKomisyoncuCubit>()
                  .isAutoValidateModeForPlaka,
              validator: ((value) {
                if (value == null || value.isEmpty) {
                  return 'lütfen plaka bilgisi giriniz';
                }
                return null;
              }),
              controller:
                  context.read<SevkEtmeForKomisyoncuCubit>().plakaController,
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

  Widget buildDateField(BuildContext context) {
    return BlocBuilder<SevkEtmeForKomisyoncuCubit, SevkEtmeForKomisyoncuState>(
      builder: (context, state) {
        return (context.read<SevkEtmeForKomisyoncuCubit>().selectedMusteri !=
                    null &&
                context.read<SevkEtmeForKomisyoncuCubit>().gidecegiYer != null)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildStartDate(),
                  const Text("   "),
                  buildBitisDate(context),
                ],
              )
            : const SizedBox();
      },
    );
  }

  Row buildBitisDate(BuildContext context) {
    return Row(
      children: [
        Text("Bitiş: ",
            style: context.general.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        BlocBuilder<SevkEtmeForKomisyoncuCubit, SevkEtmeForKomisyoncuState>(
          builder: (context, state) {
            return CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => _showDialog(
                  CupertinoDatePicker(
                    dateOrder: DatePickerDateOrder.dmy,
                    initialDateTime:
                        context.read<SevkEtmeForKomisyoncuCubit>().endDay,
                    maximumDate:
                        context.read<SevkEtmeForKomisyoncuCubit>().maxDate,
                    mode: CupertinoDatePickerMode.date,
                    use24hFormat: true,
                    onDateTimeChanged: (DateTime newDate) {
                      context.read<SevkEtmeForKomisyoncuCubit>().endDay =
                          newDate;
                      context
                          .read<SevkEtmeForKomisyoncuCubit>()
                          .emitInitialState();
                    },
                  ),
                  context),
              child: Text(
                '${context.read<SevkEtmeForKomisyoncuCubit>().endDay.day}-${context.read<SevkEtmeForKomisyoncuCubit>().endDay.month}-${context.read<SevkEtmeForKomisyoncuCubit>().endDay.year}',
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

  BlocBuilder<SevkEtmeForKomisyoncuCubit, SevkEtmeForKomisyoncuState>
      buildStartDate() {
    return BlocBuilder<SevkEtmeForKomisyoncuCubit, SevkEtmeForKomisyoncuState>(
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
                    initialDateTime:
                        context.read<SevkEtmeForKomisyoncuCubit>().startDay,
                    maximumDate:
                        context.read<SevkEtmeForKomisyoncuCubit>().maxDate,
                    mode: CupertinoDatePickerMode.date,
                    use24hFormat: true,
                    onDateTimeChanged: (DateTime newDate) {
                      context.read<SevkEtmeForKomisyoncuCubit>().startDay =
                          newDate;
                      context
                          .read<SevkEtmeForKomisyoncuCubit>()
                          .emitInitialState();
                    },
                  ),
                  context),
              child: Text(
                '${context.read<SevkEtmeForKomisyoncuCubit>().startDay.day}-${context.read<SevkEtmeForKomisyoncuCubit>().startDay.month}-${context.read<SevkEtmeForKomisyoncuCubit>().startDay.year}',
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

  Widget buildUreticiAdiField(BuildContext context) {
    return BlocBuilder<SevkEtmeForKomisyoncuCubit, SevkEtmeForKomisyoncuState>(
      builder: (context, state) {
        return Center(
          child: ValueListenableBuilder(
            valueListenable:
                Hive.box<List<dynamic>>(MusteriListCacheManager.instance.key)
                    .listenable(),
            builder:
                (BuildContext context, Box<List<dynamic>>? box, Widget? child) {
              List<Musteri>? musteriList = [];

              for (var element in (box
                      ?.get(ActiveTc.instance.activeTc)
                      ?.map(
                          (e) => Musteri.fromJson(Map<String, dynamic>.from(e)))
                      .toList() ??
                  [])) {
                if (element.isregisteredToHks) {
                  //  element.musteriSifatIdList.

                  for (var item in element.musteriSifatIdList) {
                    if (context
                        .read<SevkEtmeForKomisyoncuCubit>()
                        .komisyoncununSevkYapabilecegiSifatlar
                        .keys
                        .contains(item)) {
                      musteriList.add(element);

                      break;
                    }
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
                controller: context
                    .read<SevkEtmeForKomisyoncuCubit>()
                    .musteriAdiController,
                selectedValue:
                    context.read<SevkEtmeForKomisyoncuCubit>().selectedMusteri,
                onChanged: (value) {
                  context.read<SevkEtmeForKomisyoncuCubit>().selectedMusteri =
                      value;
                  context.read<SevkEtmeForKomisyoncuCubit>().musteriSelected();
                },
                onMenuStateChange: () {
                  context
                      .read<SevkEtmeForKomisyoncuCubit>()
                      .musteriAdiController
                      .clear();
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget buildKunyeSorgulama(BuildContext context) {
    return BlocBuilder<SevkEtmeForKomisyoncuCubit, SevkEtmeForKomisyoncuState>(
      builder: (context, state) {
        return (context.read<SevkEtmeForKomisyoncuCubit>().selectedMusteri !=
                    null &&
                context.read<SevkEtmeForKomisyoncuCubit>().gidecegiYer != null)
            ? Padding(
                padding: context.padding.verticalNormal,
                child: FloatingActionButton.extended(
                    heroTag: "Künye Sorgula",
                    backgroundColor: Colors.green,
                    onPressed: () async {
                      context
                          .read<SevkEtmeForKomisyoncuCubit>()
                          .fetchKunyeTransActionsWithNewDate(
                              context
                                  .read<SevkEtmeForKomisyoncuCubit>()
                                  .startDay,
                              context.read<SevkEtmeForKomisyoncuCubit>().endDay)
                          .then((value) {
                        context
                            .read<SevkEtmeForKomisyoncuCubit>()
                            .emitInitialState();

                        DropDownState(
                          DropDown(
                            submitButtonText: "Seçimi tamala",
                            submitButtonColor:
                                const Color.fromRGBO(70, 76, 222, 1),
                            searchHintText: "Ürün arat",
                            bottomSheetTitle: "Referans Künyeler",
                            searchBackgroundColor: Colors.black12,
                            dataList: context
                                .read<SevkEtmeForKomisyoncuCubit>()
                                .allReferansKunyeler
                                .map((e) => SelectedListItem(
                                    context
                                        .read<SevkEtmeForKomisyoncuCubit>()
                                        .kunyeSelectedOrNot(e),
                                    referansKunye: e))
                                .toList(),
                            selectedItems: (List<ReferansKunye> selectedList) {
                              context
                                  .read<SevkEtmeForKomisyoncuCubit>()
                                  .selectedKunyeler = selectedList;
                              context
                                  .read<SevkEtmeForKomisyoncuCubit>()
                                  .kunyelerSelected();

                              context
                                  .read<SevkEtmeForKomisyoncuCubit>()
                                  .searchKunyeTextEditingController
                                  .clear();
                            },
                            enableMultipleSelection: true,
                            searchController: context
                                .read<SevkEtmeForKomisyoncuCubit>()
                                .searchKunyeTextEditingController,
                          ),
                        ).showModal(context);
                      });
                    },
                    label: const Text("Künye Sorgula")),
              )
            : const SizedBox();
      },
    );
  }
}
