import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydro_app/shop/dummy_shop.dart';
import 'package:hydro_app/shop/product_listing.dart';
import 'package:hydro_app/utils.dart';

class ShopList extends StatefulWidget {
  final String category;
  const ShopList(this.category, {Key key}) : super(key: key);

  @override
  _ShopListState createState() => _ShopListState();
}

class _ShopListState extends State<ShopList> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int half = DummyShop.plantSeedData.length ~/ 2;
    List<ProductListing> half1 = [];
    List<ProductListing> half2 = [];
    for (int i = 0; i < half; i++) {
      half1.add(ProductListing.fromDict(DummyShop.plantSeedData[i]));
    }
    for (int i = half; i < DummyShop.plantSeedData.length; i++) {
      half2.add(ProductListing.fromDict(DummyShop.plantSeedData[i]));
    }
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width / 2,
            padding: EdgeInsets.only(left: 7),
            child: Column(
              children: half1,
            ),
          ),
          Container(
            width: width / 2,
            padding: EdgeInsets.only(right: 7),
            child: Column(
              children: half2,
            ),
          ),
        ],
      ),
    );
  }
}
