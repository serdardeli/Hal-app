import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../helper/scaffold_messager.dart';
import '../../../project/service/firebase/firestore/firestore_service.dart';
import '../viewmodel/cubit/add_tc_cubit.dart';
import 'package:kartal/kartal.dart';

class AddTcPage extends StatelessWidget {
  static const String name = "addTc";
  const AddTcPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<AddTcCubit>().clearAllFields();
        return true;
      },
      child: BlocConsumer<AddTcCubit, AddTcState>(
        listener: buildBlocListener,
        builder: (context, state) {
          return Scaffold(
            appBar:
                const CupertinoNavigationBar(middle: Text("Bildirimci Ekle")),
            body: Padding(
              padding: context.padding.horizontalNormal,
              child: SingleChildScrollView(
                  child: Form(
                key: context.read<AddTcCubit>().formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: context.padding.verticalNormal,
                      child: buildKullaniciAdiField(context),
                    ),
                    Padding(
                      padding: context.padding.verticalNormal,
                      child: buildHksPasswordField(context),
                    ),
                    Padding(
                      padding: context.padding.verticalNormal,
                      child: buildWebServicePasswordField(context),
                    ),
                    const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Web servisi şifrenizi 444 0 425 i arayarak öğrenebilirsiniz",
                          textAlign: TextAlign.center,
                        )),
                    Padding(
                      padding: context.padding.verticalNormal,
                      child: FloatingActionButton.extended(
                          backgroundColor: Colors.green,
                          onPressed: () async {
                            // await context.read<AddTcCubit>().addTc(context);
                            context.read<AddTcCubit>().activateAutoValidateMode;

                            if (context
                                .read<AddTcCubit>()
                                .formKey
                                .currentState!
                                .validate()) {
                              context
                                  .read<AddTcCubit>()
                                  .disableAutoValidateMode;

                              await context
                                  .read<AddTcCubit>()
                                  .addTcNew(context);
                            }
                          },
                          label: const Text("Bildirimciyi Ekle")),
                    )
                  ],
                ),
              )),
            ),
          );
        },
      ),
    );
  }

  Future<void> buildBlocListener(BuildContext context, AddTcState state) async {
    if (state is AddTcLoading) {
      EasyLoading.instance
        ..indicatorType = EasyLoadingIndicatorType.pouringHourGlass
        ..loadingStyle = EasyLoadingStyle.light
        ..userInteractions = false;
      EasyLoading.show(status: 'HKS Bekleniyor...');
    } else {
      EasyLoading.dismiss();
    }
    if (state is AddTcError) {
      ScaffoldMessengerHelper.instance
          .showErrorSnackBar(context, state.message);
    }
    if (state is AddTcSuccessful) {
      ScaffoldMessengerHelper.instance
          .showSuccessfulSnackBar(context, "Bildirimci Başarıyla Eklendi :)");
      context.read<AddTcCubit>().clearAllFields();
      Navigator.pop(context);

      await FirestoreService.instance.saveAllUserData();
    }
  }

  TextFormField buildWebServicePasswordField(BuildContext context) {
    return TextFormField(
      validator: ((value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen Web Service Sifrenizi giriniz';
        }
        return null;
      }),
      autovalidateMode: context.read<AddTcCubit>().isAutoValidateMode,
      controller: context.read<AddTcCubit>().hksWebServicePasswordController,
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
      autovalidateMode: context.read<AddTcCubit>().isAutoValidateMode,
      controller: context.read<AddTcCubit>().hksPasswordController,
      decoration: InputDecoration(
          labelText: "Hks Şifre",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
  }

  TextFormField buildKullaniciAdiField(BuildContext context) {
    return TextFormField(
      validator: ((value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen Tc giriniz';
        }
        if (!context.read<AddTcCubit>().isNumeric(value)) {
          return "Tc sadece numara içerebilir";
        }
        if (value.length <= 9) {
          return "Tc 9 karaterden küçük olamaz";
        }
        return null;
      }),
      controller: context.read<AddTcCubit>().hksUserNameController,
      keyboardType: TextInputType.phone,
      autovalidateMode: context.read<AddTcCubit>().isAutoValidateMode,
      decoration: InputDecoration(
          labelText: "Hks Kullanıcı Adı",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
  }
}
