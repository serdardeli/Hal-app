import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../../network_manager.dart/network_change_manager.dart';

class NoNetworkWidget extends StatefulWidget {
  const NoNetworkWidget({super.key});

  @override
  State<NoNetworkWidget> createState() => _NoNetworkWidgetState();
}

class _NoNetworkWidgetState extends State<NoNetworkWidget> with StateMixin {
  late final INetworkChangeManager _networkChange;
  NetworkResult? _networkResult;
  @override
  void initState() {
    super.initState();
    _networkChange = NetworkChangeManager.instance;

    waitForScreen(() {
      _networkChange.handleNetworkChange((result) {
        _updateView(result);
      });
    });
    fetchFirstResult();
  }

  Future<void> fetchFirstResult() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final result = await _networkChange.checkNetworkFirstTime();
      _updateView(result);
    });
  }

  void _updateView(NetworkResult result) {
    setState(() {
      _networkResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: context.duration.durationLow,
      crossFadeState: _networkResult == NetworkResult.off
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      firstChild: Container(
        height: context.sized.dynamicHeight(0.1),
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Lütfen İnternet Bağlantınızı Kontrol Ediniz !",
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
                style: context.general.textTheme.bodyLarge
                    ?.copyWith(color: Colors.white, fontSize: 11)),
            Text("İnternete bağlı değilken bildirim yapamazsınız.",
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: context.general.textTheme.bodyLarge
                    ?.copyWith(color: Colors.white, fontSize: 11)),
          ],
        ),
      ),
      secondChild: const SizedBox(),
    );
  }
}

mixin StateMixin<T extends StatefulWidget> on State<T> {
  void waitForScreen(VoidCallback onComplete) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onComplete.call();
    });
  }
}
