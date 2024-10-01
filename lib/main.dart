import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:smartshop/BuyerProfile/buyer_profile_page.dart';
import 'package:smartshop/Dashboard/DashboardPage.dart';
import 'package:smartshop/HomePage/Shop.dart';
import 'package:smartshop/Login/Login.dart';
import 'package:smartshop/Products/ListingsPage.dart';
import 'package:smartshop/Products/NewProductPage.dart';
import 'package:smartshop/SellerPage/seller_profile_page.dart.dart';
import 'package:smartshop/Sign%20up/SignupPage.dart';
import 'package:smartshop/chatbot.dart/chatbot.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

if(kIsWeb){
  await  Firebase.initializeApp(options: FirebaseOptions(
  apiKey: "AIzaSyAHkGuyGcWbO9eZVIwSSkMg0yQVPMi7SFE",
  authDomain: "fire-setup-26fb8.firebaseapp.com",
  projectId: "fire-setup-26fb8",
  storageBucket: "fire-setup-26fb8.appspot.com",
  messagingSenderId: "414549019692",
  appId: "1:414549019692:web:72f6720d91687e97a95589"));

}else{
 await Firebase.initializeApp();
}

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 0, 0)),
        useMaterial3: true,
      ),
      home: SignUpPage(),
       //home: LoginPage(),
       //home: DashboardPage(),
       //home: BuyerProfilePage(),
       //home: SellerProfilePage(),
       //home: ChatScreen(),
       //home: NewProductPage(),
       //home: ListingsPage(),
       //home: Shop(),
      
       
       routes: {
        '/chat': (context) => ChatScreen(),
       }
    );
  }
}
