import 'package:flutter/material.dart';
import 'no_network_widget.dart';
import 'package:kartal/kartal.dart';

class SettingsCardItem extends StatelessWidget {
  const SettingsCardItem(
      {Key? key,
      this.prefix,
      required this.text,
      this.suffix,
      this.ontap,
      this.backgroundColor})
      : super(key: key);
  final Widget? prefix;
  final Widget text;
  final Widget? suffix;
  final VoidCallback? ontap;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // borderRadius: BorderRadius.all(Radius.circular(context.sized.lowValue * 1.5)),
      // overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: ontap,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: context.sized.lowValue, horizontal: context.sized.lowValue * 0.3),
        child: Container(
          //decoration: buildBoxDecoration(context),
          //padding: EdgeInsets.symmetric(
          //    vertical: context.sized.lowValue * 2.5,
          //    horizontal: context.sized.lowValue * 2),
          child: buildCardContent(context),
        ),
      ),
    );
  }

/*
  BoxDecoration buildBoxDecoration(BuildContext context) {
    return BoxDecoration(
    //  color: context.colors.background,
      borderRadius: BorderRadius.all(
        Radius.circular(context.sized.lowValue * 1.5),
      ),
      boxShadow: buildBoxShadow(context),
    );
  }

  List<BoxShadow> buildBoxShadow(BuildContext context) {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        spreadRadius: 1,
        blurRadius: 1,
        offset: const Offset(2, 1.5), // changes position of shadow
      ),
    ];
  }
*/
  Container buildCardContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.green[600]!),
          borderRadius: BorderRadius.circular(10)),
      child: Material(
        // color: context.general.textTheme.appBarTheme.backgroundColor,
        elevation: 10,
        shadowColor: Colors.green[300],
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
                  : SizedBox(),
              prefix != null ? const Spacer(flex: 3) : const Spacer(flex: 1),
              Expanded(
                flex: 25,
                child: text,
              ),
              suffix != null
                  ? Expanded(
                      flex: 2,
                      child: suffix!,
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
