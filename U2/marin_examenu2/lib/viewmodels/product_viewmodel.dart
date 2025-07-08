import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductViewModel extends ChangeNotifier {
  final _service = ProductService();
  final Map<String, Product> _items = {};

  Map<String, Product> get items => _items;

  ProductViewModel() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    final data = await _service.getAllProducts();
    _items.clear();
    _items.addAll(data);
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final id = product.id.isNotEmpty ? product.id : const Uuid().v4();

    final newProduct = Product(
      id: id,
      name: product.name,
      description: product.description,
      price: product.price,
      quantity: product.quantity,
      imagePath: product.imagePath,
    );

    _items[id] = newProduct;
    await _service.saveProduct(newProduct);
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    _items[product.id] = product;
    await _service.saveProduct(product);
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    _items.remove(id);
    await _service.deleteProduct(id);
    notifyListeners();
  }

  Product? getProductById(String id) => _items[id];
}
