// dropdown done
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hal_app/core/utils/dropdown2_style/dropdown2_style.dart';
import 'package:hal_app/project/cache/depo_cache_manager.dart';
import 'package:hal_app/project/cache/hal_ici_isyeri_cache_manager.dart';
import 'package:hal_app/project/cache/sube_cache_manager.dart';
import 'package:hal_app/project/model/depo/depo_model.dart';
import 'package:hal_app/project/model/driver_model/driver_model.dart';
import 'package:hal_app/project/model/hal_ici_isyeri/hal_ici_isyeri_model.dart';
import 'package:hal_app/project/utils/component/dropdown2_driver_search.dart';
import 'package:hal_app/project/utils/component/dropdown2_string_search.dart';
import 'package:hal_app/project/utils/component/dropdown2_uretici_search.dart';
import '../../../../../../../project/cache/mysoft_user_cache_mananger.dart';
import '../../../../../../../project/model/MySoft_user_model/mysoft_user_model.dart';
import '../../../../../../../project/model/malin_gidecegi_yer/malin_gidecegi_yer_model.dart';
import '../../../../../../../project/model/sube/sube_model.dart';
import '../../../../../../helper/scaffold_messager.dart';
import '../../sat%C4%B1n_al%C4%B1m_page/viewmodel/cubit/satin_alim_cubit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kartal/kartal.dart';
import 'package:turkish/turkish.dart';

import '../../../../../../../project/model/bildirim_kayit_response_model.dart/sub/bildirim_kayit_cevap_model.dart';
import '../../../../../../helper/active_tc.dart';
import 'package:data_table_2/data_table_2.dart';

class SatinAlinPage extends StatelessWidget {
  const SatinAlinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SatinAlimCubit, SatinAlimState>(
      listener: buildBlocListener,
      builder: (BuildContext context, SatinAlimState state) {
        return Padding(
          padding: context.padding.horizontalLow,
          child: Form(
            key: context.read<SatinAlimCubit>().formKey,
            child: ListView(
              shrinkWrap: true,
              controller: context.read<SatinAlimCubit>().scrollController,
              children: [
                Row(
                  children: [
                    Expanded(child: buildToplamaMal()),
                    Expanded(
                      child: buildUreticiAdiField2(context),
                    )
                    // Expanded(
                    //     child: buildUreticiAdiField(context) ),
                  ],
                ),
                //  buildToplamaMal(),
                buildIkinciKisiBilgilerField(),
                Row(
                  children: [
                    //     Expanded(child: buildMalinAdiField()),
                    Expanded(
                        child: Padding(
                      padding: context.padding.low,
                      child: buildMalinAdiField2(context),
                    )),
                    Expanded(
                        child: Padding(
                      padding: context.padding.low,
                      child: buildMalinCinsiField2(context),
                    )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: buildBagAdetKgField(context)),
                    Expanded(child: buildBirimFiyatiColumn(context)),
                  ],
                ),
                buildMalinGidecegiYerDropDown(context),
                const Text(
                    "Küsürlü ifadeleri virgül (,) ve ya nokta (.) ile giriniz.",
                    textAlign: TextAlign.center),

                BlocBuilder<SatinAlimCubit, SatinAlimState>(
                  builder: (context, state) {
                    return context
                                .read<SatinAlimCubit>()
                                .dropDownErrorMessage ==
                            ""
                        ? const SizedBox()
                        : Padding(
                            padding: context.padding.verticalLow,
                            child: Text(
                              context
                                  .read<SatinAlimCubit>()
                                  .dropDownErrorMessage,
                              style: context.general.textTheme.bodyMedium!
                                  .apply(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          );
                  },
                ),
                buildUrunleriListeyeEkleButton(context),
                //  buildTableView2(context),

                buildTable2(context),
                Padding(
                    // this is new
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom)),
                //   buildTableColumn,
                //keyboardHeight > 0
                //    ? SizedBox(height: 200)
                //    : SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }

  Padding buildUrunleriListeyeEkleButton(BuildContext context) {
    return Padding(
      padding: context.padding.horizontalHigh,
      child: Padding(
        padding: context.padding.verticalNormal,
        child: FloatingActionButton.extended(
          heroTag: "Ürünü Listeye Ekle",
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            context.read<SatinAlimCubit>().activateAutoValidateMode();
            var result =
                context.read<SatinAlimCubit>().checkDropDownFieldHasError();
            if (context
                    .read<SatinAlimCubit>()
                    .formKey
                    .currentState!
                    .validate() &&
                !result) {
              context.read<SatinAlimCubit>().disableAutoValidateMode();

              context.read<SatinAlimCubit>().urunEkle();
            }
          },
          label: const Text("Ürünü Listeye Ekle"),
          backgroundColor: Colors.green[600],
        ),
      ),
    );
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

  List<Widget> buildSuccessfulTexts(
      List<BildirimKayitCevapModel> cevapList, BuildContext context) {
    List<Widget> list = [];
    for (var element in cevapList) {
      if (!(element.kunyeNo == "0" || element.kunyeNo == null)) {
        String malAdi = "";
        context.read<SatinAlimCubit>().getMallar.forEach((key, value) {
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

  void buildBlocListener(BuildContext context, SatinAlimState state) {
    // TODO: implement listener
    if (state is SatinAlimLoading) {
      EasyLoading.instance
        ..indicatorType = EasyLoadingIndicatorType.pouringHourGlass
        ..loadingStyle = EasyLoadingStyle.light
        ..userInteractions = false;
      EasyLoading.show(status: 'HKS Bekleniyor...');

      //context.loaderOverlay.show();
    } else {
      EasyLoading.dismiss();
      //if (context.loaderOverlay.visible) {
      //context.loaderOverlay.hide();
      //}
    }

    if (state is SatinAlimError) {
      ScaffoldMessengerHelper.instance
          .showErrorSnackBar(context, state.message);
    }
    if (state is SatinAlimSuccessHasSomeError) {
      if (state.response.kayitCevapList == null) {}
      List<Widget> basarili =
          buildSuccessfulTexts(state.response.kayitCevapList!, context);

      AwesomeDialog(
          btnCancelText: "Kapat",
          btnOkText: "Whatsapp ile paylaş",
          btnCancelOnPress: () {
            //    Navigator.pop(context); //Named e dönüp düzeteceğim
            context.read<SatinAlimCubit>().clearFaturaInfo();
          },
          btnOkOnPress: () async {
            //  Navigator.pop(context);
            context.read<SatinAlimCubit>().clearFaturaInfo();

            await context
                .read<SatinAlimCubit>()
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
                      Row(
                        children: [
                          const Text(
                            "E-Müstahsil  ",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          context.read<SatinAlimCubit>().isMustahsilKesSuccess
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
                            "E-İrsaliye  ",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          context.read<SatinAlimCubit>().isIrsaliyeKesSuccess
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
    if (state is SatinAlimCompletelySuccess) {
      AwesomeDialog(
          btnCancelText: "Kapat",
          btnOkText: "Whatsapp ile paylaş",
          btnCancelOnPress: () {
            //    Navigator.pop(context); //Named e dönüp düzeteceğim
            context.read<SatinAlimCubit>().clearFaturaInfo();
          },
          btnOkOnPress: () async {
            //  Navigator.pop(context);
            context.read<SatinAlimCubit>().clearFaturaInfo();

            await context
                .read<SatinAlimCubit>()
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
                      Row(
                        children: [
                          const Text(
                            "E-Müstahsil  ",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          context.read<SatinAlimCubit>().isMustahsilKesSuccess
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
                            "E-İrsaliye  ",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          context.read<SatinAlimCubit>().isIrsaliyeKesSuccess
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

  BlocBuilder<SatinAlimCubit, SatinAlimState> buildTable2(
      BuildContext context) {
    return BlocBuilder<SatinAlimCubit, SatinAlimState>(
      builder: (context, state) {
        return context.watch<SatinAlimCubit>().urunList.ext.isNullOrEmpty
            ? Container()
            : Column(
                children: [
                  SizedBox(
                    height: 50 +
                        (context.read<SatinAlimCubit>().urunList.length * 60),
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
                          DataColumn(
                            label: Text('Fiyat'),
                          ),
                          DataColumn2(
                            label: Icon(Icons.delete_forever_outlined,
                                color: Colors.green),
                            fixedWidth: 30,
                            size: ColumnSize.S,
                          ),
                        ],
                        rows: <DataRow>[
                          ...(context.read<SatinAlimCubit>().urunList.map(
                            (e) {
                              Icons.delete;
                              return DataRow(cells: <DataCell>[
                                DataCell(Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.urunAdi,
                                      overflow: TextOverflow.visible,
                                      style: context
                                          .general.textTheme.labelSmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      e.urunCinsi,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          context.general.textTheme.labelSmall,
                                    )
                                  ],
                                )),
                                //miktar
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

                                      if (value.trim() != "") {
                                        if (!context
                                            .read<SatinAlimCubit>()
                                            .isNumeric(value.trim())) {
                                          return "rakam ve . , kullanabilirsiniz";
                                        }
                                      }

                                      if (double.parse(value) >= 0) {
                                        e.gonderilmekIstenenMiktar = value;
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: context.padding.low,
                                      constraints: BoxConstraints(
                                          maxHeight:
                                              context.sized.normalValue * 3),
                                      hintText:
                                          "${e.urunMiktari} ${e.urunBirimAdi}",
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                )),
                                //fiyat
                                DataCell(Padding(
                                  //  padding: context.padding.verticalLow,
                                  padding: EdgeInsets.fromLTRB(
                                    context.sized.lowValue,
                                    context.sized.lowValue,
                                    context.sized.lowValue,
                                    context.sized.lowValue,
                                  ),
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

                                      if (value.trim() != "") {
                                        if (!context
                                            .read<SatinAlimCubit>()
                                            .isNumeric(value.trim())) {
                                          return "rakam ve . , kullanabilirsiniz";
                                        }
                                      }

                                      if (double.parse(value) >= 0) {
                                        e.gonderilmekIstenenFiyat = value;
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: context.padding.low,
                                      constraints: BoxConstraints(
                                          maxHeight:
                                              context.sized.normalValue * 3),
                                      hintText: (e.urunFiyati),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                )),
                                DataCell(
                                    const Center(
                                        child: Icon(Icons.delete_rounded,
                                            color: Colors.green)), onTap: () {
                                  context
                                      .read<SatinAlimCubit>()
                                      .removeFromUrunList(e);
                                })
                              ]);
                            },
                          ).toList()),
                        ]),
                  ),
                  buildAracPlakaField(context),
                  buildFaturaColumn(context),
                  !context.read<SatinAlimCubit>().isIrsaliye
                      ? const SizedBox()
                      : Column(
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    !context
                                            .read<SatinAlimCubit>()
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

                  buildBildirimYapButton(context),

                  // Expanded(child: SizedBox())
                ],
              );
      },
    );
  }

  Widget buildDriverForm(BuildContext context) {
    return !context.read<SatinAlimCubit>().isSurucuManual
        ? const SizedBox()
        : Form(
            key: context.read<SatinAlimCubit>().driverFormKey,
            child: Column(
              children: [
                Padding(
                  padding: context.padding.normal,
                  child: TextFormField(
                    controller:
                        context.read<SatinAlimCubit>().driverIdController,
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'lütfen Tc giriniz';
                      }
                      if (!context.read<SatinAlimCubit>().isNumeric(value)) {
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
                        .read<SatinAlimCubit>()
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
                    controller:
                        context.read<SatinAlimCubit>().driverNameController,
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
                        .read<SatinAlimCubit>()
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
        value: context.read<SatinAlimCubit>().isSurucuManual,
        onChanged: (value) {
          context.read<SatinAlimCubit>().isSurucuManual = value!;
          context.read<SatinAlimCubit>().emitInitial();
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
            return BlocBuilder<SatinAlimCubit, SatinAlimState>(
              builder: (context, state) {
                return Row(
                  children: [
                    Expanded(
                        child: context.read<SatinAlimCubit>().isToplamaHal
                            ? const SizedBox()
                            : buildMustahsilCheckBox(context)),
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

  Widget buildMustahsilCheckBox(BuildContext context) {
    return CheckboxListTile(
      activeColor: Colors.green,
      value: context.read<SatinAlimCubit>().isMustahsil,
      onChanged: (value) {
        context.read<SatinAlimCubit>().isMustahsil = value!;
        context.read<SatinAlimCubit>().emitInitial();
      },
      title: const Text(
        "Müstahsil Kes",
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildIrasaliyeCheckBox(BuildContext context) {
    return CheckboxListTile(
      activeColor: Colors.green,
      value: context.read<SatinAlimCubit>().isIrsaliye,
      onChanged: (value) {
        context.read<SatinAlimCubit>().isIrsaliye = value!;
        context.read<SatinAlimCubit>().emitInitial();
      },
      title: const Text(
        "İrsaliye Kes",
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildTableView2(BuildContext context) {
    return BlocBuilder<SatinAlimCubit, SatinAlimState>(
      builder: (context, state) {
        return context.watch<SatinAlimCubit>().urunList.ext.isNullOrEmpty
            ? Container()
            : SizedBox(
                height: 50 +
                    (context.read<SatinAlimCubit>().urunList.length * 50) +
                    200,
                child: Column(
                  children: [
                    Expanded(
                      child: DataTable(
                        headingRowHeight: 50,
                        dataRowHeight: 50,
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text(
                              'Ürün Adı',
                              style: TextStyle(fontStyle: FontStyle.italic),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Miktarı',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Fiyatı',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                        rows: <DataRow>[
                          ...(context.read<SatinAlimCubit>().urunList.map(
                            (e) {
                              Icons.delete;
                              return DataRow(cells: <DataCell>[
                                DataCell(Column(
                                  children: [
                                    Text(e.urunAdi),
                                    Text(e.urunCinsi)
                                  ],
                                )),
                                // DataCell(Text((e.kalanMiktar ?? "boş") +  " " + (e.malinMiktarBirimAd ?? "boş"))),
                                DataCell(Padding(
                                  padding: context.padding.verticalLow,
                                  child: TextFormField(
                                    autovalidateMode: AutovalidateMode.always,
                                    keyboardType: TextInputType.phone,
                                    // controller: ,d
                                    //   controller: TextEditingController()
                                    //     ..text = (e.kalanMiktar ?? "boş") +
                                    //         " " +
                                    //         (e.malinMiktarBirimAd ?? "boş"),
                                    maxLines: 1,
                                    validator: (value) {
                                      bool isNumeric = context
                                          .read<SatinAlimCubit>()
                                          .isNumeric(value);
                                      if (isNumeric) {
                                        e.urunMiktari = value!;
                                      }
                                      //  value = value?.trim();

                                      //      (value == null || value.isEmpty || value == ""));

                                      //  if (!(double.parse((value == null ||
                                      //              value.isEmpty ||
                                      //              value == "")
                                      //          ? e.kalanMiktar!
                                      //          : value) <=
                                      //      double.parse(e.kalanMiktar!))) {
                                      //    return "kalan miktar hata";
                                      //  }

                                      //  if (!(value == null)) {
                                      //    if (value == "") {
                                      //      value = "0";
                                      //    }
                                      //    if (double.parse(value) >= 0) {
                                      //      e.gonderilmekIstenenMiktar = value;
                                      //    }
                                      //  }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: context.padding.low,
                                      constraints: BoxConstraints(
                                          maxHeight:
                                              context.sized.normalValue * 3),
                                      hintText:
                                          "${e.urunMiktari} ${e.urunBirimAdi}",
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                )),
                                DataCell(showEditIcon: true, onTap: () {
                                  context
                                      .read<SatinAlimCubit>()
                                      .removeFromUrunList(e);
                                },
                                    Padding(
                                      //  padding: context.padding.verticalLow,
                                      padding: EdgeInsets.fromLTRB(
                                        context.sized.lowValue,
                                        context.sized.lowValue,
                                        context.sized.lowValue,
                                        context.sized.lowValue,
                                      ),
                                      child: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.always,
                                        keyboardType: TextInputType.phone,
                                        maxLines: 1,
                                        validator: (value) {
                                          bool isNumeric = context
                                              .read<SatinAlimCubit>()
                                              .isNumeric(value);
                                          if (isNumeric) {
                                            e.urunFiyati = value!;
                                          }

                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          contentPadding: context.padding.low,
                                          constraints: BoxConstraints(
                                              maxHeight:
                                                  context.sized.normalValue *
                                                      3),
                                          hintText: (e.urunFiyati),
                                          border: const OutlineInputBorder(),
                                        ),
                                      ),
                                    )),
                              ]);
                            },
                          ).toList()),
                        ],
                      ),
                    ),
                    buildAracPlakaField(context),
                    buildBildirimYapButton(context),
                  ],
                ),
              );
      },
    );
  }

  BlocBuilder<SatinAlimCubit, SatinAlimState> get buildTableColumn =>
      BlocBuilder<SatinAlimCubit, SatinAlimState>(
        builder: (context, state) {
          return context.read<SatinAlimCubit>().urunList.ext.isNullOrEmpty
              ? const SizedBox()
              : Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Eklenen Ürün Listesi",
                            textAlign: TextAlign.center,
                            style: context.general.textTheme.titleLarge)),
                    Padding(
                      padding: context.padding.horizontalLow,
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(4),
                          1: FlexColumnWidth(4),
                          2: FlexColumnWidth(4),
                          3: FlexColumnWidth(4),
                          4: FlexColumnWidth(4),
                          5: FlexColumnWidth(2),
                        },
                        border: TableBorder.all(
                            borderRadius: BorderRadius.circular(10)),
                        children: [
                          buildTableHeader(),
                          ...buildTableContents(context)
                        ],
                      ),
                    ),
                    buildBildirimYapButton(context)
                  ],
                );
        },
      );

  Padding buildBildirimYapButton(BuildContext context) {
    return Padding(
      padding: context.padding.verticalNormal,
      child: FloatingActionButton.extended(
          heroTag: "Bildirim Yap",
          backgroundColor: Colors.green,
          onPressed: () async {
            context.read<SatinAlimCubit>().activateAutoValidateModeForPlaka();
            if (context.read<SatinAlimCubit>().isIrsaliye) {
              if (context.read<SatinAlimCubit>().isSurucuManual) {
                context
                    .read<SatinAlimCubit>()
                    .activateAutoValidateModeForDriver();
                if (context
                    .read<SatinAlimCubit>()
                    .driverFormKey
                    .currentState!
                    .validate()) {
                  context.read<SatinAlimCubit>().selectedDriver = DriverModel(
                      tc: context
                          .read<SatinAlimCubit>()
                          .driverIdController
                          .text
                          .trim(),
                      userName: context
                          .read<SatinAlimCubit>()
                          .driverNameController
                          .text
                          .trim()
                          .toUpperCaseTr());
                  if (context
                          .read<SatinAlimCubit>()
                          .plakaFormKey
                          .currentState !=
                      null) {
                    if (context
                        .read<SatinAlimCubit>()
                        .plakaFormKey
                        .currentState!
                        .validate()) {
                      context
                          .read<SatinAlimCubit>()
                          .disableAutoValidateModeForPlaka();
                      await context.read<SatinAlimCubit>().bildirimYap(context);
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                  }
                }
              } else {
                if (context.read<SatinAlimCubit>().selectedDriver == null) {
                  context.read<SatinAlimCubit>().emitError(
                      "Sürücü Seçiniz ve ya manuel olarak ekleyiniz");
                } else {
                  if (context
                          .read<SatinAlimCubit>()
                          .plakaFormKey
                          .currentState !=
                      null) {
                    if (context
                        .read<SatinAlimCubit>()
                        .plakaFormKey
                        .currentState!
                        .validate()) {
                      context
                          .read<SatinAlimCubit>()
                          .disableAutoValidateModeForPlaka();
                      await context.read<SatinAlimCubit>().bildirimYap(context);
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                  }
                }
                //check selected driver
              }
            } else {
              if (context.read<SatinAlimCubit>().plakaFormKey.currentState !=
                  null) {
                if (context
                    .read<SatinAlimCubit>()
                    .plakaFormKey
                    .currentState!
                    .validate()) {
                  context
                      .read<SatinAlimCubit>()
                      .disableAutoValidateModeForPlaka();
                  await context.read<SatinAlimCubit>().bildirimYap(context);
                }
              } else {}
            }

            //  context.read<SatinAlimCubit>().plakaController.
            //  context.read<SatinAlimCubit>().bildirimYap();
          },
          label: const Text("Bildirim Yap")),
    );
  }

  Padding buildAracPlakaField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<SatinAlimCubit, SatinAlimState>(
        builder: (context, state) {
          return Form(
            key: context.read<SatinAlimCubit>().plakaFormKey,
            child: TextFormField(
              autovalidateMode:
                  context.read<SatinAlimCubit>().isAutoValidateModeForPlaka,
              validator: ((value) {
                if (value == null || value.isEmpty) {
                  return 'lütfen plaka bilgisi giriniz';
                }
                return null;
              }),
              controller: context.read<SatinAlimCubit>().plakaController,
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

  //TODO: total tl için converter yaz . , virgül convertı da yaz
  List<TableRow> buildTableContents(BuildContext context) {
    return context
        .read<SatinAlimCubit>()
        .urunList
        .map(
          (e) => TableRow(children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
              child: Center(child: Text(e.urunAdi)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
              child: Center(child: Text(e.urunCinsi)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
              child: Center(child: Text("${e.urunMiktari} ${e.urunBirimAdi}")),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
              child: Center(
                  child:
                      Text((double.parse(e.urunFiyati!).toStringAsFixed(2)))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
              child: Center(
                  child: Text(((double.parse(e.urunFiyati!) *
                          double.parse(e.urunMiktari))
                      .toStringAsFixed(2)))),
            ),
            SizedBox(
              height: 35,
              child: IconButton(
                onPressed: () {
                  context.read<SatinAlimCubit>().removeFromUrunList(e);
                },
                icon: const Icon(Icons.highlight_remove_outlined,
                    color: Colors.green),
                padding: EdgeInsets.zero,
              ),
            )
          ]),
        )
        .toList();
  }

  Widget buildCityField2(BuildContext context) {
    return DropDown2StringSearch(
      controller: context.read<SatinAlimCubit>().ilController,
      items: context.read<SatinAlimCubit>().getCities.values.toList(),
      hint: 'İl Seç',
      onChanged: (value) {
        if (context.read<SatinAlimCubit>().urunList.isNotEmpty) {
          ScaffoldMessengerHelper.instance.showErrorSnackBar(
              context, "Tabloda ürün varken üretici bilgileri değiştirilemez");
        } else {
          context.read<SatinAlimCubit>().ilSelected(value);
        }
      },
      selectedValue: context.read<SatinAlimCubit>().selectedIl,
      onMenuStateChange: () {
        context.read<SatinAlimCubit>().ilController.clear();
      },
    );
  }

  Widget buildIlceField2(BuildContext context) {
    return DropDown2StringSearch(
      controller: context.read<SatinAlimCubit>().ilceController,
      items: context.read<SatinAlimCubit>().getIlceler.values.toList(),
      hint: 'İlçe Seç',
      onChanged: (value) {
        if (context.read<SatinAlimCubit>().urunList.isNotEmpty) {
          ScaffoldMessengerHelper.instance.showErrorSnackBar(
              context, "Tabloda ürün varken üretici bilgileri değiştirilemez");
        } else {
          context.read<SatinAlimCubit>().ilceSelected(value);
        }
      },
      selectedValue: context.read<SatinAlimCubit>().selectedIlce,
      onMenuStateChange: () {
        context.read<SatinAlimCubit>().ilceController.clear();
      },
    );
  }

  Widget buildBeldeField2(BuildContext context) {
    return DropDown2StringSearch(
      controller: context.read<SatinAlimCubit>().beldeController,
      items: context.read<SatinAlimCubit>().getBeldeler.values.toList(),
      hint: 'Belde Seç',
      onChanged: (value) {
        if (context.read<SatinAlimCubit>().urunList.isNotEmpty) {
          ScaffoldMessengerHelper.instance.showErrorSnackBar(
              context, "Tabloda ürün varken üretici bilgileri değiştirilemez");
        } else {
          context.read<SatinAlimCubit>().selectedBelde = value;
          context.read<SatinAlimCubit>().beldeSelected();
        }
      },
      selectedValue: context.read<SatinAlimCubit>().selectedBelde,
      onMenuStateChange: () {
        context.read<SatinAlimCubit>().beldeController.clear();
      },
    );
  }

  Widget buildUreticiAdiField2(BuildContext context) {
    return BlocBuilder<SatinAlimCubit, SatinAlimState>(
      builder: (context, state) {
        return context.read<SatinAlimCubit>().isToplamaHal
            ? const SizedBox()
            : DropDown2UreticiSearch(
                controller: context.read<SatinAlimCubit>().ureticiAdiController,
                onChanged: (value) {
                  if (context.read<SatinAlimCubit>().urunList.isNotEmpty) {
                    ScaffoldMessengerHelper.instance.showErrorSnackBar(context,
                        "Tabloda ürün varken üretici bilgileri değiştirilemez");
                  } else {
                    context.read<SatinAlimCubit>().selectedUretici = value;
                    context.read<SatinAlimCubit>().ureticiSelected();
                  }
                },
                selectedValue: context.read<SatinAlimCubit>().selectedUretici,
                onMenuStateChange: () {
                  context.read<SatinAlimCubit>().ureticiAdiController.clear();
                },
              );
      },
    );
  }

  Widget buildDriverDropDown(BuildContext context) {
    return BlocBuilder<SatinAlimCubit, SatinAlimState>(
      builder: (context, state) {
        return DropDown2DriverSearch(
          controller:
              context.read<SatinAlimCubit>().driverAdiControllerForDropDown,
          onChanged: (value) {
            context.read<SatinAlimCubit>().selectedDriver = value;
            context.read<SatinAlimCubit>().driverSelected();
          },
          selectedValue: context.read<SatinAlimCubit>().selectedDriver,
          onMenuStateChange: () {
            context
                .read<SatinAlimCubit>()
                .driverAdiControllerForDropDown
                .clear();
          },
        );
      },
    );
  }

  TableRow buildTableHeader() {
    return const TableRow(children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        child: Center(child: Text("Adı")),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        child: Center(child: Text("Cinsi")),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        child: Center(child: Text("Miktarı")),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        child: Center(child: Text("Fiyatı")),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        child: Center(child: Text("Toplam")),
      ),
      Text("")
    ]);
  }

  BlocBuilder<SatinAlimCubit, SatinAlimState> buildIkinciKisiBilgilerField() {
    return BlocBuilder<SatinAlimCubit, SatinAlimState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: context.padding.low,
                  child: buildCityField2(context),
                )),
                Expanded(
                    child: Padding(
                  padding: context.padding.low,
                  child: buildIlceField2(context),
                )),
                Expanded(
                    child: Padding(
                  padding: context.padding.low,
                  child: buildBeldeField2(context),
                )),
              ],
            ),
          ],
        );
      },
    );
  }

  BlocBuilder buildMalinGidecegiYerDropDown(BuildContext context) {
    return BlocBuilder<SatinAlimCubit, SatinAlimState>(
      builder: (context, state) {
        List<GidecegiYer> gidecegiYerList = [];
        List<Sube> subeler =
            SubelerCacheManager.instance.getItem(ActiveTc.instance.activeTc);
        List<Depo> depolar =
            DepolarCacheManager.instance.getItem(ActiveTc.instance.activeTc);
        List<HalIciIsyeri> halIciIsyerleri = HalIciIsyeriCacheManager.instance
            .getItem(ActiveTc.instance.activeTc);
        if ((subeler.length + depolar.length + halIciIsyerleri.length) == 0) {
          return const Text(
            "Gidilecek yer bulunumadı lütfen ayarlardan kullanıcı bilgilerini güncelleyiniz",
            style: TextStyle(color: Colors.red),
          );
        } else if ((subeler.length + depolar.length + halIciIsyerleri.length) ==
            1) {
          for (var element in subeler) {
            context.read<SatinAlimCubit>().gidecegiYer = GidecegiYer(
                type: "Şube",
                name: element.adres.toString(),
                isletmeTuru: element.isletmeTuruAdi ?? "null",
                isletmeTuruId: element.isletmeTuruId ?? "null",
                isyeriId: element.subeId ?? "null",
                adres: element.adres.toString());
          }
          for (var element in depolar) {
            context.read<SatinAlimCubit>().gidecegiYer = GidecegiYer(
                type: "Depo",
                name: element.adres.toString(),
                isletmeTuru: element.isletmeTuruAdi ?? "null",
                isletmeTuruId: element.isletmeTuruId ?? "null",
                isyeriId: element.depoId ?? "null",
                adres: element.adres.toString());
          }
          for (var element in halIciIsyerleri) {
            context.read<SatinAlimCubit>().gidecegiYer = GidecegiYer(
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

        return DropdownButtonHideUnderline(
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
            value: context.read<SatinAlimCubit>().gidecegiYer,
            onChanged: (value) {
              context.read<SatinAlimCubit>().gidecegiYer =
                  (value as GidecegiYer);
              context.read<SatinAlimCubit>().gidecegiYerSelected();
            },
            // buttonHeight: 50,

            //This to clear the search value when you close the menu
          ),
        );
      },
    );
  }

  BlocBuilder buildMalinAdiField2(BuildContext context) {
    return BlocBuilder<SatinAlimCubit, SatinAlimState>(
      builder: (context, state) {
        return DropDown2StringSearch(
          controller: context.read<SatinAlimCubit>().malinAdiController,
          items: context.read<SatinAlimCubit>().getMallar.values.toList(),
          hint: 'Ürün Seç',
          onChanged: (value) {
            context.read<SatinAlimCubit>().malinAdiSelected(value);
          },
          selectedValue: context.read<SatinAlimCubit>().selectedMalinAdi,
          onMenuStateChange: () {
            context.read<SatinAlimCubit>().malinAdiController.clear();
          },
        );
      },
    );
  }

  BlocBuilder buildMalinCinsiField2(BuildContext context) {
    return BlocBuilder<SatinAlimCubit, SatinAlimState>(
      builder: (context, state) {
        return DropDown2StringSearch(
          items: context.read<SatinAlimCubit>().urunCinsiIsimleriList,
          hint: 'Cins Seç',
          onChanged: (value) {
            context.read<SatinAlimCubit>().malinCins = value;
            context.read<SatinAlimCubit>().malinCinsiSelected();
          },
          selectedValue: context.read<SatinAlimCubit>().malinCins,
          onMenuStateChange: () {
            context.read<SatinAlimCubit>().malinAdiController.clear();
          },
        );
      },
    );
  }

  BlocBuilder<SatinAlimCubit, SatinAlimState> buildToplamaMal() {
    return BlocBuilder<SatinAlimCubit, SatinAlimState>(
      builder: (context, state) {
        return Row(
          children: [
            Checkbox(
              activeColor: Colors.green,
              checkColor: Colors.white,
              value: context.read<SatinAlimCubit>().isToplamaHal,
              onChanged: (bool? value) {
                context.read<SatinAlimCubit>().toplamaMalSelected(value!);
              },
            ),
            const Text("Toplama mal")
          ],
        );
      },
    );
  }

  Widget buildUreticiAdiField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TypeAheadFormField(
        textFieldConfiguration: TextFieldConfiguration(
            controller: context.read<SatinAlimCubit>().ureticiAdiController,
            decoration: InputDecoration(
                labelText: 'Üretici Adı',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25)))),
        suggestionsCallback: (pattern) {
          var list = [];

          context.read<SatinAlimCubit>().ureticiList.forEach((element) {
            if ((element.ureticiAdiSoyadi)
                .toLowerCaseTr()
                .contains(pattern.toLowerCaseTr())) {
              list.add(element.ureticiAdiSoyadi);
            }
          });
          return list;
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion.toString()),
          );
        },
        getImmediateSuggestions: true,
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (suggestion) {
          context.read<SatinAlimCubit>().ureticiAdiController.text =
              suggestion.toString();
          context.read<SatinAlimCubit>().ureticiSelected();
        },
        validator: (value) {
          if ((value == null || value.isEmpty) &&
              !context.read<SatinAlimCubit>().isToplamaHal) {
            return 'Üretici seçiniz';
          }
          return null;
        },
        // onSaved: (value) => this._selectedCity = value,
      ),
    );
  }

  Widget buildIlField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TypeAheadFormField(
        keepSuggestionsOnLoading: true,

        textFieldConfiguration: TextFieldConfiguration(
            style: context.general.textTheme.bodyMedium,
            controller: context.read<SatinAlimCubit>().ilController,
            decoration: InputDecoration(
                labelText: 'İl',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25)))),
        suggestionsCallback: (pattern) {
          var list = [];

          context.read<SatinAlimCubit>().getCities.values.forEach((element) {
            if (element.contains(pattern.toUpperCaseTr())) {
              list.add(element);
            }
          });
          return list;
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(
              suggestion.toString(),
              style: context.general.textTheme.bodyMedium,
            ),
          );
        },
        getImmediateSuggestions: true,
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (suggestion) {
          context.read<SatinAlimCubit>().ilController.text =
              suggestion.toString();
          //  context.read<SatinAlimCubit>().ilSelected();
        },
        validator: (value) {
          if ((value == null || value.isEmpty) &&
              !context.read<SatinAlimCubit>().isToplamaHal) {
            return 'Şehir seçiniz';
          }
          return null;
        },
        // onSaved: (value) => this._selectedCity = value,
      ),
    );
  }

  BlocBuilder<SatinAlimCubit, SatinAlimState> buildIlceField() {
    return BlocBuilder<SatinAlimCubit, SatinAlimState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
                style: context.general.textTheme.bodyMedium,
                enabled: (context.read<SatinAlimCubit>().selectedIl == null)
                    ? false
                    : true,
                controller: context.read<SatinAlimCubit>().ilceController,
                decoration: InputDecoration(
                    labelText: 'İlçe',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)))),
            suggestionsCallback: (pattern) {
              var list = [];

              context
                  .read<SatinAlimCubit>()
                  .getIlceler
                  .values
                  .forEach((element) {
                if (element.contains(pattern.toUpperCaseTr())) {
                  list.add(element);
                }
              });
              return list;
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion.toString()),
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            onSuggestionSelected: (suggestion) {
              context.read<SatinAlimCubit>().ilceController.text =
                  suggestion.toString();
              //  context.read<SatinAlimCubit>().ilceSelected();
            },
            validator: (value) {
              if ((value == null || value.isEmpty) &&
                  !context.read<SatinAlimCubit>().isToplamaHal) {
                return 'İlçe seçiniz';
              }
              return null;
            },
            //   onSaved: (value) => _selectedCity = value,
          ),
        );
      },
    );
  }

  BlocBuilder<SatinAlimCubit, SatinAlimState> buildBeldeField() {
    return BlocBuilder<SatinAlimCubit, SatinAlimState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
                style: context.general.textTheme.bodyMedium,
                enabled: (context
                            .read<SatinAlimCubit>()
                            .ilceController
                            .text
                            .trim() ==
                        "")
                    ? false
                    : true,
                controller: context.read<SatinAlimCubit>().beldeController,
                decoration: InputDecoration(
                    labelText: 'Belde',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)))),
            suggestionsCallback: (pattern) {
              var list = [];

              context
                  .read<SatinAlimCubit>()
                  .getBeldeler
                  .values
                  .forEach((element) {
                if (element.contains(pattern.toUpperCaseTr())) {
                  list.add(element);
                }
              });
              return list;
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion.toString()),
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            onSuggestionSelected: (suggestion) {
              context.read<SatinAlimCubit>().beldeController.text =
                  suggestion.toString();
              context.read<SatinAlimCubit>().beldeSelected();
            },
            validator: (value) {
              if ((value == null || value.isEmpty) &&
                  !context.read<SatinAlimCubit>().isToplamaHal) {
                return 'Belge seçiniz';
              }
              return null;
            },
            // onSaved: (value) => _selectedCity = value,
          ),
        );
      },
    );
  }

  BlocBuilder<SatinAlimCubit, SatinAlimState> buildMalinAdiField() {
    return BlocBuilder<SatinAlimCubit, SatinAlimState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
                controller: context.read<SatinAlimCubit>().malinAdiController,
                decoration: InputDecoration(
                    labelText: 'Malın adı',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)))),
            suggestionsCallback: (pattern) {
              var list = [];
              context
                  .read<SatinAlimCubit>()
                  .getMallar
                  .values
                  .forEach((element) {
                if (element.contains(pattern.toUpperCaseTr())) {
                  list.add(element);
                }
              });
              return list;
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion.toString()),
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            onSuggestionSelected: (suggestion) {
              context.read<SatinAlimCubit>().malinAdiController.text =
                  suggestion.toString();
              //   context.read<SatinAlimCubit>().malinAdiSelected();
            },
            validator: (value) {
              if ((value == null || value.isEmpty) &&
                  !context.read<SatinAlimCubit>().isToplamaHal) {
                return 'Ürün seçiniz';
              }
              return null;
            },
            //onSaved: (value) => _selectedCity = value,
          ),
        );
      },
    );
  }

  BlocBuilder<SatinAlimCubit, SatinAlimState> buildBagAdetKgField(
      BuildContext context) {
    return BlocBuilder<SatinAlimCubit, SatinAlimState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            enabled: context.read<SatinAlimCubit>().selectedMalinAdi != null,
            autovalidateMode: context.read<SatinAlimCubit>().isAutoValidateMode,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Miktar giriniz';
              }
              value = value.replaceAll(",", ".");

              context.read<SatinAlimCubit>().isNumeric(value);
              if (!context.read<SatinAlimCubit>().isNumeric(value)) {
                return 'rakam ve . , kullanabilirsiniz';
              }
              if (double.parse(value) < 0 || double.parse(value) == 0) {
                return '0 dan büyük olmalı';
              }
              return null;
            },
            controller: context.read<SatinAlimCubit>().adetBagKgController,
            keyboardType: Platform.isAndroid
                ? TextInputType.number
                : TextInputType.datetime,
            decoration: InputDecoration(
                constraints:
                    BoxConstraints(maxHeight: context.sized.normalValue * 3),
                labelText:
                    context.read<SatinAlimCubit>().malMiktarBirimAdi == ""
                        ? "Miktarı"
                        : context.read<SatinAlimCubit>().malMiktarBirimAdi,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25))),
          ),
        );
      },
    );
  }

  BlocBuilder<SatinAlimCubit, SatinAlimState> buildBirimFiyatiColumn(
      BuildContext context) {
    return BlocBuilder<SatinAlimCubit, SatinAlimState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: context.read<SatinAlimCubit>().tlController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Miktar giriniz';
                  }
                  value = value.replaceAll(",", ".");

                  context.read<SatinAlimCubit>().isNumeric(value);
                  if (!context.read<SatinAlimCubit>().isNumeric(value)) {
                    return 'rakam ve . , kullanabilirsiniz';
                  }
                  if (double.parse(value) < 0 || double.parse(value) == 0) {
                    return '0 dan büyük olmalı';
                  }
                  return null;
                },
                keyboardType: Platform.isAndroid
                    ? TextInputType.number
                    : TextInputType.datetime,
                autovalidateMode:
                    context.read<SatinAlimCubit>().isAutoValidateMode,
                decoration: InputDecoration(
                    constraints: BoxConstraints(
                        maxHeight: context.sized.normalValue * 3),
                    labelText: "Birim Fiyatı",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
            )),
          ],
        );
      },
    );
  }
}
