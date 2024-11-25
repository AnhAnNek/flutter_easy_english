import 'dart:ffi';

abstract class ICategoryService {
  Future<dynamic> fetchAllCategories();
  Future<dynamic> getCategoryById(dynamic categoryId);
  Future<dynamic> createCategory(Map<String, dynamic> category);
  Future<dynamic> updateCategory(categoryId, Map<String, dynamic> category);
  Future<Void> deleteCategory(dynamic categoryId);
}