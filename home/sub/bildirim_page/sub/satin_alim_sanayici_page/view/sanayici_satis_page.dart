// dropdown done

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hal_app/core/utils/dropdown2_style/dropdown2_style.dart';
import 'package:hal_app/project/utils/component/dropdown2_driver_search.dart';
import 'package:hal_app/project/utils/component/dropdown2_string_search.dart';
import 'package:hal_app/project/utils/component/dropdown2_uretici_search.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kartal/kartal.dart';
import 'package:turkish/turkish.dart';

import '../../../../../../../project/cache/depo_cache_manager.dart';
import '../../../../../../../project/cache/driver_list_cache_manager.dart';
import '../../../../../../../project/cache/hal_ici_isyeri_cache_manager.dart';
import '../../../../../../../project/cache/mysoft_user_cache_mananger.dart';
import '../../../../../../../project/cache/sube_cache_manager.dart';
import '../../../../../../../project/cache/uretici_list_cache_manager.dart';
import '../../../../../../../project/model/MySoft_user_model/mysoft_user_model.dart';
import '../../../../../../../project/model/bildirim_kayit_response_model.dart/sub/bildirim_kayit_cevap_model.dart';
import '../../../../../../../project/model/depo/depo_model.dart';
import '../../../../../../../project/model/driver_model/driver_model.dart';
import '../../../../../../../project/model/hal_ici_isyeri/hal_ici_isyeri_model.dart';
import '../../../../../../../project/model/malin_gidecegi_yer/malin_gidecegi_yer_model.dart';
import '../../../../../../../project/model/sube/sube_model.dart';
import '../../../../../../../project/model/uretici_model/uretici_model.dart';
import '../../../../../../helper/active_tc.dart';
import '../../../../../../helper/scaffold_messager.dart';
import '../viewmodel/cubit/sanayici_satin_alim_cubit.dart';

class SanayiciSatinAlimPage extends StatelessWidget {
  const SanayiciSatinAlimPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return BlocConsumer<SanayiciSatinAlimCubit, SanayiciSatinAlimState>(
      listener: buildBlocListener,
      builder: (BuildContext context, SanayiciSatinAlimState state) {
        return Padding(
          padding: context.padding.horizontalLow,
          child: Form(
            key: context.read<SanayiciSatinAlimCubit>().formKey,
            child: ListView(
              shrinkWrap: true,
              controller:
                  context.read<SanayiciSatinAlimCubit>().scrollController,
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

                BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState>(
                  builder: (context, state) {
                    return context
                                .read<SanayiciSatinAlimCubit>()
                                .dropDownErrorMessage ==
                            ""
                        ? const SizedBox()
                        : Padding(
                            padding: context.padding.verticalLow,
                            child: Text(
                              context
                                  .read<SanayiciSatinAlimCubit>()
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
            context.read<SanayiciSatinAlimCubit>().activateAutoValidateMode();
            var result = context
                .read<SanayiciSatinAlimCubit>()
                .checkDropDownFieldHasError();
            if (context
                    .read<SanayiciSatinAlimCubit>()
                    .formKey
                    .currentState!
                    .validate() &&
                !result) {
              context.read<SanayiciSatinAlimCubit>().disableAutoValidateMode();

              context.read<SanayiciSatinAlimCubit>().urunEkle();
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
        context.read<SanayiciSatinAlimCubit>().getMallar.forEach((key, value) {
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

  void buildBlocListener(BuildContext context, SanayiciSatinAlimState state) {
    // TODO: implement listener
    if (state is SanayiciSatinAlimLoading) {
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

    if (state is SanayiciSatinAlimError) {
      ScaffoldMessengerHelper.instance
          .showErrorSnackBar(context, state.message);
    }
    if (state is SanayiciSatinAlimSuccessHasSomeError) {
      if (state.response.kayitCevapList == null) {}
      List<Widget> basarili =
          buildSuccessfulTexts(state.response.kayitCevapList!, context);

      AwesomeDialog(
          btnCancelText: "Kapat",
          btnOkText: "Whatsapp ile paylaş",
          btnCancelOnPress: () {
            //    Navigator.pop(context); //Named e dönüp düzeteceğim
            context.read<SanayiciSatinAlimCubit>().clearFaturaInfo();
          },
          btnOkOnPress: () async {
            //  Navigator.pop(context);
            context.read<SanayiciSatinAlimCubit>().clearFaturaInfo();

            await context
                .read<SanayiciSatinAlimCubit>()
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
                          context
                                  .read<SanayiciSatinAlimCubit>()
                                  .isMustahsilKesSuccess
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
                          context
                                  .read<SanayiciSatinAlimCubit>()
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
    if (state is SanayiciSatinAlimCompletelySuccess) {
      AwesomeDialog(
          btnCancelText: "Kapat",
          btnOkText: "Whatsapp ile paylaş",
          btnCancelOnPress: () {
            //    Navigator.pop(context); //Named e dönüp düzeteceğim
            context.read<SanayiciSatinAlimCubit>().clearFaturaInfo();
          },
          btnOkOnPress: () async {
            //  Navigator.pop(context);
            context.read<SanayiciSatinAlimCubit>().clearFaturaInfo();

            await context
                .read<SanayiciSatinAlimCubit>()
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
                          context
                                  .read<SanayiciSatinAlimCubit>()
                                  .isMustahsilKesSuccess
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
                          context
                                  .read<SanayiciSatinAlimCubit>()
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

  BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState> buildTable2(
      BuildContext context) {
    return BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState>(
      builder: (context, state) {
        return context
                .watch<SanayiciSatinAlimCubit>()
                .urunList
                .ext
                .isNullOrEmpty
            ? Container()
            : Column(
                children: [
                  SizedBox(
                    height: 50 +
                        (context
                                .read<SanayiciSatinAlimCubit>()
                                .urunList
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
                          ...(context
                              .read<SanayiciSatinAlimCubit>()
                              .urunList
                              .map(
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
                                            .read<SanayiciSatinAlimCubit>()
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
                                            .read<SanayiciSatinAlimCubit>()
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
                                      .read<SanayiciSatinAlimCubit>()
                                      .removeFromUrunList(e);
                                })
                              ]);
                            },
                          ).toList()),
                        ]),
                  ),
                  buildAracPlakaField(context),
                  buildFaturaColumn(context),
                  !context.read<SanayiciSatinAlimCubit>().isIrsaliye
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
                                            .read<SanayiciSatinAlimCubit>()
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
    return !context.read<SanayiciSatinAlimCubit>().isSurucuManual
        ? const SizedBox()
        : Form(
            key: context.read<SanayiciSatinAlimCubit>().driverFormKey,
            child: Column(
              children: [
                Padding(
                  padding: context.padding.normal,
                  child: TextFormField(
                    controller: context
                        .read<SanayiciSatinAlimCubit>()
                        .driverIdController,
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return 'lütfen Tc giriniz';
                      }
                      if (!context
                          .read<SanayiciSatinAlimCubit>()
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
                        .read<SanayiciSatinAlimCubit>()
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
                        .read<SanayiciSatinAlimCubit>()
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
                        .read<SanayiciSatinAlimCubit>()
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
        value: context.read<SanayiciSatinAlimCubit>().isSurucuManual,
        onChanged: (value) {
          context.read<SanayiciSatinAlimCubit>().isSurucuManual = value!;
          context.read<SanayiciSatinAlimCubit>().emitInitial();
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
            return BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState>(
              builder: (context, state) {
                return Row(
                  children: [
                    Expanded(
                        child:
                            context.read<SanayiciSatinAlimCubit>().isToplamaHal
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
      value: context.read<SanayiciSatinAlimCubit>().isMustahsil,
      onChanged: (value) {
        context.read<SanayiciSatinAlimCubit>().isMustahsil = value!;
        context.read<SanayiciSatinAlimCubit>().emitInitial();
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
      value: context.read<SanayiciSatinAlimCubit>().isIrsaliye,
      onChanged: (value) {
        context.read<SanayiciSatinAlimCubit>().isIrsaliye = value!;
        context.read<SanayiciSatinAlimCubit>().emitInitial();
      },
      title: const Text(
        "İrsaliye Kes",
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildTableView2(BuildContext context) {
    return BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState>(
      builder: (context, state) {
        return context
                .watch<SanayiciSatinAlimCubit>()
                .urunList
                .ext
                .isNullOrEmpty
            ? Container()
            : SizedBox(
                height: 50 +
                    (context.read<SanayiciSatinAlimCubit>().urunList.length *
                        50) +
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
                          ...(context
                              .read<SanayiciSatinAlimCubit>()
                              .urunList
                              .map(
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
                                          .read<SanayiciSatinAlimCubit>()
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
                                      .read<SanayiciSatinAlimCubit>()
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
                                              .read<SanayiciSatinAlimCubit>()
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

  BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState>
      get buildTableColumn =>
          BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState>(
            builder: (context, state) {
              return context
                      .read<SanayiciSatinAlimCubit>()
                      .urunList
                      .ext
                      .isNullOrEmpty
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
            context
                .read<SanayiciSatinAlimCubit>()
                .activateAutoValidateModeForPlaka();
            if (context.read<SanayiciSatinAlimCubit>().isIrsaliye) {
              if (context.read<SanayiciSatinAlimCubit>().isSurucuManual) {
                context
                    .read<SanayiciSatinAlimCubit>()
                    .activateAutoValidateModeForDriver();
                if (context
                    .read<SanayiciSatinAlimCubit>()
                    .driverFormKey
                    .currentState!
                    .validate()) {
                  context.read<SanayiciSatinAlimCubit>().selectedDriver =
                      DriverModel(
                          tc: context
                              .read<SanayiciSatinAlimCubit>()
                              .driverIdController
                              .text
                              .trim(),
                          userName: context
                              .read<SanayiciSatinAlimCubit>()
                              .driverNameController
                              .text
                              .trim()
                              .toUpperCaseTr());
                  if (context
                          .read<SanayiciSatinAlimCubit>()
                          .plakaFormKey
                          .currentState !=
                      null) {
                    if (context
                        .read<SanayiciSatinAlimCubit>()
                        .plakaFormKey
                        .currentState!
                        .validate()) {
                      context
                          .read<SanayiciSatinAlimCubit>()
                          .disableAutoValidateModeForPlaka();
                      await context
                          .read<SanayiciSatinAlimCubit>()
                          .bildirimYap(context);
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                  }
                }
              } else {
                if (context.read<SanayiciSatinAlimCubit>().selectedDriver ==
                    null) {
                  context.read<SanayiciSatinAlimCubit>().emitError(
                      "Sürücü Seçiniz ve ya manuel olarak ekleyiniz");
                } else {
                  if (context
                          .read<SanayiciSatinAlimCubit>()
                          .plakaFormKey
                          .currentState !=
                      null) {
                    if (context
                        .read<SanayiciSatinAlimCubit>()
                        .plakaFormKey
                        .currentState!
                        .validate()) {
                      context
                          .read<SanayiciSatinAlimCubit>()
                          .disableAutoValidateModeForPlaka();
                      await context
                          .read<SanayiciSatinAlimCubit>()
                          .bildirimYap(context);
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                  }
                }
                //check selected driver
              }
            } else {
              if (context
                      .read<SanayiciSatinAlimCubit>()
                      .plakaFormKey
                      .currentState !=
                  null) {
                if (context
                    .read<SanayiciSatinAlimCubit>()
                    .plakaFormKey
                    .currentState!
                    .validate()) {
                  context
                      .read<SanayiciSatinAlimCubit>()
                      .disableAutoValidateModeForPlaka();
                  await context
                      .read<SanayiciSatinAlimCubit>()
                      .bildirimYap(context);
                }
              } else {}
            }
          },
          label: const Text("Bildirim Yap")),
    );
  }

  Padding buildAracPlakaField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState>(
        builder: (context, state) {
          return Form(
            key: context.read<SanayiciSatinAlimCubit>().plakaFormKey,
            child: TextFormField(
              autovalidateMode: context
                  .read<SanayiciSatinAlimCubit>()
                  .isAutoValidateModeForPlaka,
              validator: ((value) {
                if (value == null || value.isEmpty) {
                  return 'lütfen plaka bilgisi giriniz';
                }
                return null;
              }),
              controller:
                  context.read<SanayiciSatinAlimCubit>().plakaController,
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
        .read<SanayiciSatinAlimCubit>()
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
                  context.read<SanayiciSatinAlimCubit>().removeFromUrunList(e);
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
      controller: context.read<SanayiciSatinAlimCubit>().ilController,
      items: context.read<SanayiciSatinAlimCubit>().getCities.values.toList(),
      hint: 'İl Seç',
      onChanged: (value) {
        if (context.read<SanayiciSatinAlimCubit>().urunList.isNotEmpty) {
          ScaffoldMessengerHelper.instance.showErrorSnackBar(
              context, "Tabloda ürün varken üretici bilgileri değiştirilemez");
        } else {
          context.read<SanayiciSatinAlimCubit>().ilSelected(value);
        }
      },
      selectedValue: context.read<SanayiciSatinAlimCubit>().selectedIl,
      onMenuStateChange: () {
        context.read<SanayiciSatinAlimCubit>().ilController.clear();
      },
    );
  }

  Widget buildIlceField2(BuildContext context) {
    return DropDown2StringSearch(
      controller: context.read<SanayiciSatinAlimCubit>().ilceController,
      items: context.read<SanayiciSatinAlimCubit>().getIlceler.values.toList(),
      hint: 'İlçe Seç',
      onChanged: (value) {
        if (context.read<SanayiciSatinAlimCubit>().urunList.isNotEmpty) {
          ScaffoldMessengerHelper.instance.showErrorSnackBar(
              context, "Tabloda ürün varken üretici bilgileri değiştirilemez");
        } else {
          context.read<SanayiciSatinAlimCubit>().ilceSelected(value);
        }
      },
      selectedValue: context.read<SanayiciSatinAlimCubit>().selectedIlce,
      onMenuStateChange: () {
        context.read<SanayiciSatinAlimCubit>().ilceController.clear();
      },
    );
  }

  Widget buildBeldeField2(BuildContext context) {
    return DropDown2StringSearch(
      controller: context.read<SanayiciSatinAlimCubit>().beldeController,
      items: context.read<SanayiciSatinAlimCubit>().getBeldeler.values.toList(),
      hint: 'Belde Seç',
      onChanged: (value) {
        if (context.read<SanayiciSatinAlimCubit>().urunList.isNotEmpty) {
          ScaffoldMessengerHelper.instance.showErrorSnackBar(
              context, "Tabloda ürün varken üretici bilgileri değiştirilemez");
        } else {
          context.read<SanayiciSatinAlimCubit>().selectedBelde = value;
          context.read<SanayiciSatinAlimCubit>().beldeSelected();
        }
      },
      selectedValue: context.read<SanayiciSatinAlimCubit>().selectedBelde,
      onMenuStateChange: () {
        context.read<SanayiciSatinAlimCubit>().beldeController.clear();
      },
    );
  }

  Widget buildUreticiAdiField2(BuildContext context) {
    return BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState>(
      builder: (context, state) {
        return context.read<SanayiciSatinAlimCubit>().isToplamaHal
            ? const SizedBox()
            : DropDown2UreticiSearch(
                controller:
                    context.read<SanayiciSatinAlimCubit>().ureticiAdiController,
                onChanged: (value) {
                  if (context
                      .read<SanayiciSatinAlimCubit>()
                      .urunList
                      .isNotEmpty) {
                    ScaffoldMessengerHelper.instance.showErrorSnackBar(context,
                        "Tabloda ürün varken üretici bilgileri değiştirilemez");
                  } else {
                    context.read<SanayiciSatinAlimCubit>().selectedUretici =
                        value;
                    context.read<SanayiciSatinAlimCubit>().ureticiSelected();
                  }
                },
                selectedValue:
                    context.read<SanayiciSatinAlimCubit>().selectedUretici,
                onMenuStateChange: () {
                  context
                      .read<SanayiciSatinAlimCubit>()
                      .ureticiAdiController
                      .clear();
                },
              );
      },
    );
  }

  Widget buildDriverDropDown(BuildContext context) {
    return BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState>(
      builder: (context, state) {
        return DropDown2DriverSearch(
          controller: context
              .read<SanayiciSatinAlimCubit>()
              .driverAdiControllerForDropDown,
          onChanged: (value) {
            context.read<SanayiciSatinAlimCubit>().selectedDriver = value;
            context.read<SanayiciSatinAlimCubit>().driverSelected();
          },
          selectedValue: context.read<SanayiciSatinAlimCubit>().selectedDriver,
          onMenuStateChange: () {
            context
                .read<SanayiciSatinAlimCubit>()
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

  BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState>
      buildIkinciKisiBilgilerField() {
    return BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState>(
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

                //Expanded(child: buildIlField(context)),
                //  Expanded(child: buildIlceField()),
                //  Expanded(child: buildBeldeField()),
              ],
            ),
          ],
        );
      },
    );
  }

  BlocBuilder buildMalinGidecegiYerDropDown(BuildContext context) {
    return BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState>(
      builder: (context, state) {
        List<String> nameList = [];
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
            context.read<SanayiciSatinAlimCubit>().gidecegiYer = GidecegiYer(
                type: "Şube",
                name: element.adres.toString(),
                isletmeTuru: element.isletmeTuruAdi ?? "null",
                isletmeTuruId: element.isletmeTuruId ?? "null",
                isyeriId: element.subeId ?? "null",
                adres: element.adres.toString());
          }
          for (var element in depolar) {
            context.read<SanayiciSatinAlimCubit>().gidecegiYer = GidecegiYer(
                type: "Depo",
                name: element.adres.toString(),
                isletmeTuru: element.isletmeTuruAdi ?? "null",
                isletmeTuruId: element.isletmeTuruId ?? "null",
                isyeriId: element.depoId ?? "null",
                adres: element.adres.toString());
          }
          for (var element in halIciIsyerleri) {
            context.read<SanayiciSatinAlimCubit>().gidecegiYer = GidecegiYer(
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
            value: context.read<SanayiciSatinAlimCubit>().gidecegiYer,
            onChanged: (value) {
              context.read<SanayiciSatinAlimCubit>().gidecegiYer =
                  (value as GidecegiYer);
              context.read<SanayiciSatinAlimCubit>().gidecegiYerSelected();
            },
          ),
        );
      },
    );
  }

  BlocBuilder buildMalinAdiField2(BuildContext context) {
    return BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState>(
      builder: (context, state) {
        return DropDown2StringSearch(
          controller: context.read<SanayiciSatinAlimCubit>().malinAdiController,
          items: context.read<SanayiciSatinAlimCubit>().getMallar.values.toList(),
          hint: 'Ürün Seç',
          onChanged: (value) {
            context.read<SanayiciSatinAlimCubit>().malinAdiSelected(value);
          },
          selectedValue: context.read<SanayiciSatinAlimCubit>().selectedMalinAdi,
          onMenuStateChange: () {
            context.read<SanayiciSatinAlimCubit>().malinAdiController.clear();
          },
        );
      },
    );
  }

  BlocBuilder buildMalinCinsiField2(BuildContext context) {
    return BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState>(
      builder: (context, state) {
        return DropDown2StringSearch(
          items: context.read<SanayiciSatinAlimCubit>().urunCinsiIsimleriList,
          hint: 'Cins Seç',
          onChanged: (value) {
            context.read<SanayiciSatinAlimCubit>().malinCins = value;
            context.read<SanayiciSatinAlimCubit>().malinCinsiSelected();
          },
          selectedValue: context.read<SanayiciSatinAlimCubit>().malinCins,
          onMenuStateChange: () {
            context.read<SanayiciSatinAlimCubit>().malinAdiController.clear();
          },
        );
      },
    );
  }

  BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState>
      buildToplamaMal() {
    return BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState>(
      builder: (context, state) {
        return Row(
          children: [
            Checkbox(
              activeColor: Colors.green,
              checkColor: Colors.white,
              value: context.read<SanayiciSatinAlimCubit>().isToplamaHal,
              onChanged: (bool? value) {
                context
                    .read<SanayiciSatinAlimCubit>()
                    .toplamaMalSelected(value!);
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
            controller:
                context.read<SanayiciSatinAlimCubit>().ureticiAdiController,
            decoration: InputDecoration(
                labelText: 'Üretici Adı',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25)))),
        suggestionsCallback: (pattern) {
          var list = [];

          context.read<SanayiciSatinAlimCubit>().ureticiList.forEach((element) {
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
          context.read<SanayiciSatinAlimCubit>().ureticiAdiController.text =
              suggestion.toString();
          context.read<SanayiciSatinAlimCubit>().ureticiSelected();
        },
        validator: (value) {
          if ((value == null || value.isEmpty) &&
              !context.read<SanayiciSatinAlimCubit>().isToplamaHal) {
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
            controller: context.read<SanayiciSatinAlimCubit>().ilController,
            decoration: InputDecoration(
                labelText: 'İl',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25)))),
        suggestionsCallback: (pattern) {
          var list = [];

          context
              .read<SanayiciSatinAlimCubit>()
              .getCities
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
          context.read<SanayiciSatinAlimCubit>().ilController.text =
              suggestion.toString();
          //  context.read<SanayiciSatinAlimCubit>().ilSelected();
        },
        validator: (value) {
          if ((value == null || value.isEmpty) &&
              !context.read<SanayiciSatinAlimCubit>().isToplamaHal) {
            return 'Şehir seçiniz';
          }
          return null;
        },
        // onSaved: (value) => this._selectedCity = value,
      ),
    );
  }

  BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState> buildIlceField() {
    return BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
                style: context.general.textTheme.bodyMedium,
                enabled:
                    (context.read<SanayiciSatinAlimCubit>().selectedIl == null)
                        ? false
                        : true,
                controller:
                    context.read<SanayiciSatinAlimCubit>().ilceController,
                decoration: InputDecoration(
                    labelText: 'İlçe',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)))),
            suggestionsCallback: (pattern) {
              var list = [];

              context
                  .read<SanayiciSatinAlimCubit>()
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
              context.read<SanayiciSatinAlimCubit>().ilceController.text =
                  suggestion.toString();
              //  context.read<SanayiciSatinAlimCubit>().ilceSelected();
            },
            validator: (value) {
              if ((value == null || value.isEmpty) &&
                  !context.read<SanayiciSatinAlimCubit>().isToplamaHal) {
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

  BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState>
      buildBeldeField() {
    return BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
                style: context.general.textTheme.bodyMedium,
                enabled: (context
                            .read<SanayiciSatinAlimCubit>()
                            .ilceController
                            .text
                            .trim() ==
                        "")
                    ? false
                    : true,
                controller:
                    context.read<SanayiciSatinAlimCubit>().beldeController,
                decoration: InputDecoration(
                    labelText: 'Belde',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)))),
            suggestionsCallback: (pattern) {
              var list = [];

              context
                  .read<SanayiciSatinAlimCubit>()
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
              context.read<SanayiciSatinAlimCubit>().beldeController.text =
                  suggestion.toString();
              context.read<SanayiciSatinAlimCubit>().beldeSelected();
            },
            validator: (value) {
              if ((value == null || value.isEmpty) &&
                  !context.read<SanayiciSatinAlimCubit>().isToplamaHal) {
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

  BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState>
      buildMalinAdiField() {
    return BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
                controller:
                    context.read<SanayiciSatinAlimCubit>().malinAdiController,
                decoration: InputDecoration(
                    labelText: 'Malın adı',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)))),
            suggestionsCallback: (pattern) {
              var list = [];
              context
                  .read<SanayiciSatinAlimCubit>()
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
              context.read<SanayiciSatinAlimCubit>().malinAdiController.text =
                  suggestion.toString();
              //   context.read<SanayiciSatinAlimCubit>().malinAdiSelected();
            },
            validator: (value) {
              if ((value == null || value.isEmpty) &&
                  !context.read<SanayiciSatinAlimCubit>().isToplamaHal) {
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

  BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState>
      buildBagAdetKgField(BuildContext context) {
    return BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            enabled:
                context.read<SanayiciSatinAlimCubit>().selectedMalinAdi != null,
            autovalidateMode:
                context.read<SanayiciSatinAlimCubit>().isAutoValidateMode,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Miktar giriniz';
              }
              value = value.replaceAll(",", ".");

              context.read<SanayiciSatinAlimCubit>().isNumeric(value);
              if (!context.read<SanayiciSatinAlimCubit>().isNumeric(value)) {
                return 'rakam ve . , kullanabilirsiniz';
              }
              if (double.parse(value) < 0 || double.parse(value) == 0) {
                return '0 dan büyük olmalı';
              }
              return null;
            },
            controller:
                context.read<SanayiciSatinAlimCubit>().adetBagKgController,
            keyboardType: Platform.isAndroid
                ? TextInputType.number
                : TextInputType.datetime,
            decoration: InputDecoration(
                constraints:
                    BoxConstraints(maxHeight: context.sized.normalValue * 3),
                labelText: context
                            .read<SanayiciSatinAlimCubit>()
                            .malMiktarBirimAdi ==
                        ""
                    ? "Miktarı"
                    : context.read<SanayiciSatinAlimCubit>().malMiktarBirimAdi,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25))),
          ),
        );
      },
    );
  }

  BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState>
      buildBirimFiyatiColumn(BuildContext context) {
    return BlocBuilder<SanayiciSatinAlimCubit, SanayiciSatinAlimState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: context.read<SanayiciSatinAlimCubit>().tlController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Miktar giriniz';
                  }
                  value = value.replaceAll(",", ".");

                  context.read<SanayiciSatinAlimCubit>().isNumeric(value);
                  if (!context
                      .read<SanayiciSatinAlimCubit>()
                      .isNumeric(value)) {
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
                    context.read<SanayiciSatinAlimCubit>().isAutoValidateMode,
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
