import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kartal/kartal.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);
  static const String name = "helpPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text("Yardım"),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Yardım almak için mail adresine ulaşabilirsiniz."),
          Padding(
            padding: context.padding.verticalNormal,
            child: SelectableText("destek@hksbildir.net",
                style: TextStyle(color: Colors.blue)),
          ),
        ],
      )),
    );
  }
}
