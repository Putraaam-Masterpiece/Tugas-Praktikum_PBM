import 'package:flutter/material.dart';

import '../services/api_service.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() =>
      _AddProductPageState();
}

class _AddProductPageState
    extends State<AddProductPage> {

  final nameController = TextEditingController();

  final priceController = TextEditingController();

  final descriptionController =
      TextEditingController();

  final api = ApiService();

  bool isLoading = false;

  Future<void> saveProduct() async {

    String name = nameController.text.trim();

    String priceText =
        priceController.text.trim();

    String description =
        descriptionController.text.trim();

    // VALIDASI
    if (name.isEmpty ||
        priceText.isEmpty ||
        description.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Semua field wajib diisi",
          ),
        ),
      );

      return;
    }

    // VALIDASI ANGKA
    int? price = int.tryParse(priceText);

    if (price == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Harga harus berupa angka",
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    bool success = await api.addProduct(
      name,
      price,
      description,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Produk berhasil ditambahkan",
          ),
        ),
      );

      Navigator.pop(context, true);

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Gagal tambah produk",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Tambah Produk",
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: nameController,

              decoration: const InputDecoration(
                labelText: "Nama Produk",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: priceController,

              keyboardType:
                  TextInputType.number,

              decoration: const InputDecoration(
                labelText: "Harga",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller:
                  descriptionController,

              maxLines: 4,

              decoration: const InputDecoration(
                labelText: "Deskripsi",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,
              height: 50,

              child: ElevatedButton(

                onPressed: isLoading
                    ? null
                    : saveProduct,

                child: isLoading

                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )

                    : const Text(
                        "Simpan Produk",
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}