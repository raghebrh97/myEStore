import 'package:flutter/services.dart';
import 'package:my_e_store/data/categories_repos.dart';
import 'package:my_e_store/data/order_repository.dart';
import 'package:my_e_store/data/product_review_repository.dart';
import 'package:my_e_store/data/products_repos.dart';
import 'package:my_e_store/data/users_repository.dart';
import 'package:my_e_store/logic/cart_cubit.dart';
import 'package:my_e_store/logic/categories_cubit.dart';
import 'package:my_e_store/logic/google_signIn_cubit.dart';
import 'package:my_e_store/logic/orders_cubit.dart';
import 'package:my_e_store/logic/product_reviews_cubit.dart';
import 'package:my_e_store/logic/products_cubit.dart';
import 'package:my_e_store/logic/users_cubit.dart';
import 'package:my_e_store/screens/cart_screen.dart';
import 'package:my_e_store/screens/categories_screen.dart';
import 'package:my_e_store/screens/home_screen.dart';
import 'package:my_e_store/screens/order_status_screen.dart';
import 'package:my_e_store/screens/product_details.dart';
import 'package:my_e_store/screens/products_screen.dart';
import 'package:my_e_store/screens/user_auth_screen.dart';
import 'package:my_e_store/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_e_store/screens/user_reviews_screen.dart';
import 'package:my_e_store/widgets/checkout_widget.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UsersCubit>(
            create: (ctx) => UsersCubit(UsersRepository())),
        BlocProvider<GoogleCubit>(create: (ctx)=> GoogleCubit(UsersRepository()),),
        BlocProvider<CategoriesCubit>(create: (ctx)=> CategoriesCubit(CategoriesRepo()),),
        BlocProvider<ProductsCubit>(create: (ctx)=> ProductsCubit(ProductsRepository()),),
        BlocProvider<ProductReviewsCubit>(create: (ctx)=> ProductReviewsCubit(ProductReviewRepository()),),
        BlocProvider<CartCubit>(create: (ctx) => CartCubit(),),
        BlocProvider<OrdersCubit>(create: (ctx)=>OrdersCubit(OrdersRepository()),),
      ],
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: Color.fromRGBO(52, 73, 94, 1),
            backgroundColor: Color.fromRGBO(52, 73, 94, 1),
            accentColor: Colors.white,
            textTheme: TextTheme(headline6: TextStyle(color: Colors.black))),
        title: 'E-Store App',
        home: FutureBuilder(
            future: Firebase.initializeApp(),
            builder: (ctx, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting)
                return MySplashScreen();
              else
                return Scaffold(
                    body: FirebaseAuth.instance.currentUser == null
                        ? UserAuthScreen()
                        : HomeScreen());
            }),
        routes: {
          HomeScreen.homeScreenRoute : (_)=> HomeScreen(),
          CategoriesScreen.categoriesRoute : (_)=> CategoriesScreen(),
          ProductsScreen.productsScreenRoute : (_)=> ProductsScreen(),
          ProductDetails.detailsRoute : (_)=> ProductDetails(),
          UserReviewsScreen.reviewsRoute : (_)=> UserReviewsScreen(),
          CartScreen.cartScreenRoute: (_) => CartScreen(),
          UserAuthScreen.userAuthRoute: (_)=> UserAuthScreen(),
          MySplashScreen.splashRoute : (_) => MySplashScreen(),
          CheckOutWidget.checkOutRoute: (_) => CheckOutWidget(),
          OrderStatusScreen.ordersStatusRoute : (_)=> OrderStatusScreen(),
        },
      ),
    );
  }
}
