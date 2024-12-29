import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hal_app/core/utils/dropdown2_style/dropdown2_style.dart';
import 'package:hal_app/project/utils/component/dropdown2_string_search.dart';
import '../../../../../../helper/scaffold_messager.dart';
import 'package:kartal/kartal.dart';
import 'package:turkish/turkish.dart';

import '../../../../../../../project/model/uretici_model/uretici_model.dart';
import '../../../viewmodel/cubit/add_profile_cubit.dart';

class AddUreticiProfilePageArgument {
  final Uretici uretici;

  AddUreticiProfilePageArgument(this.uretici);
}

class AddUreticiProfilePage extends StatelessWidget {
  static const String name = "addUreticiProfilePage";
  const AddUreticiProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddProfileCubit, AddProfileState>(
      listener: (context, state) {
        if (state is AddProfileSuccess) {
          ScaffoldMessengerHelper.instance
              .showSuccessfulSnackBar(context, state.message);
          Navigator.pop(context);
        }
        if (state is AddProfileError) {
          ScaffoldMessengerHelper.instance
              .showErrorSnackBar(context, state.message);
        }
        if (state is AddProfileDeleted) {
          ScaffoldMessengerHelper.instance
              .showSuccessfulSnackBar(context, "Deleted");
          Navigator.pop(context);
        }
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
            appBar: CupertinoNavigationBar(
              heroTag: "addUreticiProfilePage",
              transitionBetweenRoutes: false,
              middle: Text(context.read<AddProfileCubit>().isUpdateState
                  ? "Üretici Güncelle"
                  : "Üretici Ekle"),
            ),
            floatingActionButton: context.read<AddProfileCubit>().isUpdateState
                ? FloatingActionButton.extended(
                    backgroundColor: Colors.green,
                    heroTag: "üretici sil",
                    onPressed: () {
                      context.read<AddProfileCubit>().removeUretici();
                    },
                    label: const Text("Üreticiyi Sil"))
                : const SizedBox(),
            body: buildInputFields(context));
      },
    );
  }

  Form buildInputFields(BuildContext context) {
    return Form(
      key: context.read<AddProfileCubit>().formKey,
      child: ListView(
        children: [
          buildUreticiTcField(context),
          buildUreticiIsimField(context),
          buildUreticiTelField(context),
          BlocBuilder<AddProfileCubit, AddProfileState>(
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
          buildErrorText(),
          Padding(
            padding: context.padding.horizontalHigh,
            child: Padding(
              padding: context.padding.verticalNormal,
              child: FloatingActionButton.extended(
                  backgroundColor: Colors.green,
                  heroTag: "güncelle ekle",
                  onPressed: () {
                    context.read<AddProfileCubit>().addProfile(context);
                  },
                  label: Text(context.read<AddProfileCubit>().isUpdateState
                      ? "Bilgileri Güncelle"
                      : "Profil Ekle")),
            ),
          ),
          SizedBox(
            height: context.general.mediaSize.height * .3,
          )
        ],
      ),
    );
  }

  BlocBuilder<AddProfileCubit, AddProfileState> buildErrorText() {
    return BlocBuilder<AddProfileCubit, AddProfileState>(
      builder: (context, state) {
        return context.read<AddProfileCubit>().dropDownErrorMessage == ""
            ? const SizedBox()
            : Padding(
                padding: context.padding.verticalLow,
                child: Text(
                  context.read<AddProfileCubit>().dropDownErrorMessage,
                  style: context.general.textTheme.bodyMedium!
                      .apply(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              );
      },
    );
  }

  Widget buildCityField2(BuildContext context) {
    return DropDown2StringSearch(
      controller: context.read<AddProfileCubit>().ilController,
      items: context.read<AddProfileCubit>().getCities.values.toList(),
      hint: 'İl Seç',
      onChanged: (value) {
        context.read<AddProfileCubit>().ilSelected(value);
      },
      selectedValue: context.read<AddProfileCubit>().selectedIl,
      onMenuStateChange: () {
        context.read<AddProfileCubit>().ilController.clear();
      },
    );
  }

  Widget buildIlceField2(BuildContext context) {
    return DropDown2StringSearch(
      controller: context.read<AddProfileCubit>().ilceController,
      items: context.read<AddProfileCubit>().getIlceler.values.toList(),
      hint: 'İlçe Seç',
      onChanged: (value) {
        context.read<AddProfileCubit>().ilceSelected(value);
      },
      selectedValue: context.read<AddProfileCubit>().selectedIlce,
      onMenuStateChange: () {
        context.read<AddProfileCubit>().ilceController.clear();
      },
    );
  }

  Widget buildBeldeField2(BuildContext context) {
    return DropDown2StringSearch(
      controller: context.read<AddProfileCubit>().beldeController,
      items: context.read<AddProfileCubit>().getBeldeler.values.toList(),
      hint: 'Belde Seç',
      onChanged: (value) {
        context.read<AddProfileCubit>().selectedBelde = value;
        context.read<AddProfileCubit>().beldeSelected();
      },
      selectedValue: context.read<AddProfileCubit>().selectedBelde,
      onMenuStateChange: () {
        context.read<AddProfileCubit>().beldeController.clear();
      },
    );
  }

  Padding buildUreticiTcField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        controller: context.read<AddProfileCubit>().tcController,
        autovalidateMode: context.read<AddProfileCubit>().isAutoValidateMode,
        validator: (value) {
          if (value != null && value != "") {
            value = value.trim();
            if (!context.read<AddProfileCubit>().isNumeric(value)) {
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
            constraints:
                BoxConstraints(maxHeight: context.sized.normalValue * 3),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }

  Padding buildUreticiIsimField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        enabled: !context.read<AddProfileCubit>().isUpdateState,
        controller: context.read<AddProfileCubit>().nameController,
        autovalidateMode: context.read<AddProfileCubit>().isAutoValidateMode,
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
            constraints:
                BoxConstraints(maxHeight: context.sized.normalValue * 3),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
      ),
    );
  }

  Padding buildUreticiTelField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: context.read<AddProfileCubit>().telController,
        autovalidateMode: context.read<AddProfileCubit>().isAutoValidateMode,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value != null && value != "") {
            value = value.trim();
            if (!context.read<AddProfileCubit>().isNumeric(value)) {
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
}
