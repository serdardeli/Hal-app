import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../project/utils/widgets/not_active_user.dart';

import '../../project/utils/widgets/no_network_widget.dart';

class MainBuild {
  MainBuild._();
  static Widget build(BuildContext context, Widget? child) {
      EasyLoading.init();

    return Column(
      children: [
        Expanded(
          child: child ?? const SizedBox(),
        ),
        const NotActiveWidget(),
        const NoNetworkWidget()
      ],
    );
  }
}
