part of '../subscriptions_page.dart';

class OldSubscriptionPage extends StatelessWidget {
  const OldSubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!Navigator.canPop(context)) {
          buildDiolog(context);

          return false;
        }
        return true;
      },
      child: BlocConsumer<SubscriptionsCubit, SubscriptionsState>(
        listener: buildBlocListener,
        builder: (context, state) {
          bool canPop = Navigator.canPop(context);

          return Scaffold(
            appBar: buildAppBar(context),
            body: Padding(
              padding: context.padding.low,
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Padding(
                    padding: context.padding.verticalLow,
                    child: buildBasicSubscriptionCard(context),
                  ),

                  buildCreateYourSubscriptionSystem(context),
                  buildPremiumSubscriptionCard(context),
                  // !TestApp.instance.isTest
                  //     ? const SizedBox()
                  //     :
                  !canPop
                      ? Column(
                          children: [
                            //  buildHomeTestButton(context),
                            buildAnaSayfaButton()
                          ],
                        )
                      : const SizedBox(),
                  const BuildSubscriptionTest(),
                  ElevatedButton(
                      onPressed: () async {
                        // FirebaseAuthService.instance.signOut();
                        // AppCacheManager.instance.clearAll();
                        // UserCacheManager.instance.clearAll();
                        // Navigator.pushNamedAndRemoveUntil(
                        //     context, LoginPage.name, (route) => false);
                        commonLogOut(context);
                      },
                      child: const Text("Çıkış Yap")),
                ],
              )),
            ),
          );
        },
      ),
    );
  }

  BlocBuilder buildDropdownFeild(BuildContext context) {
    return BlocBuilder<SubscriptionsCubit, SubscriptionsState>(
      builder: (context, state) {
        return DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,

            dropdownStyleData: DropDown2Style.dropdownStyleData(context),
            buttonStyleData: DropDown2Style.buttonStyleData(context, width: 70),

            hint: Text('Cins Seç',
                style: TextStyle(
                    fontSize: 14, color: Theme.of(context).hintColor)),
            items: context
                .read<SubscriptionsCubit>()
                .subscriptionsNumbers
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                            fontSize: 14, overflow: TextOverflow.ellipsis),
                      ),
                    ))
                .toList(),
            value: context.read<SubscriptionsCubit>().dropdownValue,
            onChanged: (value) {
              context.read<SubscriptionsCubit>().dropdownValue =
                  (value as String);
              context.read<SubscriptionsCubit>().dropdownSelected();
            },

            //This to clear the search value when you close the menu
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                //      context.read<SubscriptionsCubit>().malinAdiController.clear();
              }
            },
          ),
        );
      },
    );
  }

  ValueListenableBuilder<Box<String>> buildAnaSayfaButton() {
    return ValueListenableBuilder(
        valueListenable:
            Hive.box<String>(AppCacheManager.instance.key).listenable(),
        builder: (context, Box<String>? box, widget) {
          return (box?.get(PreferencesKeys.isAccessDenied.name) ?? "") == "true"
              ? const SizedBox()
              : ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, ManageTcPage.name, ((route) => false));
                  },
                  child: const Text("Ana Sayfa"));
        });
  }

  ElevatedButton buildHomeTestButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
              context, ManageTcPage.name, (route) => false);
        },
        child: const Text("Home (TEST)"));
  }

  CupertinoNavigationBar buildAppBar(BuildContext context) {
    return CupertinoNavigationBar(
      heroTag: "abonelikler",
      transitionBetweenRoutes: false,
      middle: const Text("Abonelikler"),
      trailing: IconButton(
          onPressed: () async {
            await AppCacheManager.instance
                .removeItem(PreferencesKeys.subscriptionStartDate.name);
            await AppCacheManager.instance
                .removeItem(PreferencesKeys.isFreeSubscriptionUsed.name);
            Navigator.pushNamedAndRemoveUntil(
                context, Launch.name, (route) => false);
          },
          icon: const Icon(Icons.settings)),
    );
  }

  void buildBlocListener(BuildContext context, SubscriptionsState state) {
    if (state is SubscriptionsLoading) {
      context.loaderOverlay.show();
    } else {
      if (context.loaderOverlay.visible) {
        context.loaderOverlay.hide();
      }
    }
    // TODO: implement listener
    if (state is SubscriptionsSuccessful) {
      Navigator.pushNamedAndRemoveUntil(context, Launch.name, (route) => false);
    }
    if (state is SubscriptionsError) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(state.message)));
    }
  }

  Future<dynamic> buildDiolog(BuildContext context) {
    return showDialog(
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
  }

  void _showDialog(Widget child, BuildContext context) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: CupertinoColors.systemBackground.resolveFrom(context)),
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.

              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  final double _kItemExtent = 32.0;

  Column buildCreateYourSubscriptionSystem(BuildContext context) {
    return Column(
      children: [
        const Text("Kendi aboneliğini yarat ",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold)),
        Padding(
          padding: context.padding.verticalLow,
          child: const Text(
              "Birden fazla bildirimci adına bildirim yapmak istiyorsanız kendi aboneliğinizi oluşturabilirsiniz.",
              textAlign: TextAlign.center),
        ),
        Row(
          children: [
            const Flexible(
                child: Text(
                    "Kaç farklı bildirimci adına bildirim yapmak istiyorsunuz?",
                    textAlign: TextAlign.center)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: context.padding.horizontalLow,
                        child: buildDropdownFeild(context)),
                    const Text(' Adet'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Padding buildPremiumSubscriptionCard(BuildContext context) {
    return Padding(
      padding: context.padding.verticalLow,
      child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: context.padding.verticalLow,
                  child: const Text("Premium Plan Abonelik ",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                          "Bu abonelik ile ${context.watch<SubscriptionsCubit>().dropdownValue} adet bildirimci adına bildirim yapabilirsin.",
                          textAlign: TextAlign.center),
                    ),
                  ],
                ),
                Text(
                  "İlk hafta ücretsiz dene daha sonra aylık sadece ${(999.99 + ((int.parse(context.read<SubscriptionsCubit>().dropdownValue)) - 1) * 1000).toStringAsFixed(2)}₺ ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                    "1 aylık ${(999.99 + ((int.parse(context.read<SubscriptionsCubit>().dropdownValue)) - 1) * 1000).toStringAsFixed(2)}₺",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                ElevatedButton(
                    onPressed: () async {
                      await context
                          .read<SubscriptionsCubit>()
                          .clickPremiumSubscription();
                    },
                    child: const Text("Aboneliği Başlat",
                        textAlign: TextAlign.center))
              ],
            ),
          )),
    );
  }

  Card buildBasicSubscriptionCard(BuildContext context) {
    return Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: context.padding.verticalLow,
                child: const Text("Temel Plan Abonelik ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Text(
                  "Bu abonelikle sadece bir adet bildirimci adına bildirim yapabilirsiniz.",
                  textAlign: TextAlign.center),
              const Text(
                  "İlk hafta ücretsiz dene daha sonra aylık sadece 999,99₺",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const Text("1 aylık 999,99₺",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              ElevatedButton(
                  onPressed: () async {
                    await context
                        .read<SubscriptionsCubit>()
                        .clickBasicSubscription();
                  },
                  child: Padding(
                    padding: context.padding.verticalLow * .5,
                    child: const Text(
                      "Aboneliği Başlat",
                      textAlign: TextAlign.center,
                    ),
                  ))
            ],
          ),
        ));
  }

  BlocBuilder<SubscriptionsCubit, SubscriptionsState> buildDropDown() {
    return BlocBuilder<SubscriptionsCubit, SubscriptionsState>(
      builder: (context, state) {
        return DropdownButton<String>(
          value: context.read<SubscriptionsCubit>().dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          onChanged: (String? newValue) {
            context.read<SubscriptionsCubit>().dropdownValue = newValue!;
            context.read<SubscriptionsCubit>().emitState();
          },
          items: context
              .read<SubscriptionsCubit>()
              .subscriptionsNumbers
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        );
      },
    );
  }
}

class BuildSubscriptionTest extends StatelessWidget {
  const BuildSubscriptionTest({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.padding.horizontalLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Abonelik Anlaşmaları: ",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const Text('''
if you want to use this app you have to purchase subscription.s
You have to purchase an auto-renewing subscription through an In-App Purchase.

• Auto-renewable subscription

• 1kişi 1 aylık (999.99₺), 2 kişi 1 aylık (1999.99₺) and 3 kişi 1 aylık (2999.99₺)

• Your subscription will be charged to your iTunes account at confirmation of purchase and will automatically renew (at the duration selected) unless auto-renew is turned off at least 24 hours before the end of the current period.

• Current subscription may not be cancelled during the active subscription period; however, you can manage your subscription and/or turn off auto-renewal by visiting your iTunes Account Settings after purchase
Terms of Use: https://www.apple.com/legal/internet-services/itunes/dev/stdeula/
Privacy policy:https://www.hksbildir.net/privacypolicy
'''),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: context.padding.verticalNormal,
                  child: Row(
                    children: [
                      Flexible(
                        child: InkWell(
                            child: const Text('Click for Terms Of Use'),
                            onTap: () => launch(
                                'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/')),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: context.padding.verticalNormal,
                  child: Row(
                    children: [
                      Flexible(
                        child: InkWell(
                            child: const Text('Click for Privacy Policy'),
                            onTap: () => launch(
                                'https://www.hksbildir.net/privacypolicy')),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
