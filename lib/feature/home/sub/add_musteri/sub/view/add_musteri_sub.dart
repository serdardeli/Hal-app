import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hal_app/core/utils/dropdown2_style/dropdown2_style.dart';
import 'package:hal_app/project/utils/component/dropdown2_string_search.dart';

import 'package:hal_app/project/utils/widgets/custom_dropdown2.dart';
import 'package:kartal/kartal.dart';
import 'package:turkish/turkish.dart';

import '../../../../../helper/scaffold_messager.dart';
import '../viewmodel/cubit/add_musteri_sub_cubit.dart';

class AddMusteriSub extends StatelessWidget {
  const AddMusteriSub({Key? key}) : super(key: key);
  static const name = "addMusteriPage";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() async {
        context.read<AddMusteriSubCubit>().clearAllInfos();
        return true;
      }),
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: buildFABdeleteButton(context),
          appBar: buildAppBar(context),
          body: SingleChildScrollView(
              child: BlocConsumer<AddMusteriSubCubit, AddMusteriSubState>(
            listener: blocListener,
            builder: (context, state) {
              var result = context.read<AddMusteriSubCubit>();

              return Padding(
                padding: context.padding.horizontalNormal,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: buildGidecegiIsyeriTc(context)),
                        Expanded(child: buildTcQueryButton(context)),
                      ],
                    ),
                    context.read<AddMusteriSubCubit>().customerStatus ==
                            CustomerStatus.idle
                        ? const SizedBox()
                        : context.read<AddMusteriSubCubit>().customerStatus ==
                                CustomerStatus.customerFound
                            ? buildCustomerFoundColumn(result, context)
                            : buildCustomerNotFoundColumn(result, context),
                  ],
                ),
              );
            },
          )),
        ),
      ),
    );
  }

  CupertinoNavigationBar buildAppBar(BuildContext context) {
    return CupertinoNavigationBar(
      middle: Text(context.read<AddMusteriSubCubit>().isUpdateState
          ? "Müşteri Güncelle"
          : "Müşteri Ekle"),
    );
  }

  Widget buildFABdeleteButton(BuildContext context) {
    return context.read<AddMusteriSubCubit>().isUpdateState
        ? FloatingActionButton.extended(
            backgroundColor: Colors.green,
            heroTag: "Müşteri sil",
            onPressed: () {
              context.read<AddMusteriSubCubit>().removeMusteri();
            },
            label: const Text("Müşteri Sil"))
        : const SizedBox();
  }

  Widget buildMalinGidecegiYerDropDown(BuildContext context) {
    return Padding(
      padding: context.padding.verticalLow,
      child: CustomDropdownButton2(
        dropdownHeight: context.general.mediaSize.height,
        buttonWidth: context.general.mediaSize.width * .7,
        dropdownWidth: context.general.mediaSize.width * .7,
        hint: 'Malların Gideceği Yeri Seçiniz',
        dropdownItems: context
            .read<AddMusteriSubCubit>()
            .malinGidecegiYerlerForNonRegisterUser
            .values
            .toList(),
        icon: const Icon(Icons.arrow_drop_down_sharp, size: 24),
        value: context
            .watch<AddMusteriSubCubit>()
            .selectedNotFoundMalinGidecegiYerAdi,
        onChanged: (value) {
          //context.read<AddMusteriSubCubit>().clearAllPageInfo();
          context
              .read<AddMusteriSubCubit>()
              .selectedNotFoundMalinGidecegiYerAdi = value!;
          context
              .read<AddMusteriSubCubit>()
              .notFoundCustomerMalinGidecegiYerSelected();
        },
      ),
    );
  }

  Widget buildSifatDropDown(BuildContext context) {
    return Padding(
      padding: context.padding.verticalLow,
      child: CustomDropdownButton2(
        dropdownHeight: context.general.mediaSize.height,
        buttonWidth: context.general.mediaSize.width * .7,
        dropdownWidth: context.general.mediaSize.width * .7,
        hint: 'Müşteri Sıfatını Seçiniz',
        dropdownItems: context
            .read<AddMusteriSubCubit>()
            .customerNotFoundSifatlar
            .values
            .toList(),
        icon: const Icon(Icons.arrow_drop_down_sharp, size: 24),
        value: context
            .watch<AddMusteriSubCubit>()
            .selectedNotFoundCustomerSifatName,
        onChanged: (value) {
          //context.read<AddMusteriSubCubit>().clearAllPageInfo();
          context.read<AddMusteriSubCubit>().selectedNotFoundCustomerSifatName =
              value!;
          context.read<AddMusteriSubCubit>().notFoundCustomerSifatSelected();
        },
      ),
    );
  }

  Column buildCustomerNotFoundColumn(
      AddMusteriSubCubit result, BuildContext context) {
    return Column(
      children: [
        buildTelAdFormFieldsForNotFoundUser(result, context),
        buildSifatDropDown(context),
        buildMalinGidecegiYerDropDown(context),
        BlocBuilder<AddMusteriSubCubit, AddMusteriSubState>(
          builder: (context, state) {
            return Row(
              children: [
                Expanded(
                    child: Padding(
                        padding: context.padding.low,
                        child: buildCityField2(context))),
                Expanded(
                    child: Padding(
                        padding: context.padding.low,
                        child: buildIlceField2(context))),
                Expanded(
                    child: Padding(
                        padding: context.padding.low,
                        child: buildBeldeField2(context))),
              ],
            );
          },
        ),
        buildMusteriEkleGuncelleButton(context, result),
      ],
    );
  }

  Widget buildCityField2(BuildContext context) {
    return DropDown2StringSearch(
      controller: context.read<AddMusteriSubCubit>().ilController,
      items: context.read<AddMusteriSubCubit>().getCities.values.toList(),
      hint: 'İl Seç',
      onChanged: (value) {
        context.read<AddMusteriSubCubit>().ilSelected(value);
      },
      selectedValue: context.read<AddMusteriSubCubit>().selectedIl,
      onMenuStateChange: () {
        context.read<AddMusteriSubCubit>().ilController.clear();
      },
    );
  }

  Widget buildIlceField2(BuildContext context) {
    return DropDown2StringSearch(
      controller: context.read<AddMusteriSubCubit>().ilceController,
      items: context.read<AddMusteriSubCubit>().getIlceler.values.toList(),
      hint: 'İlçe Seç',
      onChanged: (value) {
        context.read<AddMusteriSubCubit>().ilceSelected(value);
      },
      selectedValue: context.read<AddMusteriSubCubit>().selectedIlce,
      onMenuStateChange: () {
        context.read<AddMusteriSubCubit>().ilceController.clear();
      },
    );
  }

  Widget buildBeldeField2(BuildContext context) {
    return DropDown2StringSearch(
      controller: context.read<AddMusteriSubCubit>().beldeController,
      items: context.read<AddMusteriSubCubit>().getBeldeler.values.toList(),
      hint: 'Belde Seç',
      onChanged: (value) {
        context.read<AddMusteriSubCubit>().selectedBelde = value;
        context.read<AddMusteriSubCubit>().beldeSelected();
      },
      selectedValue: context.read<AddMusteriSubCubit>().selectedBelde,
      onMenuStateChange: () {
        context.read<AddMusteriSubCubit>().beldeController.clear();
      },
    );
  }

  Column buildCustomerFoundColumn(
      AddMusteriSubCubit result, BuildContext context) {
    return Column(
      children: [
        buildInfoFieldsAndColumnCustomerFound(result, context),
        buildSifatlarColumn(context, result),
        buildHalIciIsyerleriColumn(result, context),
        buildDepolarColumn(result, context),
        buildSubelerColumn(result, context),
      ],
    );
  }

  BlocBuilder buildSifatlarColumn(
      BuildContext context, AddMusteriSubCubit result) {
    return BlocBuilder<AddMusteriSubCubit, AddMusteriSubState>(
      builder: (context, state) {
        return Column(
          children: [
            Text("Bulunan Sıfatlar",
                style: context.general.textTheme.headlineSmall),
            ...result.sifatNameList
                .map(
                  (e) => Padding(
                    padding: context.padding.verticalLow,
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        //  height: context.general.mediaSize.height*.05,
                        child: ListTile(
                          // contentPadding: EdgeInsets.zero,
                          // minVerticalPadding: 0,
                          subtitle: Row(
                            children: [
                              Text("${result.sifatNameList.indexOf(e) + 1}  ",
                                  style: context.general.textTheme.titleLarge),
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text(
                                      "",
                                      style: TextStyle(fontSize: 0),
                                    ),
                                    Text(e),
                                    const Text("",
                                        style: TextStyle(fontSize: 0)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList()
          ],
        );
      },
    );
  }

  Widget buildInfoFieldsAndColumnCustomerFound(
      AddMusteriSubCubit result, BuildContext context) {
    return (result.subeler.isEmpty &&
            result.depolar.isEmpty &&
            result.halIciIsyerleriNew.isEmpty)
        ? const SizedBox()
        : Column(
            children: [
              //  buildUreticiTcField(context),
              //    buildSifatColumn(),

              buildTelAdFormFieldsForFoundUser(result, context),

              buildMusteriEkleGuncelleButton(context, result),
            ],
          );
  }

  Padding buildMusteriEkleGuncelleButton(
      BuildContext context, AddMusteriSubCubit result) {
    return Padding(
      padding: context.padding.verticalNormal,
      child: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        heroTag: "musteriEkleMain",
        onPressed: () async {
          FocusManager.instance.primaryFocus?.unfocus();

          result.activateAutoValidateMode();
          if (result.adSoyadformKey.currentState!.validate() &&
              result.formKey.currentState!.validate()) {
            result.disableAutoValidateMode();
            if (result.isUpdateState) {
              await result.musteriEkle();
            } else {
              await result.musteriEkle();
            }
          }
        },
        label: Text(result.isUpdateState ? "Müşteri Güncelle" : "Müşteri Ekle"),
      ),
    );
  }

  Form buildTelAdFormFieldsForFoundUser(
      AddMusteriSubCubit result, BuildContext context) {
    return Form(
        key: result.adSoyadformKey,
        child: Column(
          children: [
            buildMusteriIsimField(context),
            // buildMusteriTelField(context),
          ],
        ));
  }

  Form buildTelAdFormFieldsForNotFoundUser(
      AddMusteriSubCubit result, BuildContext context) {
    return Form(
        key: result.adSoyadformKey,
        child: Column(
          children: [
            buildMusteriIsimField(context),
            buildMusteriTelField(context),
          ],
        ));
  }

  void blocListener(context, state) {
    if (state is AddMusteriSubLoading) {
      EasyLoading.instance
        ..indicatorType = EasyLoadingIndicatorType.pouringHourGlass
        ..loadingStyle = EasyLoadingStyle.light
        ..userInteractions = false;
      EasyLoading.show(status: 'HKS Bekleniyor...');
    } else {
      EasyLoading.dismiss();
    }

    if (state is AddMusteriSubError) {
      ScaffoldMessengerHelper.instance
          .showErrorSnackBar(context, state.message);
    }
    if (state is AddMusteriSubUserInfoFound) {}
    if (state is AddMusteriSubSuccessful) {
      ScaffoldMessengerHelper.instance
          .showSuccessfulSnackBar(context, "Ekleme Başarılı");
      Navigator.pop(context);
    }
    if (state is AddMusteriSubDeleted) {
      ScaffoldMessengerHelper.instance
          .showSuccessfulSnackBar(context, "Silme Başarılı");
      Navigator.pop(context);
    }
  }

  Widget buildDepolarColumn(AddMusteriSubCubit result, BuildContext context) {
    return result.depolar.isEmpty
        ? const SizedBox()
        : Column(
            children: [
              Text(
                "Depolar",
                style: context.general.textTheme.headlineSmall,
              ),
              ...(result.depolar.map(
                (e) => Padding(
                  padding: context.padding.verticalLow,
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      //  height: context.general.mediaSize.height*.05,
                      child: ListTile(
                        // contentPadding: EdgeInsets.zero,
                        // minVerticalPadding: 0,
                        subtitle: Row(
                          children: [
                            Text("${result.depolar.indexOf(e) + 1}  ",
                                style: context.general.textTheme.titleLarge),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    "",
                                    style: TextStyle(fontSize: 0),
                                  ),
                                  Text(e.adres?.trim() ?? "Adres Boş"),
                                  const Text("", style: TextStyle(fontSize: 0)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )).toList()
            ],
          );
  }

  Widget buildSubelerColumn(AddMusteriSubCubit result, BuildContext context) {
    return result.subeler.isEmpty
        ? const SizedBox()
        : Column(
            children: [
              Text(
                "Şubeler",
                style: context.general.textTheme.headlineSmall,
              ),
              ...(result.subeler.map(
                (e) => Padding(
                  padding: context.padding.verticalLow,
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      //  height: context.general.mediaSize.height*.05,
                      child: ListTile(
                        // contentPadding: EdgeInsets.zero,
                        // minVerticalPadding: 0,
                        subtitle: Row(
                          children: [
                            Text("${result.subeler.indexOf(e) + 1}  ",
                                style: context.general.textTheme.titleLarge),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "",
                                    style: TextStyle(fontSize: 0),
                                  ),
                                  Text(e.adres?.trim() ?? "Adres Boş"),
                                  Text(
                                    e.isletmeTuruAdi?.trim() ?? "Adres Boş",
                                    style: TextStyle(
                                        color: e.isletmeTuruAdi ==
                                                "Dağıtım Merkezi"
                                            ? Colors.red
                                            : Colors.black),
                                  ),
                                  const Text("", style: TextStyle(fontSize: 0)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )).toList()
            ],
          );
  }

  Widget buildHalIciIsyerleriColumn(
      AddMusteriSubCubit result, BuildContext context) {
    return result.halIciIsyerleriNew.isEmpty
        ? const SizedBox()
        : Column(
            children: [
              Text("Hal İçi İşyerleri",
                  style: context.general.textTheme.headlineSmall),
              ...(result.halIciIsyerleriNew.map(
                (e) => Padding(
                  padding: context.padding.verticalLow,
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      //  height: context.general.mediaSize.height*.05,
                      child: ListTile(
                        // contentPadding: EdgeInsets.zero,
                        // minVerticalPadding: 0,
                        subtitle: Row(
                          children: [
                            Text(
                                "${result.halIciIsyerleriNew.indexOf(e) + 1}  ",
                                style: context.general.textTheme.titleLarge),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    "",
                                    style: TextStyle(fontSize: 0),
                                  ),
                                  Text(e.isyeriAdi?.trim() ?? "Adres Boş"),
                                  const Text("", style: TextStyle(fontSize: 0)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )).toList()
            ],
          );
  }

  Padding buildMusteriIsimField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        enabled: !context.read<AddMusteriSubCubit>().isUpdateState,
        controller: context.read<AddMusteriSubCubit>().nameController,
        autovalidateMode: context.read<AddMusteriSubCubit>().isAutoValidateMode,
        validator: (value) {
          if (value != null && value != "") {
            value = value.trim();

            if (value.length < 4) {
              return "İsim en az 4 karakter olmalıdır";
            }
          } else {
            return "İsim boş olamaz";
          }
          return null;
        },
        decoration: InputDecoration(
            labelText: "Müşteri Adı Soyadı",
            constraints:
                BoxConstraints(maxHeight: context.sized.normalValue * 3),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }

  Padding buildMusteriTelField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: context.read<AddMusteriSubCubit>().phoneController,
        autovalidateMode: context.read<AddMusteriSubCubit>().isAutoValidateMode,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value != null && value != "") {
            value = value.trim();
            if (!context.read<AddMusteriSubCubit>().isNumeric(value)) {
              return "Tc sadece numara içerebilir";
            }
            if (value.length <= 6) {
              return "Telfon en az 6 karakter olmalıdır";
            }
          } else {
            return "Telefon boş olamaz";
          }

          return null;
        },
        decoration: InputDecoration(
            labelText: "Tel",
            constraints:
                BoxConstraints(maxHeight: context.sized.normalValue * 3),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }

  Padding buildGidecegiIsyeriTc(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: context.read<AddMusteriSubCubit>().formKey,
        child: TextFormField(
          autovalidateMode:
              context.read<AddMusteriSubCubit>().isAutoValidateMode,
          validator: ((value) {
            if (value == null || value.isEmpty) {
              return 'lütfen Tc giriniz';
            }
            if (!context.read<AddMusteriSubCubit>().isNumeric(value)) {
              return "Tc sadece numara içerebilir";
            }
            if (value.length <= 9) {
              return "Tc 9 karaterden küçük olamaz";
            }
            return null;
          }),
          controller: context.read<AddMusteriSubCubit>().tcController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
              constraints:
                  BoxConstraints(maxHeight: context.sized.normalValue * 3),
              labelText: "Kayıtlı İşyeri Tc",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
        ),
      ),
    );
  }

  Padding buildTcQueryButton(BuildContext context) => Padding(
        padding: context.padding.horizontalLow,
        child: FloatingActionButton.extended(
          backgroundColor: Colors.green,
          heroTag: "TC QUERY",
          onPressed: () async {
            FocusManager.instance.primaryFocus?.unfocus();

            context.read<AddMusteriSubCubit>().activateAutoValidateMode();
            if (context
                .read<AddMusteriSubCubit>()
                .formKey
                .currentState!
                .validate()) {
              context.read<AddMusteriSubCubit>().disableAutoValidateMode();
              await context
                  .read<AddMusteriSubCubit>()
                  .gidecegiIsyeriSifatSorgula();
            }
          },
          label: const Text("Tc yi sorgula"),
        ),
      );
  void showAreYouSureDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("Bilgiler"),
            actions: [
              CupertinoDialogAction(
                child: const Text("Hayır"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: const Text("Evet"),
                onPressed: () {
                  // context.read<UpdateUserInformationsCubit>().updateInfos();
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}

Map<String, String> sifatlar = {
  "9": "Depo/Tasnif ve Ambalaj",
  "24": "E-Market",
  "19": "Hastane",
  "2": "İhracat",
  "23": "İmalatçı",
  "3": "İthalat",
  "13": "Lokanta",
  "8": "Manav",
  "7": "Market",
  "12": "Otel",
  "11": "Pazarcı",
  "1": "Sanayici",
  "5": "Komisyoncu",
  "20": "Tüccar (Hal Dışı)",
  "6": "Tüccar (Hal İçi)",
  "4": "Üretici",
  "10": "Üretici Örgütü",
  "15": "Yemek Fabrikası",
  "14": "Yurt",
};
