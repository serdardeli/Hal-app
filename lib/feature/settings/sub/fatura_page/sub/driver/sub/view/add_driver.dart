import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hal_app/project/model/driver_model/driver_model.dart';
import 'package:kartal/kartal.dart';

import '../../../../../../../helper/scaffold_messager.dart';
import '../viewmodel/cubit/add_driver_cubit.dart';

 

class AddDriverPage extends StatelessWidget {
  static const String name = "addDriverPage";
  const AddDriverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddDriverCubit, AddDriverState>(
      listener: (context, state) {
        if (state is AddDriverSuccess) {
          ScaffoldMessengerHelper.instance
              .showSuccessfulSnackBar(context, state.message);
          Navigator.pop(context);
        }
        if (state is AddDriverError) {
          ScaffoldMessengerHelper.instance
              .showErrorSnackBar(context, state.message);
        }
        if (state is AddDriverDeleted) {
          ScaffoldMessengerHelper.instance
              .showSuccessfulSnackBar(context, "Deleted");
          Navigator.pop(context);
        }
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
            appBar: CupertinoNavigationBar(
              heroTag: "AddDriverNavBar",
              transitionBetweenRoutes: false,
              middle: Text(context.read<AddDriverCubit>().isUpdateState
                  ? "Üretici Güncfelle"
                  : "Üretici Ekle"),
            ),
            floatingActionButton: context.read<AddDriverCubit>().isUpdateState
                ? FloatingActionButton.extended(
                    backgroundColor: Colors.green,
                    heroTag: "üretici sil",
                    onPressed: () {
                      context.read<AddDriverCubit>().removeUretici();
                    },
                    label: Text("Üreticiyi Sil"))
                : SizedBox(),
            body: buildInputFields(context));
      },
    );
  }
/*
  buildBody(BuildContext context) {
    // // final args = ModalRoute.of(context)!.settings.arguments;
    // // Uretici? uretici;
    //  if (args != null) {
    //    uretici = (args as AddUreticiProfilePageArgument).uretici;
    //    context.read<AddDriverCubit>().fillUreticiData(uretici);
    //  } else {}
    return buildInputFields(context);
  }*/

  Form buildInputFields(BuildContext context) {
    return Form(
      key: context.read<AddDriverCubit>().formKey,
      child: ListView(
        children: [
          buildUreticiTcField(context),
          buildUreticiIsimField(context),
          Padding(
            padding: context.padding.horizontalHigh,
            child: Padding(
              padding: context.padding.verticalNormal,
              child: FloatingActionButton.extended(
                  backgroundColor: Colors.green,
                  heroTag: "güncelle ekle",
                  onPressed: () {
                    if (context
                        .read<AddDriverCubit>()
                        .formKey
                        .currentState!
                        .validate()) {
                      context.read<AddDriverCubit>().addDriver(context);
                    }
                  },
                  label: Text(context.read<AddDriverCubit>().isUpdateState
                      ? "Bilgileri Güncelle"
                      : "Sürücü Ekle")),
            ),
          ),
          SizedBox(
            height: context.general.mediaSize.height * .3,
          )
        ],
      ),
    );
  }

  Padding buildUreticiTcField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        enabled: !context.read<AddDriverCubit>().isUpdateState,
        controller: context.read<AddDriverCubit>().tcController,
        autovalidateMode: context.read<AddDriverCubit>().isAutoValidateMode,
        validator: (value) {
          if (value != null && value != "") {
            value = value.trim();
            if (!context.read<AddDriverCubit>().isNumeric(value)) {
              return "Tc sadece numara içerebilir";
            }
            if (value.length <= 9) {
              return "Tc 9 karaterden küçük olamaz";
            }
          } else {
            return "Tc boş olamaz";
          }

          return null;
        },
        decoration: InputDecoration(
            labelText: "Tc",
            constraints: BoxConstraints(maxHeight: context.sized.normalValue * 3),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }

  Padding buildUreticiIsimField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: context.read<AddDriverCubit>().nameController,
        autovalidateMode: context.read<AddDriverCubit>().isAutoValidateMode,
        validator: (value) {
          if (value != null && value != "") {
            value = value.trim();

            if (value.length <= 4) {
              return "İsim en az 4 karakter olmalıdır";
            }
          } else {
            return "İsim boş olamaz";
          }
          return null;
        },
        decoration: InputDecoration(
            labelText: "Adı Soyadı",
            constraints: BoxConstraints(maxHeight: context.sized.normalValue * 3),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }
}
