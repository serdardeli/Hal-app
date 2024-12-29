import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hal_app/core/utils/dropdown2_style/dropdown2_style.dart';
import 'package:hal_app/feature/settings/view/settings_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../launch/view/launch_view.dart';
import '../../manage_tc/view/manage_tc_page.dart';
import '../viewmodel/cubit/subscriptions_cubit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kartal/kartal.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../core/enum/preferences_keys_enum.dart';
import '../../../project/cache/app_cache_manager.dart';

part './sub/old_subscription_page.dart';

class SubscriptionsPage extends StatefulWidget {
  static const String name = "subscriptionsPage";
  const SubscriptionsPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  @override
  Widget build(BuildContext context) {
    String? number =
        AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
    if (number!.contains("5555555555")) {
      return const OldSubscriptionPage();
    } else {
      return const NewSubscriptionPage();
    }
  }
}

class NewSubscriptionPage extends StatelessWidget {
  const NewSubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    //return const OldSubscriptionPage();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Abonelikler'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text('Hoşgeldiniz',
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium?.copyWith(color: Colors.green)),
          const SizedBox(height: 20),
          Text('Aboneliklerimizi artık web üzerinden satıyoruz.',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge
                  ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Text(
            'Aşşağıdaki link üzerinden abonelik planlarımıza ulaşabilirsiniz.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Flexible(
            child: InkWell(
                child: const Text('https://hks-paywall.web.app/',
                    style: TextStyle(color: Colors.blue)),
                onTap: () => launch('https://hks-paywall.web.app/')),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, Launch.name);
            },
            child: const Text(
              'Sayfayı Yenile',
            ),
          ),
          const Text(
            'Süreç hakkında daha fazla bilgi almak bize aşşağıdaki numaradan ulaşabilirsiniz.',
            textAlign: TextAlign.center,
          ),
          const SelectableText("+90 850 307 4270",
              style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }
}
