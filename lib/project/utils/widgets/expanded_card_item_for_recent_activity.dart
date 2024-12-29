import 'package:flutter/material.dart';
import 'no_network_widget.dart';
import 'package:kartal/kartal.dart';

class ExpandedCardItemForRecentActivity extends StatelessWidget {
  const ExpandedCardItemForRecentActivity(
      {Key? key,
      required this.prefix,
      required this.text,
      this.suffix,
      //   required this.ontapExpand,
      //   required this.ontapCustom,
      this.backgroundColor})
      : super(key: key);
  final Widget prefix;
  final Widget text;
  final Widget? suffix;
  //final VoidCallback ontapExpand;
  //final VoidCallback ontapCustom;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: context.sized.lowValue, horizontal: context.sized.lowValue * 0.3),
      child: Container(
        child: buildCardContent(context),
      ),
    );
  }

  Container buildCardContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.green[600]!),
          borderRadius: BorderRadius.circular(10)),
      child: Material(
        elevation: 10,
        shadowColor: Colors.green,
        color: this.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.sized.lowValue * 2,
              vertical: context.sized.lowValue * .8),
          child: Row(
            children: [
              const Spacer(flex: 1),
              Expanded(flex: 20, child: text),
              suffix != null ? Expanded(flex: 10, child: suffix!) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
