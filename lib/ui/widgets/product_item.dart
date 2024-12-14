import 'package:crud_product/models/Product.dart';
import 'package:crud_product/ui/screens/product_list_screen.dart';
import 'package:crud_product/ui/screens/update_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        product.image ?? '',
      ),
      title: Text(product.productName ?? ''),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.productCode ?? ''),
          Text(product.quantity ?? ''),
          Text(product.unitPrice ?? ''),
          Text(product.totalPrice ?? ''),
        ],
      ),
      trailing: Wrap(
        children: [
          IconButton(
            onPressed: () {
              _deleteProduct(context);
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, UpdateProductScreen.name,
                  arguments: product);
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProduct(context) async {
    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/DeleteProduct/${product.id}');
    
    Response response = await get(uri);

    if(response.statusCode == 200){
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Product has been Deleted')));
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false,);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Product Delete failed! Try again.')));
    }

  }
}
