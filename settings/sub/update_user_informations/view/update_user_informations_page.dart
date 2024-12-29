import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/enum/preferences_keys_enum.dart';
import '../../../../../project/cache/app_cache_manager.dart';
import '../../../../../project/cache/user_cache_manager.dart';
import '../../../../helper/scaffold_messager.dart';
import '../viewmodel/cubit/update_user_informations_cubit.dart';
import '../../../../../project/cache/bildirimci_cache_manager.dart';
import '../../../../../project/service/firebase/firestore/firestore_service.dart';
import 'package:kartal/kartal.dart';
import 'package:loader_overlay/loader_overlay.dart';

class UpdateUserInformationPage extends StatelessWidget {
  static const String name = "updateUserInformationPage";
  const UpdateUserInformationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //context.read<UpdateUserInformationsCubit>().clearAllFields();
        return true;
      },
      child: Scaffold(
        appBar: const CupertinoNavigationBar(
          middle: Text("Bildirimci Bilgilerini Güncelle"),
        ),
        floatingActionButton: buildFABDeleteButton(context),
        body: BlocConsumer<UpdateUserInformationsCubit,
            UpdateUserInformationsState>(
          listener: buildBlocListener,
          builder: (context, state) {
            return SingleChildScrollView(
              child: Form(
                key: context.read<UpdateUserInformationsCubit>().formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: context.padding.normal,
                      child: buildKullaniciAdiField(context),
                    ),
                    Padding(
                      padding: context.padding.normal,
                      child: buildHksPasswordField(context),
                    ),
                    Padding(
                      padding: context.padding.normal,
                      child: buildWebServicePasswordField(context),
                    ),
                    Padding(
                      padding: context.padding.verticalNormal,
                      child: FloatingActionButton.extended(
                          backgroundColor: Colors.green,
                          heroTag: "bilgileriGüncelle",
                          onPressed: () {
                            context
                                .read<UpdateUserInformationsCubit>()
                                .activateAutoValidateMode;

                            if (context
                                .read<UpdateUserInformationsCubit>()
                                .formKey
                                .currentState!
                                .validate()) {
                              context
                                  .read<UpdateUserInformationsCubit>()
                                  .disableAutoValidateMode;
                              context
                                  .read<UpdateUserInformationsCubit>()
                                  .updateInfosRequestNew();
                            }
                          },
                          label: const Text("Bilgileri Güncelle")),
                    ),
                    Padding(
                      padding: context.padding.horizontalNormal,
                      child: Column(
                        children: [
                          buildSifatlarColumn(context,
                              context.read<UpdateUserInformationsCubit>()),
                          buildHalIciIsyerleriColumn(context),
                          buildDepolarColumn(context),
                          buildSubelerColumn(context)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  BlocBuilder buildSifatlarColumn(
      BuildContext context, UpdateUserInformationsCubit result) {
    return BlocBuilder<UpdateUserInformationsCubit,
        UpdateUserInformationsState>(
      builder: (context, state) {
        return result.sifatNameList.isEmpty
            ? const SizedBox()
            : Column(
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
                                    Text(
                                        "${result.sifatNameList.indexOf(e) + 1}  ",
                                        style: context
                                            .general.textTheme.titleLarge),
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

  Widget buildDepolarColumn(BuildContext context) {
    return context.read<UpdateUserInformationsCubit>().depolar.isEmpty
        ? const SizedBox()
        : Column(
            children: [
              Text(
                "Depolar",
                style: context.general.textTheme.headlineSmall,
              ),
              ...(context.read<UpdateUserInformationsCubit>().depolar.map(
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
                                    "${context
                                                    .read<
                                                        UpdateUserInformationsCubit>()
                                                    .depolar
                                                    .indexOf(e) +
                                                1}  ",
                                    style: context.general.textTheme.titleLarge),
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Text(
                                        "",
                                        style: TextStyle(fontSize: 0),
                                      ),
                                      Text(e.adres?.trim() ?? "Adres Boş"),
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
                  )).toList()
            ],
          );
  }

  Widget buildSubelerColumn(BuildContext context) {
    return context.read<UpdateUserInformationsCubit>().subeler.isEmpty
        ? const SizedBox()
        : Column(
            children: [
              Text(
                "Şubeler",
                style: context.general.textTheme.headlineSmall,
              ),
              ...(context.read<UpdateUserInformationsCubit>().subeler.map(
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
                                    "${context
                                                    .read<
                                                        UpdateUserInformationsCubit>()
                                                    .subeler
                                                    .indexOf(e) +
                                                1}  ",
                                    style: context.general.textTheme.titleLarge),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                  )).toList()
            ],
          );
  }

  Widget buildHalIciIsyerleriColumn(BuildContext context) {
    return context
            .read<UpdateUserInformationsCubit>()
            .halIciIsyerleriNew
            .isEmpty
        ? const SizedBox()
        : Column(
            children: [
              Text("Hal İçi İşyerleri",
                  style: context.general.textTheme.headlineSmall),
              ...(context
                  .read<UpdateUserInformationsCubit>()
                  .halIciIsyerleriNew
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
                                Text(
                                    "${context
                                                    .read<
                                                        UpdateUserInformationsCubit>()
                                                    .halIciIsyerleriNew
                                                    .indexOf(e) +
                                                1}  ",
                                    style: context.general.textTheme.titleLarge),
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Text(
                                        "",
                                        style: TextStyle(fontSize: 0),
                                      ),
                                      Text(e.isyeriAdi?.trim() ?? "Adres Boş"),
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
                  )).toList()
            ],
          );
  }

  FloatingActionButton buildFABDeleteButton(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: "sill",
      onPressed: () {
        BildirimciCacheManager.instance.deleteItem(context
            .read<UpdateUserInformationsCubit>()
            .hksUserNameController
            .text
            .trim());
        String? phone =
            AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
        UserCacheManager.instance.deleteBildirimciTc(
            phone ?? "",
            context
                .read<UpdateUserInformationsCubit>()
                .hksUserNameController
                .text
                .trim());
        Navigator.pop(context);
      },
      label: const Text("Sil"),
    );
  }

  Future<void> buildBlocListener(
      BuildContext context, UpdateUserInformationsState state) async {
    if (state is UpdateUserInformationsLoading) {
      context.loaderOverlay.show();
    } else {
      if (context.loaderOverlay.visible) {
        context.loaderOverlay.hide();
      }
    }
    if (state is UpdateUserInformationsError) {
      ScaffoldMessengerHelper.instance
          .showErrorSnackBar(context, state.message);
    }
    if (state is UpdateUserInformationsSuccessful) {
      ScaffoldMessengerHelper.instance
          .showSuccessfulSnackBar(context, state.message ?? "İşlem Başarılı");
      Navigator.pop(context);
      await FirestoreService.instance.saveAllUserData();
    }
    if (state is UpdateUserInformationsUserFound) {
      showAreYouSureDialog(context);
    }
  }

  TextFormField buildKullaniciAdiField(BuildContext context) {
    return TextFormField(
      enabled: false,
      validator: ((value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen Tc giriniz';
        }
        if (!context.read<UpdateUserInformationsCubit>().isNumeric(value)) {
          return "Tc sadece numara içerebilir";
        }
        if (value.length <= 9) {
          return "Tc 9 karaterden küçük olamaz";
        }
        return null;
      }),
      controller:
          context.read<UpdateUserInformationsCubit>().hksUserNameController,
      keyboardType: TextInputType.phone,
      autovalidateMode:
          context.read<UpdateUserInformationsCubit>().isAutoValidateMode,
      decoration: InputDecoration(
          labelText: "Hks Kullanıcı Adı",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
  }

  TextFormField buildWebServicePasswordField(BuildContext context) {
    return TextFormField(
      validator: ((value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen Web Service Sifrenizi giriniz';
        }
        return null;
      }),
      autovalidateMode:
          context.read<UpdateUserInformationsCubit>().isAutoValidateMode,
      controller: context
          .read<UpdateUserInformationsCubit>()
          .hksWebServicePasswordController,
      decoration: InputDecoration(
          labelText: "Web Servisi Şifreniz",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
  }

  TextFormField buildHksPasswordField(BuildContext context) {
    return TextFormField(
      validator: ((value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen Hks şifrenizi giriniz';
        }

        return null;
      }),
      autovalidateMode:
          context.read<UpdateUserInformationsCubit>().isAutoValidateMode,
      controller:
          context.read<UpdateUserInformationsCubit>().hksPasswordController,
      decoration: InputDecoration(
          labelText: "Hks Şifre",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
  }

  void showAreYouSureDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(
                "Bilgiler Doğru \n Bilgileri Güncellemek İstediğinizden Emin misiniz?"),
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
                  context
                      .read<UpdateUserInformationsCubit>()
                      .fetchInfosAndAddToDb();
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
