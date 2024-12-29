import 'package:flutter/material.dart';
import 'no_network_widget.dart';
import 'package:kartal/kartal.dart';

class ExpandedCardItem extends StatelessWidget {
  const ExpandedCardItem(
      {Key? key,
      this.prefix,
      required this.text,
      this.suffix,
      //   required this.ontapExpand,
      //   required this.ontapCustom,
      this.backgroundColor})
      : super(key: key);
  final Widget? prefix;
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
        shadowColor: Colors.green[300],
        color: this.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.sized.lowValue * 2,
              vertical: context.sized.lowValue * .8),
          child: Row(
            children: [
              // Expanded(
              //   flex: 1,
              //   child: prefix,
              // ),
              const Spacer(
                flex: 1,
              ),
              Expanded(
                flex: 15,
                child: text,
              ),
              suffix != null
                  ? Expanded(
                      flex: 20,
                      child: suffix!,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
