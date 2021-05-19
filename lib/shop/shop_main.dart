import 'package:flutter/material.dart';
import 'package:hydro_app/shop/shop_list.dart';
import 'package:hydro_app/utils.dart';

class ShopMain extends StatefulWidget {
  const ShopMain({Key key}) : super(key: key);

  @override
  _ShopMainState createState() => _ShopMainState();
}

class _ShopMainState extends State<ShopMain>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Hydroponics ",
              style: TextStyle(color: Colors.blue[800], fontSize: 30),
            ),
            Text("Shop", style: TextStyle(fontSize: 30),),
            Spacer(),
            Icon(Icons.shopping_cart),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: width * 0.8,
                margin: EdgeInsets.only(right: 10),
                height: 40,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Search...",
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),
              Icon(Icons.search),
            ],
          ),
          TabBar(
            controller: _controller,
            indicatorColor: Colors.green,
            tabs: [
              Tab(
                text: "Plants/Seeds",
              ),
              Tab(text: "Nutrients"),
              Tab(text: "Parts"),
            ],
          ),
          Container(height: 10),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: [
                ShopList("seeds"),
                ShopList("food"),
                ShopList("parts"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
