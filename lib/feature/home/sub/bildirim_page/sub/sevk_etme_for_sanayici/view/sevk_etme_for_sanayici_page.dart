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
import 'package:hal_app/project/utils/component/dropdown2_driver_search.dart';
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
import '../../../../../viewmodel/cubit/home_cubit.dart';
import '../viewmodel/cubit/sevk_etme_for_sanayici_cubit.dart';

class SevkEtmeForSanayiciPage extends StatelessWidget {
  const SevkEtmeForSanayiciPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child:
              BlocListener<SevkEtmeForSanayiciCubit, SevkEtmeForSanayiciState>(
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
            buildKunyeSorgulama(context),
            buildTable2(context),
          ],
        ),
      )),
    );
  }

  BlocBuilder<SevkEtmeForSanayiciCubit, SevkEtmeForSanayiciState>
      sorgulamaAraligiError() {
    return BlocBuilder<SevkEtmeForSanayiciCubit, SevkEtmeForSanayiciState>(
      builder: (context, state) {
        int difference = context
            .read<SevkEtmeForSanayiciCubit>()
            .endDay
            .difference(context.read<SevkEtmeForSanayiciCubit>().startDay)
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

  void blocListener(BuildContext context, SevkEtmeForSanayiciState state) {
    if (state is SevkEtmeForSanayiciLoading) {
      EasyLoading.instance
        ..indicatorType = EasyLoadingIndicatorType.pouringHourGlass
        ..loadingStyle = EasyLoadingStyle.light
        ..userInteractions = false;
      EasyLoading.show(status: 'HKS Bekleniyor...');
    } else {
      EasyLoading.dismiss();
    }
    if (state is SevkEtmeForSanayiciError) {
      ScaffoldMessengerHelper.instance
          .showErrorSnackBar(context, state.message);
    }
    if (state is SevkEtmeForSanayiciSuccessHasSomeError) {
      if (state.response.kayitCevapList == null) {}
      List<Widget> basarili =
          buildSuccessfulTexts(state.response.kayitCevapList!, context);

      AwesomeDialog(
          btnCancelText: "Kapat",
          btnOkText: "Whatsapp ile paylaş",
          btnCancelOnPress: () {
            context.read<SevkEtmeForSanayiciCubit>().clearFaturaInfo();

            //    Navigator.pop(context); //Named e dönüp düzeteceğim
          },
          btnOkOnPress: () async {
            //  Navigator.pop(context);
            context.read<SevkEtmeForSanayiciCubit>().clearFaturaInfo();

            await context
                .read<SevkEtmeForSanayiciCubit>()
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
                                  .read<SevkEtmeForSanayiciCubit>()
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
    if (state is SevkEtmeForSanayiciCompletelySuccess) {
      AwesomeDialog(
          btnCancelText: "Kapat",
          btnOkText: "Whatsapp ile paylaş",
          btnCancelOnPress: () {
            context.read<SevkEtmeForSanayiciCubit>().clearFaturaInfo();

            //    Navigator.pop(context); //Named e dönüp düzeteceğim
          },
          btnOkOnPress: () async {
            context.read<SevkEtmeForSanayiciCubit>().clearFaturaInfo();

            //  Navigator.pop(context);
            await context
                .read<SevkEtmeForSanayiciCubit>()
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
                                  .read<SevkEtmeForSanayiciCubit>()
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
            .read<SevkEtmeForSanayiciCubit>()
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
    return BlocBuilder<SevkEtmeForSanayiciCubit, SevkEtmeForSanayiciState>(
      builder: (context, state) {
        if (context.read<SevkEtmeForSanayiciCubit>().selectedMusteri != null &&
            context
                .read<SevkEtmeForSanayiciCubit>()
                .selectedMusteri!
                .isregisteredToHks) {
          if (context
                  .read<SevkEtmeForSanayiciCubit>()
                  .musterideOlanSatisYapilabilecekSifatlar
                  .length >
              1) {
            return Padding(
              padding: context.padding.verticalLow,
              child: CustomDropdownButton2(
                hint: 'Gidecek Kişi Sıfatı',
                dropdownItems: context
                    .read<SevkEtmeForSanayiciCubit>()
                    .musterideOlanSatisYapilabilecekSifatlar
                    .values
                    .toList(),
                buttonWidth: context.general.mediaSize.width * .4,
                icon: const Icon(Icons.arrow_drop_down_sharp, size: 24),
                value: context
                    .watch<SevkEtmeForSanayiciCubit>()
                    .selectedSatisYapilacakSifatName,
                onChanged: (value) {
                  context
                      .read<SevkEtmeForSanayiciCubit>()
                      .selectedSatisYapilacakSifatName = value!;

                  context
                      .read<SevkEtmeForSanayiciCubit>()
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
    return BlocBuilder<SevkEtmeForSanayiciCubit, SevkEtmeForSanayiciState>(
      builder: (context, state) {
        if (context.read<SevkEtmeForSanayiciCubit>().selectedMusteri == null) {
          return const SizedBox();
        }

        List<String> nameList = [];
        List<GidecegiYer> gidecegiYerList = [];
        List<Sube> subeler = MusteriSubelerCacheManager.instance.getItem(context
            .read<SevkEtmeForSanayiciCubit>()
            .selectedMusteri!
            .musteriTc);
        List<Depo> depolar = MusteriDepolarCacheManager.instance.getItem(context
            .read<SevkEtmeForSanayiciCubit>()
            .selectedMusteri!
            .musteriTc);
        List<HalIciIsyeri> halIciIsyerleri =
            MusteriHalIciIsyeriCacheManager.instance.getItem(context
                .read<SevkEtmeForSanayiciCubit>()
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
              .read<SevkEtmeForSanayiciCubit>()
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
                searchInnerWidgetHeight: 50,
                searchInnerWidget: Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 4,
                    right: 8,
                    left: 8,
                  ),
                  child: TextFormField(
                    controller: context
                        .read<SevkEtmeForSanayiciCubit>()
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
                searchController: context
                    .read<SevkEtmeForSanayiciCubit>()
                    .gidecegiYerController,
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
              value: context.read<SevkEtmeForSanayiciCubit>().gidecegiYer,
              onChanged: (value) {
                context.read<SevkEtmeForSanayiciCubit>().gidecegiYer =
                    (value as GidecegiYer);
                context.read<SevkEtmeForSanayiciCubit>().gidecegiYerSelected();
              },
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  context
                      .read<SevkEtmeForSanayiciCubit>()
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

  BlocBuilder<SevkEtmeForSanayiciCubit, SevkEtmeForSanayiciState> buildTable2(
      BuildContext context) {
    return BlocBuilder<SevkEtmeForSanayiciCubit, SevkEtmeForSanayiciState>(
      builder: (context, state) {
        return context
                .watch<SevkEtmeForSanayiciCubit>()
                .selectedKunyeler
                .ext
                .isNullOrEmpty
            ? Container()
            : Column(
                children: [
                  Text(
                      "Toplam Künye Sayısı ${context.watch<SevkEtmeForSanayiciCubit>().selectedKunyeler.length}"),
                  SizedBox(
                    height: 50 +
                        (context
                                .read<SevkEtmeForSanayiciCubit>()
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
                              .read<SevkEtmeForSanayiciCubit>()
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
                                            .read<SevkEtmeForSanayiciCubit>()
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
                                      .read<SevkEtmeForSanayiciCubit>()
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
      child: !context.read<SevkEtmeForSanayiciCubit>().isIrsaliye
          ? const SizedBox()
          : Column(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        !context.read<SevkEtmeForSanayiciCubit>().isSurucuManual
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
    return BlocBuilder<SevkEtmeForSanayiciCubit, SevkEtmeForSanayiciState>(
      builder: (context, state) {
        return DropDown2DriverSearch(
          controller: context
              .read<SevkEtmeForSanayiciCubit>()
              .driverAdiControllerForDropDown,
          onChanged: (value) {
            context.read<SevkEtmeForSanayiciCubit>().selectedDriver = value;
            context.read<SevkEtmeForSanayiciCubit>().emitInitialState();
          },
          selectedValue:
              context.read<SevkEtmeForSanayiciCubit>().selectedDriver,
          onMenuStateChange: () {
            context
                .read<SevkEtmeForSanayiciCubit>()
                .driverAdiControllerForDropDown
                .clear();
          },
        );
      },
    );
  }

  Widget buildDriverForm(BuildContext context) {
    return !context.read<SevkEtmeForSanayiciCubit>().isSurucuManual
        ? const SizedBox()
        : Form(
            key: context.read<SevkEtmeForSanayiciCubit>().driverFormKey,
            child: Column(
              children: [
                Padding(
                  padding: context.padding.normal,
                  child: TextFormField(
                    controller: context
                        .read<SevkEtmeForSanayiciCubit>()
                        .driverIdController,
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'lütfen Tc giriniz';
                      }
                      if (!context
                          .read<SevkEtmeForSanayiciCubit>()
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
                        .read<SevkEtmeForSanayiciCubit>()
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
                        .read<SevkEtmeForSanayiciCubit>()
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
                        .read<SevkEtmeForSanayiciCubit>()
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
        value: context.read<SevkEtmeForSanayiciCubit>().isSurucuManual,
        onChanged: (value) {
          context.read<SevkEtmeForSanayiciCubit>().isSurucuManual = value!;
          context.read<SevkEtmeForSanayiciCubit>().emitInitialState();
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
            return BlocBuilder<SevkEtmeForSanayiciCubit,
                SevkEtmeForSanayiciState>(
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
      value: context.read<SevkEtmeForSanayiciCubit>().isIrsaliye,
      onChanged: (value) {
        context.read<SevkEtmeForSanayiciCubit>().isIrsaliye = value!;
        context.read<SevkEtmeForSanayiciCubit>().emitInitialState();
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
                .read<SevkEtmeForSanayiciCubit>()
                .activateAutoValidateModeForPlaka();
            if (context.read<SevkEtmeForSanayiciCubit>().isIrsaliye) {
              if (context.read<SevkEtmeForSanayiciCubit>().isSurucuManual) {
                context
                    .read<SevkEtmeForSanayiciCubit>()
                    .activateAutoValidateModeForDriver();

                if (context
                    .read<SevkEtmeForSanayiciCubit>()
                    .driverFormKey
                    .currentState!
                    .validate()) {
                  context.read<SevkEtmeForSanayiciCubit>().selectedDriver =
                      DriverModel(
                          tc: context
                              .read<SevkEtmeForSanayiciCubit>()
                              .driverIdController
                              .text
                              .trim(),
                          userName: context
                              .read<SevkEtmeForSanayiciCubit>()
                              .driverNameController
                              .text
                              .trim()
                              .toUpperCaseTr());
                  if (context
                      .read<SevkEtmeForSanayiciCubit>()
                      .plakaFormKey
                      .currentState!
                      .validate()) {
                    context
                        .read<SevkEtmeForSanayiciCubit>()
                        .disableAutoValidateModeForPlaka();
                    await context
                        .read<SevkEtmeForSanayiciCubit>()
                        .bildirimYap(context);
                  }
                }
              } else {
                if (context.read<SevkEtmeForSanayiciCubit>().selectedDriver ==
                    null) {
                  context.read<SevkEtmeForSanayiciCubit>().emitError(
                      "Sürücü Seçiniz ve ya manuel olarak ekleyiniz");
                } else {
                  if (context
                      .read<SevkEtmeForSanayiciCubit>()
                      .plakaFormKey
                      .currentState!
                      .validate()) {
                    context
                        .read<SevkEtmeForSanayiciCubit>()
                        .disableAutoValidateModeForPlaka();
                    await context
                        .read<SevkEtmeForSanayiciCubit>()
                        .bildirimYap(context);
                  }
                }
                //check selected driver
              }
            } else {
              if (context
                  .read<SevkEtmeForSanayiciCubit>()
                  .plakaFormKey
                  .currentState!
                  .validate()) {
                context
                    .read<SevkEtmeForSanayiciCubit>()
                    .disableAutoValidateModeForPlaka();
                await context
                    .read<SevkEtmeForSanayiciCubit>()
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
      child: BlocBuilder<SevkEtmeForSanayiciCubit, SevkEtmeForSanayiciState>(
        builder: (context, state) {
          return Form(
            key: context.read<SevkEtmeForSanayiciCubit>().plakaFormKey,
            child: TextFormField(
              autovalidateMode: context
                  .read<SevkEtmeForSanayiciCubit>()
                  .isAutoValidateModeForPlaka,
              validator: ((value) {
                if (value == null || value.isEmpty) {
                  return 'lütfen plaka bilgisi giriniz';
                }
                return null;
              }),
              controller:
                  context.read<SevkEtmeForSanayiciCubit>().plakaController,
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
    return BlocBuilder<SevkEtmeForSanayiciCubit, SevkEtmeForSanayiciState>(
      builder: (context, state) {
        return (context.read<SevkEtmeForSanayiciCubit>().selectedMusteri !=
                    null &&
                context.read<SevkEtmeForSanayiciCubit>().gidecegiYer != null)
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
        BlocBuilder<SevkEtmeForSanayiciCubit, SevkEtmeForSanayiciState>(
          builder: (context, state) {
            return CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => _showDialog(
                  CupertinoDatePicker(
                    dateOrder: DatePickerDateOrder.dmy,
                    initialDateTime:
                        context.read<SevkEtmeForSanayiciCubit>().endDay,
                    maximumDate:
                        context.read<SevkEtmeForSanayiciCubit>().maxDate,
                    mode: CupertinoDatePickerMode.date,
                    use24hFormat: true,
                    onDateTimeChanged: (DateTime newDate) {
                      context.read<SevkEtmeForSanayiciCubit>().endDay = newDate;
                      context
                          .read<SevkEtmeForSanayiciCubit>()
                          .emitInitialState();
                    },
                  ),
                  context),
              child: Text(
                '${context.read<SevkEtmeForSanayiciCubit>().endDay.day}-${context.read<SevkEtmeForSanayiciCubit>().endDay.month}-${context.read<SevkEtmeForSanayiciCubit>().endDay.year}',
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

  BlocBuilder<SevkEtmeForSanayiciCubit, SevkEtmeForSanayiciState>
      buildStartDate() {
    return BlocBuilder<SevkEtmeForSanayiciCubit, SevkEtmeForSanayiciState>(
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
                        context.read<SevkEtmeForSanayiciCubit>().startDay,
                    maximumDate:
                        context.read<SevkEtmeForSanayiciCubit>().maxDate,
                    mode: CupertinoDatePickerMode.date,
                    use24hFormat: true,
                    onDateTimeChanged: (DateTime newDate) {
                      context.read<SevkEtmeForSanayiciCubit>().startDay =
                          newDate;
                      context
                          .read<SevkEtmeForSanayiciCubit>()
                          .emitInitialState();
                    },
                  ),
                  context),
              child: Text(
                '${context.read<SevkEtmeForSanayiciCubit>().startDay.day}-${context.read<SevkEtmeForSanayiciCubit>().startDay.month}-${context.read<SevkEtmeForSanayiciCubit>().startDay.year}',
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
    return BlocBuilder<SevkEtmeForSanayiciCubit, SevkEtmeForSanayiciState>(
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
                        .read<SevkEtmeForSanayiciCubit>()
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
              return DropdownButtonHideUnderline(
                child: DropdownButton2<Musteri>(
                  isExpanded: true,
                  dropdownSearchData: DropdownSearchData(
                    searchController: context
                        .read<SevkEtmeForSanayiciCubit>()
                        .musteriAdiController,
                    searchMatchFn: (item, searchValue) {
                      return ((item.value as Musteri)
                          .musteriAdiSoyadi
                          .toString()
                          .toLowerCaseTr()
                          .contains(searchValue.toLowerCaseTr()));
                    },
                  ),
                  dropdownStyleData: DropDown2Style.dropdownStyleData(context,
                      width: context.general.mediaSize.width * .5),
                  buttonStyleData: DropDown2Style.buttonStyleData(context,
                      width: context.general.mediaSize.width * .4),
                  hint: Text('Müşteri Seç',
                      style: TextStyle(
                          fontSize: 12, color: Theme.of(context).hintColor)),
                  items: musteriList
                      .map((musteri) => DropdownMenuItem<Musteri>(
                            value: musteri,
                            child: Text(
                                musteri == null
                                    ? "Toplama Mal"
                                    : (musteri.musteriAdiSoyadi),
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  value:
                      context.read<SevkEtmeForSanayiciCubit>().selectedMusteri,
                  onChanged: (value) {
                    //   if (context.read<SatisCubit>().urunList.isNotEmpty) {
                    //     ScaffoldMessengerHelper.instance.showErrorSnackBar(context,
                    //         "Tabloda ürün varken üretici bilgileri değiştirilemez");
                    //   } else {

                    //   }
                    //   context.read<SevkEtmeForSanayiciCubit>().clearMusteriSifatInfos();

                    context.read<SevkEtmeForSanayiciCubit>().selectedMusteri =
                        value as Musteri;
                    context.read<SevkEtmeForSanayiciCubit>().musteriSelected();
                  },
                  underline: Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: TextFormField(
                      controller: context
                          .read<SevkEtmeForSanayiciCubit>()
                          .musteriAdiController,
                      //  autofocus: true,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        hintText: 'Müşteri Ara',
                        hintStyle: const TextStyle(fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      context
                          .read<SevkEtmeForSanayiciCubit>()
                          .musteriAdiController
                          .clear();
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget buildKunyeSorgulama(BuildContext context) {
    return BlocBuilder<SevkEtmeForSanayiciCubit, SevkEtmeForSanayiciState>(
      builder: (context, state) {
        return (context.read<SevkEtmeForSanayiciCubit>().selectedMusteri !=
                    null &&
                context.read<SevkEtmeForSanayiciCubit>().gidecegiYer != null)
            ? Padding(
                padding: context.padding.verticalNormal,
                child: FloatingActionButton.extended(
                    heroTag: "Künye Sorgula",
                    backgroundColor: Colors.green,
                    onPressed: () async {
                      context
                          .read<SevkEtmeForSanayiciCubit>()
                          .fetchKunyeTransActionsWithNewDate(
                              context.read<SevkEtmeForSanayiciCubit>().startDay,
                              context.read<SevkEtmeForSanayiciCubit>().endDay)
                          .then((value) {
                        context
                            .read<SevkEtmeForSanayiciCubit>()
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
                                .read<SevkEtmeForSanayiciCubit>()
                                .allReferansKunyeler
                                .map((e) => SelectedListItem(
                                    context
                                        .read<SevkEtmeForSanayiciCubit>()
                                        .kunyeSelectedOrNot(e),
                                    referansKunye: e))
                                .toList(),
                            selectedItems: (List<ReferansKunye> selectedList) {
                              context
                                  .read<SevkEtmeForSanayiciCubit>()
                                  .selectedKunyeler = selectedList;
                              context
                                  .read<SevkEtmeForSanayiciCubit>()
                                  .kunyelerSelected();

                              context
                                  .read<SevkEtmeForSanayiciCubit>()
                                  .searchKunyeTextEditingController
                                  .clear();
                            },
                            enableMultipleSelection: true,
                            searchController: context
                                .read<SevkEtmeForSanayiciCubit>()
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
