import 'package:flutter/material.dart';
import 'no_network_widget.dart';
import 'package:kartal/kartal.dart';

class ExpandedCardContentSecondaryItem extends StatelessWidget {
  const ExpandedCardContentSecondaryItem(
      {Key? key,
      this.prefix,
      required this.text,
      this.suffix,
      // required this.ontap,
      this.backgroundColor})
      : super(key: key);
  final Widget? prefix;
  final Widget text;
  final Widget? suffix;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(context.sized.lowValue*1.5, context.sized.lowValue,
          context.sized.lowValue*1.5, context.sized.lowValue * 3),
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
        shadowColor: Colors.green,
        elevation: 10,
        color: this.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.sized.lowValue * 2, vertical: context.sized.lowValue * 2),
          child: Row(
            children: [
              prefix != null
                  ? Expanded(
                      flex: 1,
                      child: prefix!,
                    )
                  : Container(),
              const Spacer(
                flex: 1,
              ),
              Expanded(
                flex: 25,
                child: text,
              ),
              suffix != null
                  ? Expanded(
                      flex: 2,
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
