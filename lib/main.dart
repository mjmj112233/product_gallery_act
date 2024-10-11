import 'package:flutter/material.dart';

void main() {
  runApp(ProductGalleryApp());
}

class ProductGalleryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProductGalleryScreen(),
    );
  }
}

class ProductGalleryScreen extends StatefulWidget {
  @override
  _ProductGalleryScreenState createState() => _ProductGalleryScreenState();
}

class _ProductGalleryScreenState extends State<ProductGalleryScreen> {
  // Sample product data with placeholder images
  final List<Map<String, dynamic>> products = [
    {'name': 'Smartphone', 'price': 699.99, 'description': 'A high-end smartphone.', 'image': 'https://via.placeholder.com/150?text=Smartphone'},
    {'name': 'Laptop', 'price': 1199.99, 'description': 'A powerful laptop.', 'image': 'https://via.placeholder.com/150?text=Laptop'},
    {'name': 'Headphones', 'price': 199.99, 'description': 'Noise-cancelling headphones.', 'image': 'https://via.placeholder.com/150?text=Headphones'},
    {'name': 'Smartwatch', 'price': 299.99, 'description': 'A smartwatch.', 'image': 'https://via.placeholder.com/150?text=Smartwatch'},
    {'name': 'Camera', 'price': 899.99, 'description': 'A digital camera.', 'image': 'https://via.placeholder.com/150?text=Camera'},
    {'name': 'Tablet', 'price': 499.99, 'description': 'A lightweight tablet.', 'image': 'https://via.placeholder.com/150?text=Tablet'},
    {'name': 'Speaker', 'price': 149.99, 'description': 'A portable speaker.', 'image': 'https://via.placeholder.com/150?text=Speaker'},
    {'name': 'Drone', 'price': 799.99, 'description': 'A 4K drone.', 'image': 'https://via.placeholder.com/150?text=Drone'},
  ];

  int currentPage = 0;
  final int itemsPerPage = 4;

  @override
  Widget build(BuildContext context) {
    // Calculate the current range of items to display
    final int totalPages = (products.length / itemsPerPage).ceil();
    final startIndex = currentPage * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage < products.length)
        ? startIndex + itemsPerPage
        : products.length;

    final currentProducts = products.sublist(startIndex, endIndex);

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Gallery'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: currentProducts.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to Product Details Screen when tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            product: currentProducts[index],
                          ),
                        ),
                      );
                    },
                    child: ProductCard(
                      name: currentProducts[index]['name'],
                      price: currentProducts[index]['price'],
                      imageUrl: currentProducts[index]['image'],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            // Pagination controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: currentPage > 0
                      ? () {
                    setState(() {
                      currentPage--;
                    });
                  }
                      : null,
                ),
                TextButton(
                  onPressed: () {
                    // Show page selection dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return PageSelectorDialog(
                          currentPage: currentPage,
                          totalPages: totalPages,
                          onPageSelected: (int selectedPage) {
                            setState(() {
                              currentPage = selectedPage;
                            });
                          },
                        );
                      },
                    );
                  },
                  child: Text(
                    'Page ${currentPage + 1} of $totalPages',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: currentPage < totalPages - 1
                      ? () {
                    setState(() {
                      currentPage++;
                    });
                  }
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final String imageUrl;

  ProductCard({
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      shadowColor: Colors.grey.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductDetailsScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  product['image'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              product['name'],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '\$${product['price'].toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              product['description'],
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageSelectorDialog extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageSelected;

  PageSelectorDialog({
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Page'),
      content: Container(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: totalPages,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text('Page ${index + 1}'),
              onTap: () {
                onPageSelected(index);
                Navigator.pop(context);
              },
              selected: index == currentPage,
              selectedTileColor: Colors.blue.shade100,
            );
          },
        ),
      ),
    );
  }
}
