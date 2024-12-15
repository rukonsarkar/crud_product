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
        product.image ?? 'https://th.bing.com/th/id/OIP.vDk8ci5k0hlsbP2p_jLHkAHaE8?w=262&h=180&c=7&r=0&o=5&pid=1.7', width: 60,
      ),
      title: Text(product.productName ?? '', style: TextStyle(fontWeight: FontWeight.bold),),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Code : ${product.productCode}' ?? ''),
          Text('Quantity : ${product.quantity}' ?? ''),
          Text('Price : ${product.unitPrice}' ?? ''),
          Text('Total : ${product.totalPrice}' ?? ''),
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
