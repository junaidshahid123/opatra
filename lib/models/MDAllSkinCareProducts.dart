class MDSkinCareProductsA {
  final List<Product>? products;

  MDSkinCareProductsA({this.products});

  factory MDSkinCareProductsA.fromJson(Map<String, dynamic> json) {
    return MDSkinCareProductsA(
      products: (json['products'] as List?)
          ?.map((item) => Product.fromJson(item))
          .toList(),
    );
  }
}

class Product {
  final int? id;
  final String? title;
  final String? bodyHtml;
  final String? vendor;
  final String? productType;
  final String? createdAt;
  final String? handle;
  final String? updatedAt;
  final String? publishedAt;
  final String? publishedScope;
  final String? tags;
  final String? status;
  final List<ProductImage>? images;
  final ProductImage? image;

  Product({
    this.id,
    this.title,
    this.bodyHtml,
    this.vendor,
    this.productType,
    this.createdAt,
    this.handle,
    this.updatedAt,
    this.publishedAt,
    this.publishedScope,
    this.tags,
    this.status,
    this.images,
    this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      bodyHtml: json['body_html'],
      vendor: json['vendor'],
      productType: json['product_type'],
      createdAt: json['created_at'],
      handle: json['handle'],
      updatedAt: json['updated_at'],
      publishedAt: json['published_at'],
      publishedScope: json['published_scope'],
      tags: json['tags'],
      status: json['status'],
      images: (json['images'] as List?)
          ?.map((item) => ProductImage.fromJson(item))
          .toList(),
      image: json['image'] != null
          ? ProductImage.fromJson(json['image'])
          : null,
    );
  }
}

class ProductImage {
  final int? id;
  final String? src;

  ProductImage({
    this.id,
    this.src,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      src: json['src'],
    );
  }
}
