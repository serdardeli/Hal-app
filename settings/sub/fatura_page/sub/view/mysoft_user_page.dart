import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hal_app/feature/helper/scaffold_messager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kartal/kartal.dart';

import '../../../../../../project/cache/mysoft_user_cache_mananger.dart';

import '../../../../../../project/model/MySoft_user_model/mysoft_user_model.dart';
import '../../../../../helper/active_tc.dart';
import '../viewmodel/cubit/mysoft_user_cubit.dart';

class MySoftUserPage extends StatelessWidget {
  static const String name = "addMySoftUserPage";
  const MySoftUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AddMySoftUserCubit>().fillWithOutSideData();

    return WillPopScope(
      onWillPop: () async {
        context.read<AddMySoftUserCubit>().clearAll();
        return true;
      },
      child: BlocListener<AddMySoftUserCubit, AddMySoftUserState>(
        listener: (context, state) {
          if (state is AddMySoftUserAddSuccessful) {
            context.read<AddMySoftUserCubit>().clearAll();

            ScaffoldMessengerHelper.instance
                .showSuccessfulSnackBar(context, "Kullanıcı Ekleme Başarılı");
            Navigator.pop(context);
          }
          if (state is AddMySoftUserUpdateSuccessful) {
            context.read<AddMySoftUserCubit>().clearAll();
            ScaffoldMessengerHelper.instance.showSuccessfulSnackBar(
                context, "Kullanıcı Güncelleme Başarılı");
            Navigator.pop(context);
          }
          if (state is AddMySoftUserError) {
            ScaffoldMessengerHelper.instance
                .showErrorSnackBar(context, state.message);
          }
        },
        child: ValueListenableBuilder(
            valueListenable:
                Hive.box<MySoftUserModel>(MySoftUserCacheManager.instance.key)
                    .listenable(),
            builder: (BuildContext context, Box<MySoftUserModel> box,
                Widget? child) {



              MySoftUserModel? user = box.get(ActiveTc.instance.activeTc);
              context.read<AddMySoftUserCubit>().currentMySoftUser = user;
              if (user != null) {
                return buildUpdateUserBody(context);
              } else {
                return buildAddUserBody(context);
              }
            }),
      ),
    );
  }

  Widget buildUpdateUserBody(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildSilButton(context),
      appBar: const CupertinoNavigationBar(
          middle: Text("MySoft Fatura Kullanıcısını Güncelle")),
      body: Padding(
        padding: context.padding.horizontalNormal,
        child: SingleChildScrollView(
          child: Form(
            key: context.read<AddMySoftUserCubit>().formKey,
            child: Column(
              children: [
                builduserNameField(context),
                buildPasswordField(context),
                buildFirmaAdiField(context),
                buildActionButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  FloatingActionButton buildSilButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        context.read<AddMySoftUserCubit>().firmaController.clear();
        MySoftUserCacheManager.instance.removeItem(ActiveTc.instance.activeTc);
      },
      label: Text("Sil"),
      heroTag: "silMySoft",
    );
  }

  Widget buildAddUserBody(BuildContext context) {
    return Scaffold(
      // floatingActionButton: buildSilButton(),
      appBar: const CupertinoNavigationBar(
        middle: Text("MySoft Fatura Kullanıcısı Ekle"),
      ),
      body: Padding(
        padding: context.padding.horizontalNormal,
        child: SingleChildScrollView(
          child: Form(
            key: context.read<AddMySoftUserCubit>().formKey,
            child: Column(
              children: [
                builduserNameField(context),
                buildPasswordField(context),
                buildFirmaAdiField(context),
                buildActionButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildActionButton(BuildContext context) {
    return BlocBuilder<AddMySoftUserCubit, AddMySoftUserState>(
      builder: (context, state) {
        MySoftUserModel? user =
            context.read<AddMySoftUserCubit>().currentMySoftUser;
        return Padding(
          padding: context.padding.verticalNormal,
          child: FloatingActionButton.extended(
              backgroundColor: Colors.green,
              heroTag: "MySoftAddUser",
              onPressed: () {
                //  context.read<AddMySoftUserCubit>().updateInfosRequest();
                if (context
                    .read<AddMySoftUserCubit>()
                    .formKey
                    .currentState!
                    .validate()) {
                  if (user != null) {
                    context.read<AddMySoftUserCubit>().updateMySoftUser();
                  } else {

                    context.read<AddMySoftUserCubit>().addMySoftUser();
                  }
                }
              },
              label: Text(user != null ? "Güncelle" : "Ekle")),
        );
      },
    );
  }

  Widget builduserNameField(BuildContext context) {
    return BlocBuilder<AddMySoftUserCubit, AddMySoftUserState>(
      builder: (context, state) {
        return Padding(
          padding: context.padding.verticalLow,
          child: TextFormField(
            validator: ((value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen Kullanıcı Adı giriniz';
              }

              if (value.length <= 5) {
                return "Kullanıcı Adı 5 karaterden küçük olamaz";
              }
              return null;
            }),
            controller: context.read<AddMySoftUserCubit>().userNameController,
            autovalidateMode:
                context.read<AddMySoftUserCubit>().isAutoValidateMode,
            decoration: InputDecoration(
                labelText: "Kullanıcı Adı",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
        );
      },
    );
  }

  Widget buildPasswordField(BuildContext context) {
    return BlocBuilder<AddMySoftUserCubit, AddMySoftUserState>(
      builder: (context, state) {
        return Padding(
          padding: context.padding.verticalLow,
          child: TextFormField(
            validator: ((value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen   Sifrenizi giriniz';
              }
              return null;
            }),
            autovalidateMode:
                context.read<AddMySoftUserCubit>().isAutoValidateMode,
            controller: context.read<AddMySoftUserCubit>().passwordController,
            decoration: InputDecoration(
                labelText: "Şifre",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
        );
      },
    );
  }

  Widget buildFirmaAdiField(BuildContext context) {
    return BlocBuilder<AddMySoftUserCubit, AddMySoftUserState>(
      builder: (context, state) {
        return Padding(
          padding: context.padding.verticalLow,
          child: TextFormField(
            validator: ((value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen Firma Adı giriniz';
              }

              if (value.length <= 4) {
                return "Firma Adı 4 karaterden küçük olamaz";
              }
              return null;
            }),
            autovalidateMode:
                context.read<AddMySoftUserCubit>().isAutoValidateMode,
            controller: context.read<AddMySoftUserCubit>().firmaController,
            decoration: InputDecoration(
                labelText: "Firma Adı",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
        );
      },
    );
  }
}
