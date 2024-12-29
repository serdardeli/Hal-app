import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../login/viewmodel/cubit/login_cubit.dart';
import 'package:kartal/kartal.dart';

class SmsCheckPage extends StatelessWidget {
  static const String name = "smsCheckPage";
  SmsCheckPage({Key? key}) : super(key: key);
  final TextEditingController numberController = TextEditingController();
  var smsFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(middle: Text("Sms Doğrulama")),
      body: Padding(
        padding: context.padding.medium,
        child: SingleChildScrollView(
            child: Form(
          key: smsFormKey,
          child: Column(
            children: [
              Padding(
                
                padding: context.padding.verticalNormal,
                child: Text("Girilen Telefon: ${context.read<LoginCubit>().phoneNumber}", textAlign: TextAlign.center),
              ),
              buildSmsTextFormField(context),
              Padding(
                padding: context.padding.verticalNormal,
                child: const Text(
                    "Mesajın gelmesi biraz zaman alabilir.\n Lütfen bekleyiniz.",
                    textAlign: TextAlign.center),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (smsFormKey.currentState!.validate()) {
                      context
                          .read<LoginCubit>()
                          .submitCode(numberController.text.trim());
                    }
                  },
                  child: const Text("Kodu doğrula"))
            ],
          ),
        )),
      ),
    );
  }

  TextFormField buildSmsTextFormField(BuildContext context) {
    return TextFormField(
      controller: numberController,
      validator: (value) {
        value ??= "";

        if (value.trim() == "") {
          return "kod boş olamaz";
        }

        return null;
      },
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
          labelText: "Sms kodu",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
  }
}
