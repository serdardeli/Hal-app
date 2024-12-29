import 'package:flutter/material.dart';
import 'project/utils/widgets/settings_page_card_item.dart';

class MyApp22 extends StatelessWidget {
  const MyApp22({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

// stores ExpansionPanel state information
class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final List<Item> _data = generateItems(8);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      elevation: 1,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: SettingsCardItem(
                ontap: () {},
                prefix: Icon(Icons.dangerous),
                text: Text(item.headerValue),
              ),
            );
          },
          body: ListTile(
              title: Text(item.expandedValue),
              subtitle:
                  const Text('To delete this panel, tap the trash can icon'),
              trailing: const Icon(Icons.delete),
              onTap: () {
                setState(() {
                  _data.removeWhere((Item currentItem) => item == currentItem);
                });
              }),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
/**
 * import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExpansionPanelDemo extends StatefulWidget {
  @override
  _ExpansionPanelDemoState createState() => _ExpansionPanelDemoState();
}

class ItemModel {
  bool expanded;
  late String headerItem;
  late String discription;
  late Color colorsItem;
  late String img;

  ItemModel(
      {this.expanded: false,
      required this.headerItem,
      required this.discription,
      required this.colorsItem,
      required this.img});
}

class _ExpansionPanelDemoState extends State<ExpansionPanelDemo> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Expansion Panel Demo'),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: itemData.length,
            itemBuilder: (BuildContext context, int index) {
              return ExpansionPanelList(
                animationDuration: Duration(milliseconds: 1000),
                dividerColor: Colors.red,
                elevation: 1,
                children: [
                  ExpansionPanel(
                    body: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ClipOval(
                            child: CircleAvatar(
                              //https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRo9xqsZF_yYunSeg9vuq2UBWCGuuID6B7T1DCX2UQP&s
                              child: Image.network(
                               "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRo9xqsZF_yYunSeg9vuq2UBWCGuuID6B7T1DCX2UQP&s",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            itemData[index].discription,
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 15,
                                letterSpacing: 0.3,
                                height: 1.3),
                          ),
                        ],
                      ),
                    ),
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          itemData[index].headerItem,
                          style: TextStyle(
                            color: itemData[index].colorsItem,
                            fontSize: 18,
                          ),
                        ),
                      );
                    },
                    isExpanded: itemData[index].expanded,
                  )
                ],
                expansionCallback: (int item, bool status) {
                  setState(() {
                    itemData[index].expanded = !itemData[index].expanded;
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }

  List<ItemModel> itemData = <ItemModel>[
    ItemModel(
        headerItem: 'Android',
        discription:
            "Android is a mobile operating system based on a modified version of the Linux kernel and other open source software, designed primarily for touchscreen mobile devices such as smartphones and tablets. ... Some well known derivatives include Android TV for televisions and Wear OS for wearables, both developed by Google.",
        colorsItem: Colors.green,
        img: 'assets/images/android_img.png'),
  ];
}

 */