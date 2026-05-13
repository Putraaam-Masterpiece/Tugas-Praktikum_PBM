import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {

  final String baseUrl = "https://task.itprojects.web.id";

  final FlutterSecureStorage storage =
      const FlutterSecureStorage();

  // ================= LOGIN =================

  Future<bool> login(
    String username,
    String password,
  ) async {

    try {

      print("USERNAME : $username");
      print("PASSWORD : $password");

      final url = Uri.parse(
        '$baseUrl/api/auth/login',
      );

      final response = await http.post(

        url,

        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },

        body: jsonEncode({

          "username": username.trim(),
          "password": password.trim(),

        }),

      ).timeout(
        const Duration(seconds: 20),
      );

      print("STATUS CODE : ${response.statusCode}");
      print("RESPONSE BODY : ${response.body}");

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        final token = data['data']['token'];

        if (token != null) {

          await storage.write(
            key: 'token',
            value: token,
          );

          print("TOKEN BERHASIL DISIMPAN");

          return true;
        }
      }

      return false;

    } catch (e) {

      print("ERROR LOGIN : $e");

      return false;
    }
  }

  // ================= GET TOKEN =================

  Future<String?> getToken() async {

    return await storage.read(
      key: 'token',
    );
  }

  // ================= GET PRODUCTS =================

  Future<List<dynamic>> getProducts() async {

  try {

    String? token = await getToken();

    print("TOKEN GET : $token");

    final url = Uri.parse(
      '$baseUrl/api/products',
    );

    final response = await http.get(

      url,

      headers: {

        'Authorization': 'Bearer $token',
        'Accept': 'application/json',

      },
    );

    print("STATUS GET : ${response.statusCode}");

    print("BODY GET : ${response.body}");

    final data = jsonDecode(response.body);

    // AMBIL LIST PRODUCTS
    return data['data']['products'];

  } catch (e) {

    print("ERROR GET PRODUCTS : $e");

    return [];
  }
}

  // ================= ADD PRODUCT =================

  Future<bool> addProduct(
    String name,
    int price,
    String description,
  ) async {

    try {

      String? token = await getToken();

      print("TOKEN : $token");

      final url = Uri.parse(
        '$baseUrl/api/products',
      );

      final response = await http.post(

        url,

        headers: {

          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',

        },

        body: jsonEncode({

          "name": name,
          "price": price,
          "description": description,

        }),
      );

      print(
        "STATUS CODE ADD : ${response.statusCode}",
      );

      print(
        "BODY ADD : ${response.body}",
      );

      // SUCCESS
      if (response.statusCode == 200 ||
          response.statusCode == 201) {

        return true;
      }

      return false;

    } catch (e) {

      print("ERROR ADD PRODUCT : $e");

      return false;
    }
  }
}