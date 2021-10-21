import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class MyApp6 extends StatelessWidget {
  const MyApp6({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage6(),
    );
  }
}
class HomePage6 extends StatefulWidget {
  const HomePage6({Key? key}) : super(key: key);

  @override
  _HomePage6State createState() => _HomePage6State();
}

class _HomePage6State extends State<HomePage6> {
  late Future<List<Product>> lsProduct;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lsProduct=Product.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: lsProduct,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData){
            List<Product> data = snapshot.data;
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index){
                  var product = data[index];
                  return ListTile(
                      leading:Image.network(product.image),
                      title:  Text(product.title),
                      trailing: IconButton(onPressed: (){},icon: Icon(Icons.add_shopping_cart_outlined))
                  );

                });
          }
          else
            return Center(child: CircularProgressIndicator());
        },

      ),
    );
  }
}

class Rate{
  final double rate;
  final int count;

  Rate(this.rate, this.count);
}
class Product{
  //{"id":1,
  //"title":"Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
  //"price":109.95,
  //"description":"Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
  //"category":"men's clothing",
  //"image":"https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
  //"rating":{"rate":3.9,"count":120}},

  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Map rating;

  Product(this.id, this.title, this.price, this.description, this.category, this.image, this.rating);


  static Future<List<Product>> fetchData() async {
    String url ="https://fakestoreapi.com/products";
    var client = http.Client();
    var response = await client.get(Uri.parse(url));

    if(response.statusCode==200){
      var result = response.body;
      var jsonData=jsonDecode(result);
      List<Product> lsProduct=[];
      for(var item in jsonData){
        print(item);
        var id = item['id'];
        var title = item['title'];
        var price = item['price'];
        var description = item['description'];
        var category = item['category'];
        var image = item['image'];
        var rating = item['rating'];

        Product p = new Product(id, title, price, description, category, image, rating);
        lsProduct.add(p);
      }
      return lsProduct;
    }else{
      print(response.statusCode);
      throw Exception("Loi lay du lieu");
    }
  }
}


