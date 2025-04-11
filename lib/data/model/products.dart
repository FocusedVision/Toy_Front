import 'package:virtual_toy_shop/data/model/pagination.dart';
import 'package:virtual_toy_shop/data/model/product.dart';

class Products {
  Pagination? pagination;
  List<Product>? items;

  Products({this.pagination, this.items});

  Products.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['items'] != null) {
      items = <Product>[];
      json['items'].forEach((v) {
        items!.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
