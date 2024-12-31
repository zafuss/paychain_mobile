import '../Model/ProductResponse.dart';
import '../Parameters.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class ProductService {
  static Future<ProductResponse> getProduct(int pageIndex, int pageSize) async {
    String urlStr = Parameters.baseUrl +
        Parameters.allProduct +
        "?pageIndex=${pageIndex}&pageSize=${pageSize}";
    var url = Uri.parse(urlStr);

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    ProductResponse productResponse = ProductResponse();
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      //var itemCount = jsonResponse['totalItems'];
      //print('Number of books about http: $itemCount.');
      productResponse = ProductResponse.fromJson(jsonResponse);
      return productResponse;
    }
    productResponse.statusCode = response.statusCode;
    return productResponse;
  }
}
