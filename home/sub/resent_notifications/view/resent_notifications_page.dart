import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hal_app/feature/helper/scaffold_messager.dart';
import 'package:hal_app/feature/home/sub/saved_notifications/viewmodel/cubit/saved_notification_page_general_cubit.dart';
import '../viewmodel/cubit/recent_notifications_cubit.dart';
import 'package:intl/intl.dart';
import 'package:kartal/kartal.dart';

import '../../../../../core/utils/widget/expandable_card_for_recent_activity.dart';
import '../../../../../project/model/referans_kunye/referans_kunye_model.dart';
import '../../../../../project/utils/widgets/expanded_card_secondary_content.dart';

class CustomAnimation extends EasyLoadingAnimation {
  CustomAnimation();

  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    return Opacity(
      opacity: controller.value,
      child: RotationTransition(
        turns: controller,
        child: child,
      ),
    );
  }
}

class ResentNotificationsPage extends StatelessWidget {
  const ResentNotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<SavedNotificationPageGeneralCubit>().closeSearch(context);
    return BlocConsumer<RecentNotificationsCubit, RecentNotificationsState>(
      listener: (context, state) {
        if (state is RecentNotificationsLoading) {
          EasyLoading.instance
            ..indicatorType = EasyLoadingIndicatorType.spinningCircle
            ..loadingStyle = EasyLoadingStyle.light
            ..userInteractions = false;
          EasyLoading.show(
            status: 'Yükleniyor...',
            indicator: const Center(
              child: SpinKitSpinningLines(
                color: Colors.green,
                size: 50.0,
              ),
            ),
          );
          //  context.loaderOverlay.show();
        } else {
          EasyLoading.dismiss();

          // if (context.loaderOverlay.visible) {
          //   context.loaderOverlay.hide();
          // }
        }
        if (state is RecentNotificationsError) {
          ScaffoldMessengerHelper.instance
              .showErrorSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            await context.read<RecentNotificationsCubit>().fetchBoth();
          },
          child: context
                  .read<RecentNotificationsCubit>()
                  .bildirimListMerged
                  .isEmpty
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.green))
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: context
                          .read<RecentNotificationsCubit>()
                          .bildirimListMerged
                          .length +
                      1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return buildBildirimlerText(context);
                    }
                    ReferansKunye bildirim = context
                        .read<RecentNotificationsCubit>()
                        .bildirimListMerged[index - 1];
                    return Padding(
                      padding: context.padding.horizontalLow,
                      child: buildListCardItem(bildirim, context),
                    );
                  },
                ),
        );
      },
    );
  }

  String parseDate(String date) {
    DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");

    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss');

    return displayFormater.format(dateFormat.parse(date));
  }

  ExpansionCardForRecentActivity buildListCardItem(
      ReferansKunye bildirim, BuildContext context) {
    return ExpansionCardForRecentActivity(
      title: Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${bildirim.malinAdi ?? "null"} ${bildirim.malinCinsi ?? "null"}',
              overflow: TextOverflow.ellipsis,
            ),
            Text(bildirim.aracPlakaNo ?? "null"),
            Text(parseDate(bildirim.bildirimTarihi ?? "null").toString()),
          ],
        ),
      ),
      children: [
        buildChild(context, bildirim),
      ],
    );
  }

  ExpandedCardContentSecondaryItem buildChild(
          BuildContext context, ReferansKunye bildirim) =>
      ExpandedCardContentSecondaryItem(
          text: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildKunyeNo(context, bildirim),
          buildSaat(context, bildirim),
          buildPlakaText(context, bildirim),
          buildUrunAdi(context, bildirim),
          buildMiktarText(context, bildirim),
          buildFiyatText(context, bildirim),
        ],
      ));

  RichText buildFiyatText(BuildContext context, ReferansKunye bildirim) {
    return RichText(
      overflow: TextOverflow.clip,
      textAlign: TextAlign.start,
      softWrap: true,
      maxLines: 1,
      text: TextSpan(
        style: context.general.textTheme.bodyLarge,
        children: <TextSpan>[
          const TextSpan(
              text: 'Fiyat: ', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: "${bildirim.malinSatisFiyati ?? "BOŞ"} ₺"),
        ],
      ), textScaler: const TextScaler.linear(1),
    );
  }

  RichText buildMiktarText(BuildContext context, ReferansKunye bildirim) {
    return RichText(
      overflow: TextOverflow.clip,
      textAlign: TextAlign.start,
      softWrap: true,
      maxLines: 1,
      text: TextSpan(
        style: context.general.textTheme.bodyLarge,
        children: <TextSpan>[
          const TextSpan(
              text: 'Miktar: ', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: "${bildirim.malinMiktari ?? "BOŞ"} "),
          TextSpan(text: "${bildirim.malinMiktarBirimAd ?? "BOŞ"}  "),
        ],
      ), textScaler: const TextScaler.linear(1),
    );
  }

  RichText buildUrunAdi(BuildContext context, ReferansKunye bildirim) {
    return RichText(
      overflow: TextOverflow.clip,
      textAlign: TextAlign.start,
      softWrap: true,
      maxLines: 1,
      text: TextSpan(
        style: context.general.textTheme.bodyLarge,
        children: <TextSpan>[
          const TextSpan(
              text: 'Ürün: ', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: "${bildirim.malinAdi ?? "BOŞ"}  "),
          TextSpan(text: (bildirim.malinCinsi ?? "BOŞ")),
        ],
      ), textScaler: const TextScaler.linear(1),
    );
  }

  RichText buildPlakaText(BuildContext context, ReferansKunye bildirim) {
    return RichText(
      overflow: TextOverflow.clip,
      textAlign: TextAlign.start,
      softWrap: true,
      maxLines: 1,
      text: TextSpan(
        style: context.general.textTheme.bodyLarge,
        children: <TextSpan>[
          const TextSpan(
              text: 'Plaka: ', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: (bildirim.aracPlakaNo ?? "BOŞ")),
        ],
      ), textScaler: const TextScaler.linear(1),
    );
  }

  RichText buildSaat(BuildContext context, ReferansKunye bildirim) {
    return RichText(
      overflow: TextOverflow.clip,
      textAlign: TextAlign.start,
      softWrap: true,
      maxLines: 1,
      text: TextSpan(
        style: context.general.textTheme.bodyLarge,
        children: <TextSpan>[
          const TextSpan(
              text: 'Bildirim Saati: ',
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: (parseDate(bildirim.bildirimTarihi ?? "BOŞ"))),
        ],
      ), textScaler: const TextScaler.linear(1),
    );
  }

  RichText buildKunyeNo(BuildContext context, ReferansKunye bildirim) {
    return RichText(
      overflow: TextOverflow.clip,
      textAlign: TextAlign.start,
      softWrap: true,
      maxLines: 1,
      text: TextSpan(
        style: context.general.textTheme.bodyLarge,
        children: <TextSpan>[
          const TextSpan(
              text: 'Kunye No: ',
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: bildirim.kunyeNo ?? "BOŞ"),
        ],
      ), textScaler: const TextScaler.linear(1),
    );
  }

  Padding buildBildirimlerText(BuildContext context) {
    return Padding(
      padding: context.padding.verticalLow,
      child: Text(
        "Bildirimler",
        textAlign: TextAlign.center,
        style: context.general.textTheme.titleLarge!
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
