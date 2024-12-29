/*
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hal_app/api/purchase_api.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:purchases_flutter/purchases_flutter.dart';

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final String _productID = 'sub_1w';
  final String _productIdApple = 'puzzle_1w';
  final String _trial1w = 'trial_1w';

  bool _available = true;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  late DateTime currentTime;
  List<PurchaseDetails> allPurcahesList = [];
  getTime() async {
    var url = Uri.parse(
        'https://timeapi.io/api/Time/current/zone?timeZone=Etc/GMT-3');
    var response = await http.get(url);



    Map valueMap = json.decode(response.body);
    DateTime dt = DateTime.parse(valueMap["dateTime"]);
    currentTime = dt;
    setState(() {});

  }

  @override
  void initState() {
    getTime();
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {




      setState(() {
        _purchases.addAll(purchaseDetailsList);
        allPurcahesList = _purchases;
        _listenToPurchaseUpdated(purchaseDetailsList);
      });
    }, onDone: () {


      _subscription!.cancel();
    }, onError: (error) {

      _subscription!.cancel();
    });

    _initialize();

    super.initState();
  }

  restoreOldPurchases() async {
    try {
      await InAppPurchase.instance.restorePurchases();
    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text((e).toString())));
    }
  }

  old() async {
    List<PurchaseDetails> getList = (await _inAppPurchase.purchaseStream.last);
    allPurcahesList = getList;
    setState(() {});
  }

  @override
  void dispose() {
    _subscription!.cancel();
    super.dispose();
  }

  void _initialize() async {
    _available = await _inAppPurchase.isAvailable();

    List<ProductDetails> products = await _getProducts(
      productIds: Set<String>.from(
        [_productID, _productIdApple, _trial1w],
      ),
    );

    setState(() {



      _products = products;
    });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          //  _showPendingUI();
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          // bool valid = await _verifyPurchase(purchaseDetails);
          // if (!valid) {
          //   _handleInvalidPurchase(purchaseDetails);
          // }
          break;
        case PurchaseStatus.error:


          // _handleError(purchaseDetails.error!);
          break;
        default:
          break;
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    });
  }

  Future<List<ProductDetails>> _getProducts(
      {required Set<String> productIds}) async {
    ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(productIds);

    return response.productDetails;
  }

  ListTile _buildProduct({required ProductDetails product}) {


    return ListTile(
      leading: Icon(Icons.attach_money),
      title: Text('${product.title} - ${product.price}'),
      subtitle: Text(product.description),
      trailing: ElevatedButton(
        onPressed: () {
          _subscribe(product: product);
        },
        child: Text('Subscribe'),
      ),
    );
  }

  ListTile _buildPurchase({required PurchaseDetails purchase}) {
    if (purchase.error != null) {
      return ListTile(
        title: Text(purchase.status.toString()),
        subtitle: Text('${purchase.error}'),
      );
    }

    String? transactionDate;
    String? dif;

    if (purchase.status == PurchaseStatus.purchased) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(purchase.transactionDate!),
      );
      transactionDate = ' @ ' + DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
      dif = date.difference(currentTime).toString();
    }
    return ListTile(
      title: Text(purchase.status.toString()),
      subtitle: Column(
        children: [
          Text('${purchase.productID} ${transactionDate ?? ''}'),
          Text('${purchase.productID} ${dif ?? ''}'),
        ],
      ),
    );
  }

  void _subscribe({required ProductDetails product}) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _inAppPurchase.buyNonConsumable(
      purchaseParam: purchaseParam,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: buildFloatingActionButton(),
      appBar: AppBar(
        title: Text('In App Purchase 1.0.9'),
      ),
      body: _available
          ? Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Current Products ${_products.length}'),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          return _buildProduct(
                            product: _products[index],
                          );
                        },
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              restoreOldPurchases();
                            },
                            child: Text('restore'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              old();
                            },
                            child: Text('old'),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ALL Purchases detail: ${allPurcahesList.length}'),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: allPurcahesList.length,
                          itemBuilder: (context, index) {
                            return _buildPurchase(
                              purchase: allPurcahesList[index],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Past Purchases detail: ${_purchases.length}'),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _purchases.length,
                          itemBuilder: (context, index) {
                            return _buildPurchase(
                              purchase: _purchases[index],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Past Purchases: ${_purchases.length}'),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _purchases.length,
                          itemBuilder: (context, index) {
                            return _buildPurchase(
                              purchase: _purchases[index],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: Text('The Store Is Not Available'),
            ),
    );
  }

  Column buildFloatingActionButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(onPressed: () {
          getTime();
        }),
        FloatingActionButton(
            onPressed: () async {
             List<Offering> offers= await PurchaseApi.fetchOffers();

            },
            child: Icon(Icons.abc)),
      ],
    );
  }
}
*/