import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartshop/BuyerProfile/buyer_profile_page.dart';
import 'package:smartshop/Dashboard/DashboardPage.dart';
import 'package:smartshop/SellerPage/seller_profile_page.dart';
import 'package:smartshop/AdminPage/dashboard_page.dart';
import 'package:smartshop/SellerPage/seller_profile_page.dart.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();

    Future<void> _login() async {
      try {
        // Fetch admin credentials from Firestore
        QuerySnapshot adminQuery = await FirebaseFirestore.instance
            .collection('Admin')
            .where('Email', isEqualTo: _emailController.text.trim())
            .where('Password', isEqualTo: _passwordController.text.trim())
            .get();

        if (adminQuery.docs.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage()),
          );
          return;
        }

        // Proceed with Firebase Authentication for buyers and sellers
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        String userId = userCredential.user!.uid;
        DocumentSnapshot sellerDoc =
            await FirebaseFirestore.instance.collection('Seller').doc(userId).get();
        DocumentSnapshot buyerDoc =
            await FirebaseFirestore.instance.collection('Buyer').doc(userId).get();

        if (sellerDoc.exists) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SellerProfilePage()),
          );
        } else if (buyerDoc.exists) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BuyerProfilePage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User data not found')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue,
              Colors.red,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: screenHeight * 0.1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Login", style: TextStyle(color: Colors.white, fontSize: 40)),
                  SizedBox(height: screenHeight * 0.01),
                  Text("Welcome to Smart Shop", style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.08),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: screenHeight * 0.05),
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.05),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(32, 30, 30, 0.3),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(screenWidth * 0.02),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey)),
                              ),
                              child: TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(screenWidth * 0.02),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey)),
                              ),
                              child: TextField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                                obscureText: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      Text("Forgot Password?", style: TextStyle(color: Colors.grey)),
                      SizedBox(height: screenHeight * 0.03),
                      GestureDetector(
                        onTap: _login,
                        child: Container(
                          height: screenHeight * 0.07,
                          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.orange[900],
                          ),
                          child: Center(
                            child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      Text("Join With us", style: TextStyle(color: Colors.grey)),
                      SizedBox(height: screenHeight * 0.03),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _launchURL("https://www.facebook.com/profile.php?id=61560386961151&mibextid=ZbWKwL"),
                              child: Container(
                                height: screenHeight * 0.07,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.blue,
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.facebook, color: Colors.white),
                                      SizedBox(width: screenWidth * 0.02),
                                      Text("Facebook", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.05),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _launchURL("https://www.instagram.com/smartshopmobile?igsh=YzljYTk1ODg3Zg=="),
                              child: Container(
                                height: screenHeight * 0.07,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.black,
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.camera_alt, color: Colors.white),
                                      SizedBox(width: screenWidth * 0.02),
                                      Text("Instagram", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
