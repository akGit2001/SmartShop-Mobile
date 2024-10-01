import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// void main() => runApp(
//       MaterialApp(debugShowCheckedModeBanner: false, home: Shop()),
//     );

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(
//     MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Shop(),
//     ),
//   );
// }

class Shop extends StatefulWidget {
  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 40),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.notifications_none, color: Colors.black),
                          onPressed: () => {},
                        ),
                        IconButton(
                          icon: Icon(Icons.shopping_cart, color: Colors.black),
                          onPressed: () => {},
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Transform(
                      transform: Matrix4.rotationX(0.1),
                      child: Text(
                        "Products of Us",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 3.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // GridView.count(
                //   crossAxisCount: 2,
                //   crossAxisSpacing: 10,
                //   mainAxisSpacing: 10,
                //   shrinkWrap: true,
                //   physics: NeverScrollableScrollPhysics(),
                //   children: <Widget>[
                //     Container(
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(20),
                //         color: Colors.white,
                //         boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10, offset: Offset(0, 10))],
                //       ),
                //       child: Stack(
                //         children: <Widget>[
                //           Positioned(
                //             bottom: 20,
                //             left: 20,
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: <Widget>[
                //                 Text(
                //                   'JBL Handfree',
                //                   style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                //                 ),
                //                 SizedBox(height: 10),
                //                 Text(
                //                   '20\$',
                //                   style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                //                 ),
                //               ],
                //             ),
                //           ),
                //           Positioned(
                //             top: 20,
                //             right: 20,
                //             child: Container(
                //               width: 35,
                //               height: 35,
                //               decoration: BoxDecoration(
                //                 shape: BoxShape.circle,
                //                 color: Colors.white,
                //               ),
                //               child: Center(
                //                 child: Icon(Icons.favorite_border, size: 20),
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //     // Add more items as needed
                //   ],
                // ),

                  StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('Products').snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: snapshot.data!.docs.map((document) {
                        if (document.exists) {
                          final data = document.data() as Map<String, dynamic>?;
                          final name = data?['name'] ?? 'Unknown';
                          final price = data?['price'] ?? 'Unknown';
                          final description = data?['description'] ?? 'No description';

                          print(name);
                          print(price);
                          print(description);

                          return ProductCard(
                            name: name,
                            price: price,
                            description: description,
                          );
                        } else {
                          return Container();
                        }
                      }).toList(),
                    );


                  }
             
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String description;

  ProductCard({
    required this.name,
    required this.price,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10, offset: Offset(0, 10))],
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  '$price\$',
                  style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Icon(Icons.favorite_border, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}