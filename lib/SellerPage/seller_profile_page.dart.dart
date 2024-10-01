import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:smartshop/HomePage/Shop.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: SellerProfilePage()));
}

class SellerProfilePage extends StatefulWidget {
  const SellerProfilePage({Key? key}) : super(key: key);

  @override
  _SellerProfilePageState createState() => _SellerProfilePageState();
}

class _SellerProfilePageState extends State<SellerProfilePage> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDescriptionController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();

  List<Product> _products = [];
  File? _image;
  String _username = "Add your name";
  String _email = "Add your Email";

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _loadUserProfile();
  }

  Future<void> _fetchProducts() async {
    final snapshot = await FirebaseFirestore.instance.collection('Products').get();
    final products = snapshot.docs.map((doc) {
      return Product(
        id: doc.id,
        name: doc['name'],
        description: doc['description'],
        price: doc['price'],
        image: null, // Image fetching is not implemented in this example
      );
    }).toList();

    setState(() {
      _products = products;
    });
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userData.exists) {
        setState(() {
          _username = userData['username'];
          _email = userData['email'];
        });
      }
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productDescriptionController.dispose();
    _productPriceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final imageSource = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context, ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context, ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );

    if (imageSource != null) {
      final pickedFile = await ImagePicker().pickImage(source: imageSource);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    }
  }

  Future<void> _addProduct() async {
    final productName = _productNameController.text;
    final productDescription = _productDescriptionController.text;
    final productPrice = _productPriceController.text;

    if (productName.isNotEmpty &&
        productDescription.isNotEmpty &&
        productPrice.isNotEmpty) {
      final newProduct = Product(
        id: '', // Temp ID, will be replaced after adding to Firestore
        name: productName,
        description: productDescription,
        price: double.parse(productPrice),
        image: _image,
      );

      // Save to Firestore
      final docRef = await FirebaseFirestore.instance.collection('Products').add({
        'name': newProduct.name,
        'description': newProduct.description,
        'price': productPrice,
      });

      setState(() {
        _products.add(Product(
          id: docRef.id,
          name: newProduct.name,
          description: newProduct.description,
          price: newProduct.price,
          image: newProduct.image,
        ));
        _productNameController.clear();
        _productDescriptionController.clear();
        _productPriceController.clear();
        _image = null;
      });
    }
  }

  Future<void> _deleteProduct(String productId) async {
    // Remove from Firestore
    await FirebaseFirestore.instance.collection('Products').doc(productId).delete();

    // Remove from local state
    setState(() {
      _products.removeWhere((product) => product.id == productId);
    });
  }

  void _showEditProfileDialog() {
    TextEditingController usernameController = TextEditingController(text: _username);
    TextEditingController emailController = TextEditingController(text: _email);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _username = usernameController.text;
                      _email = emailController.text;
                    });

                    // Save to Firestore
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({
                      'username': _username,
                      'email': _email,
                    });

                    Navigator.of(context).pop();
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller Profile'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.logout),
          ),
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              Navigator.pushNamed(context, '/chat');
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Shop()),
              );
            },
            icon: Icon(Icons.shop),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Icon(
                          Icons.add_a_photo,
                          size: 40,
                          color: Colors.grey[400],
                        )
                      : null,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () => _showEditProfileDialog(),
                child: Text(
                  _username,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () => _showEditProfileDialog(),
                child: Text(
                  _email,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _productNameController,
                decoration: InputDecoration(
                  labelText: "Product Name",
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _productDescriptionController,
                decoration: InputDecoration(
                  labelText: "Product Description",
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _productPriceController,
                decoration: InputDecoration(
                  labelText: "Product Price",
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _addProduct,
                child: Text("Add Product"),
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Product Name')),
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('Price')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _products.map((product) {
                  return DataRow(cells: [
                    DataCell(Text(product.name)),
                    DataCell(Text(product.description)),
                    DataCell(Text('\$${product.price.toStringAsFixed(2)}')),
                    DataCell(IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteProduct(product.id),
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final File? image;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.image,
  });
}

