import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

import 'product_items.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid(
    this.showFavs, {
    super.key,
  });
  final bool showFavs;

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.favoriteItems : productsData.items;
    return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
          value: products[index],
          child: const ProductItem(
              // products[index].id,
              // products[index].title,
              // products[index].imageUrl,
              ),
        ),
        itemCount: products.length,
      ),
    );
  }
}
