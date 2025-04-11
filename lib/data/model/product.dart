class Product {
  final int id;
  final String? name;
  final String? image;
  final String? background;
  final String? gridImage;
  final String? model;
  final String? externalLink;
  bool? isInUserProducts;
  bool? isLiked;
  final int? createdAt;
  final int? updatedAt;
  final String? brandImage;
  int? defaultZoomLevel;
  final bool hasInfoBlock;

  Product({
    required this.id,
    this.name,
    this.image,
    this.background,
    this.model,
    this.isInUserProducts,
    this.isLiked,
    this.createdAt,
    this.updatedAt,
    this.gridImage,
    this.externalLink,
    this.brandImage,
    this.defaultZoomLevel,
    this.hasInfoBlock = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      background: json['background'],
      gridImage: json['gridImage'],
      model: json['model'],
      isInUserProducts: json['isInUserProducts'],
      isLiked: json['isLiked'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      externalLink: json['externalLink'],
      brandImage: json['brandImage'],
      defaultZoomLevel: json['defaultZoomLevel'],
      hasInfoBlock: json['hasInfoBlock'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['background'] = background;
    data['gridImage'] = gridImage;
    data['model'] = model;
    data['isInUserProducts'] = isInUserProducts;
    data['isLiked'] = isLiked;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['externalLink'] = externalLink;
    data['brandImage'] = brandImage;
    data['defaultZoomLevel'] = defaultZoomLevel;
    data['hasInfoBlock'] = hasInfoBlock;
    return data;
  }
}
