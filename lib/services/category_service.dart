import 'dart:ffi';

import 'package:flutter_easy_english/services/i_category_service.dart';
import 'package:flutter_easy_english/utils/http_request.dart';

class CategoryService extends ICategoryService {
  final String SUFFIX_CATE = '/v1/categories';

  @override
  Future<dynamic> createCategory(Map<String, dynamic> category) async {
    final response = await HttpRequest.postReturnDynamic('$SUFFIX_CATE/add', category);
    return response;
  }

  @override
  Future<Void> deleteCategory(categoryId) async {
    return await HttpRequest.deleteReturnDynamic('$SUFFIX_CATE/delete/$categoryId');
  }

  @override
  Future<dynamic> fetchAllCategories() async {
    final response = await HttpRequest.getReturnDynamic('$SUFFIX_CATE/get-all');
    return response;
  }

  @override
  Future<dynamic> getCategoryById(categoryId) async {
    final response = await HttpRequest.getReturnDynamic('$SUFFIX_CATE/get-by-id/$categoryId}');
    return response;
  }

  @override
  Future<dynamic> updateCategory(categoryId, Map<String, dynamic> category) async {
    final response = await HttpRequest.putReturnDynamic('$SUFFIX_CATE/update/$categoryId', category);
    return response;
  }
}