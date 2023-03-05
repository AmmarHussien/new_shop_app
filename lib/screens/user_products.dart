import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/add_products_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

import '../providers/products_provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductsScreen({super.key});
  Future<void> _refreshProducts(BuildContext context) async {
    Provider.of<Products>(context, listen: false).fatchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddProductsScreen.routeName);
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (_, i) => Column(
              children: [
                UserProductItem(
                  title: productsData.items[i].title,
                  imageUrl: productsData.items[i].imageUrl,
                  id: productsData.items[i].id,
                ),
                const Divider(),
              ],
            ),
            itemCount: productsData.items.length,
          ),
        ),
      ),
    );
  }
}
