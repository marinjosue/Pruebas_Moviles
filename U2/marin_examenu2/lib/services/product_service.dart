import 'package:localstore/localstore.dart';
import '../models/product.dart';

class ProductService {
  final _db = Localstore.instance;
  final String _collection = 'products';

  Future<void> saveProduct(Product product) async {
    await _db.collection(_collection).doc(product.id).set(product.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }

  Future<Map<String, Product>> getAllProducts() async {
    final data = await _db.collection(_collection).get();
    if (data == null) return {};

    return data.map((key, value) => MapEntry(key, Product.fromMap(value)));
  }

  Future<Product?> getProductById(String id) async {
    final data = await _db.collection(_collection).doc(id).get();
    if (data == null) return null;
    return Product.fromMap(data);
  }
}
