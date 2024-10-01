import 'package:flutter/material.dart';

// Assume you have a model class for the listings
class Listing {
  final String title;
  final String description;

  Listing({required this.title, required this.description});
}

class ListingsPage extends StatelessWidget {
  // Assume you have a list of listings coming from your backend
  final List<Listing> listings = [
    Listing(title: "Example Listing 1", description: "Description 1"),
    Listing(title: "Example Listing 2", description: "Description 2"),
    Listing(title: "Example Listing 3", description: "Description 3"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listings'),
      ),
      body: ListView.builder(
        itemCount: listings.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(listings[index].title),
            subtitle: Text(listings[index].description),
          );
        },
      ),
    );
  }
}
