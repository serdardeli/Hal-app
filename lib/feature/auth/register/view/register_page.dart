import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../login/view/login_page.dart';
import '../viewmodel/cubit/register_cubit.dart';
import '../../../subscriptions/view/subscriptions_page.dart';
import 'package:kartal/kartal.dart';
import 'package:loader_overlay/loader_overlay.dart';

class RegisterPage extends StatelessWidget {
  static const String name = "registerPage";
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          Navigator.pushNamedAndRemoveUntil(
              context, SubscriptionsPage.name, (route) => false);
        }
        if (state is RegisterError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is RegisterLoading) {
          context.loaderOverlay.show();
        } else {
          context.loaderOverlay.hide();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: context.padding.horizontalMedium,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Kayıt ol",
                          style: context.general.textTheme.headlineMedium),
                      Padding(
                          padding: context.padding.verticalLow,
                          child: buildEmailTextFormField(context)),
                      Padding(
                          padding: context.padding.verticalLow,
                          child: buildPasswordTextFormField(context)),
                      ElevatedButton(
                          onPressed: () {
                            context
                                .read<RegisterCubit>()
                                .createUserWithEmailandPassword();
                          },
                          child: const Text("Kayıt ol")),
                      TextButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(context, LoginPage.name);
                          },
                          child: const Text("Giriş yap",
                              style: TextStyle(
                                  decoration: TextDecoration.underline)))
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  } //facarr00@gmail.com

  TextFormField buildEmailTextFormField(BuildContext context) {
    return TextFormField(
      controller: context.read<RegisterCubit>().emailController,
      decoration: InputDecoration(
          labelText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
  }

  TextFormField buildPasswordTextFormField(BuildContext context) {
    return TextFormField(
      controller: context.read<RegisterCubit>().passwordController,
      decoration: InputDecoration(
          labelText: "Şifre",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
  }
}
