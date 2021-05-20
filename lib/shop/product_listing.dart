import 'package:flutter/material.dart';
import 'package:hydro_app/utils.dart';

class ProductListing extends StatelessWidget {
  final String name;
  final String price;
  final String img_url;

  const ProductListing(this.name, this.price, this.img_url, {Key key})
      : super(key: key);

  ProductListing.fromDict(Map<String, String> data)
      : name = data["name"],
        price = data["price"],
        img_url = data["img_url"];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double boxWidth = width / 2 * 0.89;
    return Container(
      width: boxWidth,
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.lightGreen[100].withAlpha(150),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.green[100],
            offset: const Offset(0.0, 0.0),
          ),
          BoxShadow(
            color: Colors.white,
            offset: const Offset(0.0, 0.0),
            spreadRadius: -13.0,
            blurRadius: 13.0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: boxWidth / 2,
                margin: EdgeInsets.only(left: 2),
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Image(
                  width: 50,
                  fit: BoxFit.fitWidth,
                  image: NetworkImage(
                      img_url),
                ),
              ),
              Expanded(
                child: Container(
                  width: boxWidth / 2,
                  child: Text(
                     name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(height: 5),
          Row(
            children: [
              Container(width: 8),
              Text(
                "Starting at: ",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "\$$price",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontFamily: "Nunito",
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(width: 8),
              Text(
                "Check listings >",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.blue[800],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
