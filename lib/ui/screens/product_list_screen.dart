import 'dart:convert';

import 'package:crud_product/models/Product.dart';
import 'package:crud_product/ui/screens/add_new_product_screen.dart';
import 'package:crud_product/ui/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> productList = [];
  bool _getProductInProgress = false;

  @override
  void initState() {
    super.initState();
    _getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          IconButton(onPressed: (){
            _getProductList();
          }, icon: const Icon(Icons.refresh))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _getProductList();
        },
        child: Visibility(
          visible: _getProductInProgress == false,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: ListView.builder(
            itemCount: productList.length,
            itemBuilder: (context, index) {
              return ProductItem(product: productList[index],);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddNewProductScreen.name);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _getProductList() async {
    productList.clear();
    _getProductInProgress = true;
    setState(() {});

    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/ReadProduct');

    Response response = await get(uri);

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      for (Map<String, dynamic> p in decodedData['data']) {
        Product product = Product(
          p['_id'],
          p['ProductName'],
          p['ProductCode'],
          p['UnitPrice'],
          p['Qty'],
          p['TotalPrice'],
          p['CreatedDate'],
          p['Img'],
        );
        productList.add(product);
        setState(() {});
      }
    }
    _getProductInProgress = false;
    setState(() {});
  }
}
