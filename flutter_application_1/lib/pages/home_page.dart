import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'add_product_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final api = ApiService();

  List products = [];

  bool isLoading = true;

  Future<void> loadProducts() async {

    final data = await api.getProducts();

    print("DATA PRODUCTS : $data");

    setState(() {

      products = data;

      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    loadProducts();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Katalog Produk"),
      ),

      // ================= BUTTON TAMBAH =================

      floatingActionButton: FloatingActionButton(

        onPressed: () async {

          final result = await Navigator.push(

            context,

            MaterialPageRoute(
              builder: (_) => const AddProductPage(),
            ),
          );

          // REFRESH LIST
          if (result == true) {

            loadProducts();
          }
        },

        child: const Icon(Icons.add),
      ),

      // ================= BODY =================

      body: isLoading

          ? const Center(
              child: CircularProgressIndicator(),
            )

          : products.isEmpty

              ? const Center(
                  child: Text(
                    "Belum ada produk",
                    style: TextStyle(fontSize: 18),
                  ),
                )

              : RefreshIndicator(

                  onRefresh: loadProducts,

                  child: ListView.builder(

                    itemCount: products.length,

                    itemBuilder: (context, index) {

                      final item = products[index];

                      return Card(

                        margin: const EdgeInsets.all(10),

                        child: ListTile(

                          title: Text(
                            item['name']
                                    ?.toString() ??
                                '-',
                          ),

                          subtitle: Text(
                            item['description']
                                    ?.toString() ??
                                '-',
                          ),

                          trailing: Text(
                            "Rp ${item['price']?.toString() ?? '0'}",
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}