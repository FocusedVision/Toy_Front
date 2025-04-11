class User {
  int? id;
  String? name;
  String? image;
  int? likesCount;
  int? productsCount;
  String? deviceId;
  int? createdAt;
  int? updatedAt;

  User(
      {this.id,
      this.name,
      this.image,
      this.likesCount,
      this.productsCount,
      this.deviceId,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    likesCount = json['likesCount'];
    productsCount = json['productsCount'];
    deviceId = json['deviceId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['likesCount'] = this.likesCount;
    data['productsCount'] = this.productsCount;
    data['deviceId'] = this.deviceId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
