import 'package:flutter/material.dart';
import 'package:smartshop/SellerPage/seller_profile_page.dart.dart';

class NewProductPage extends StatefulWidget {
  @override
  _NewProductPageState createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your logic to save the new product
                String title = titleController.text;
                String description = descriptionController.text;
                // You can then pass this data to your backend or wherever you're managing your listings
                // For simplicity, let's just print the data for now
                print('Title: $title, Description: $description');
                // After adding the product, you might want to navigate back to the previous page
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

// Update the routes in the main app widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewProductPage(),
      routes: {
        '/addListing': (context) => SellerProfilePage(),
        '/newProduct': (context) => NewProductPage(), // Route for adding new product
      },
    );
  }
}

void main() {
  runApp(MyApp());
}
