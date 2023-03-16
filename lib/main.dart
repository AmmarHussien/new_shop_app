import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/add_products_screen.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_products_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/user_products.dart';

void main() {
  //Provider.debugCheckInvalidValueType = null;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, auth, previousProducts) => Products(
            auth.token!,
            auth.userId!,
            previousProducts == null ? [] : previousProducts.items,
          ),
          create: (context) => Products(
            '',
            '',
            [],
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(
            '',
            '',
            [],
          ),
          update: (context, auth, previous) => Orders(
            auth.token!,
            auth.userId!,
            previous!.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                  .copyWith(secondary: Colors.deepOrange),
              fontFamily: 'Lato'),
          debugShowCheckedModeBanner: false,
          home:
              auth.isAuth ? const ProductsOverviewScreen() : const AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (context) =>
                const ProductDetailScreen(),
            CartScreen.routeName: (context) => const CartScreen(),
            OrderScreen.routeName: (context) => const OrderScreen(),
            UserProductsScreen.routeName: (context) =>
                const UserProductsScreen(),
            EditProductsScreen.routeName: (context) =>
                const EditProductsScreen(),
            AddProductsScreen.routeName: (context) => const AddProductsScreen(),
          },
        ),
      ),
    );
  }
}
