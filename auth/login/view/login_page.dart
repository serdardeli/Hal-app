import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../sms_check_page/sms_check_view.dart';
import 'package:kartal/kartal.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../viewmodel/cubit/login_cubit.dart';

class LoginPage extends StatelessWidget {
  static const String name = "loginPage";
  LoginPage({Key? key}) : super(key: key);
  late final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is LoginLoading) {
          context.loaderOverlay.show();
        } else {
          if (context.loaderOverlay.visible) {
            context.loaderOverlay.hide();
          }
        }

        if (state is LoginSuccess) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Giriş Başarlı"),
            backgroundColor: Colors.green,
          ));
          Navigator.pushNamedAndRemoveUntil(
              context, state.rootNameToGo, (route) => false);
        }
        if (state is LoginError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            //     Navigator.pop(context);
            //  context.read<HomeCubit>().pageController.dispose();

            //context.read<HomeCubit>().currentIndex = 0;
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Çıkmak istiyor musun?"),
                    actions: [
                      TextButton(
                        child: const Text('Hayır'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Evet'),
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                      ),
                    ],
                  );
                });
            return false;
          },
          child: Scaffold(
            body: SafeArea(
              child: Padding(
                padding: context.padding.horizontalMedium,
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Giriş Yap",
                              style: context.general.textTheme.headlineMedium),
                          const PhoneField(),
                          TextFormField(
                            controller:
                                context.read<LoginCubit>().passwordController,
                            validator: (value) {
                              value ??= "";
                              if (value.trim().length < 5) {
                                return "çok kısa";
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: "Şifre",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15))),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  if (context
                                      .read<LoginCubit>()
                                      .phoneController
                                      .value
                                      .nsn
                                      .contains('5555555555')) {
                                    await context
                                        .read<LoginCubit>()
                                        .passwordLoginAppleDemo();
                                  } else if (context
                                      .read<LoginCubit>()
                                      .phoneController
                                      .value
                                      .isValid()) {
                                    _launchUrl(context);
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          "Telefon numarası geçerli değil"),
                                    ));
                                  }
                                },
                                child: const Text("Kayıt Ol"),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate() &&
                                      context
                                          .read<LoginCubit>()
                                          .phoneController
                                          .value
                                          .isValid()) {
                                    await context
                                        .read<LoginCubit>()
                                        .passwordLogin();
                                    // await context.read<LoginCubit>().logPhone();
                                    // await context
                                    //     .read<LoginCubit>()
                                    //     .signInWithPhoneNumber();
                                    // // ignore: use_build_context_synchronously
                                    // Navigator.pushNamed(
                                    //     context, SmsCheckPage.name);
                                  }
                                },
                                child: const Text("Giriş Yap"),
                              ),
                            ],
                          ),
                          Padding(
                            padding: context.padding.verticalNormal,
                            child: const Column(
                              children: [
                                Text(
                                    "Giriş yaparken yaşadığınız problemler için",
                                    textAlign: TextAlign.center),
                                SelectableText("+90 850 307 4270",
                                    style: TextStyle(color: Colors.blue)),
                                Text(
                                    "numara ile whatsapp üzerinden iletişime geçebilirsiniz.",
                                    textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchUrl(context) async {
    if (!await launchUrl(
        Uri.parse('https://hks-paywall.web.app/subscription-description'))) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Kaydolması sistemi açılamadı'),
      ));
    }
  }
}

class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: PhoneFormField(
        controller: context.read<LoginCubit>().phoneController,
        validator: PhoneValidator.compose([
          PhoneValidator.required(context,
              errorText: 'Telefon numarası boş bırakılamaz'),
          PhoneValidator.validMobile(context,
              errorText: 'Geçerli bir telefon giriniz'),
        ]),
        inputFormatters: [LengthLimitingTextInputFormatter(13)],
        countrySelectorNavigator: const CountrySelectorNavigator.page(),
        onChanged: (phoneNumber) => print('changed into $phoneNumber'),
        enabled: true,
        isCountrySelectionEnabled: false,
        isCountryButtonPersistent: true,
        decoration: InputDecoration(
          labelText: 'Telefon Numarası',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        countryButtonStyle: const CountryButtonStyle(
            showDialCode: true,
            showIsoCode: true,
            showFlag: true,
            flagSize: 20),
      ),
    );
  }
}
