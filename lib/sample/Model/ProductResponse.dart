import 'BaseResponse.dart';

class ProductResponse extends BaseReesponse {
  int totalRecord = 0;
  List<Product> data = [];
  ProductResponse();
  //ProductResponse({this.status, this.message, this.totalRecord, this.data});

  ProductResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalRecord = json['totalRecord'] == null ? 0 : json['totalRecord'];
    if (json['data'] != null) {
      data = <Product>[];
      json['data'].forEach((v) {
        data!.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['totalRecord'] = this.totalRecord;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'ProductResponse{totalRecord: $totalRecord, data: $data}';
  }
}

class Product {
  String id = "";
  String name = "";
  double price = 0;
  String url = "";
  String categoryId = "";
  String categoryName = "";

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    url = json['url'];
    categoryId = json['categoryId'];
    categoryName = json['categoryName'] == null ? "" : json['categoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['url'] = this.url;
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    return data;
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, url: $url, categoryId: $categoryId, categoryName: $categoryName}';
  }
}
