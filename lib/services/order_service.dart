import 'package:flutter_easy_english/services/i_order_service.dart';
import 'package:flutter_easy_english/utils/http_request.dart';

class OrderService extends IOrderService {
  final String SUFFIX_ORDER = '/v1/orders';

  @override
  Future getOrderItemsByOrderId(orderId, page, size) async {
    String url = '$SUFFIX_ORDER/$orderId/items?page=$page&&size=$size';
    final response = await HttpRequest.getReturnDynamic(url);
    return response;
  }

  @override
  Future getOrdersByUsername(username, page, size) async {
    String url = '$SUFFIX_ORDER/${username}?page=$page&&size=$size';
    final response = await HttpRequest.getReturnDynamic(url);
    return response;
  }

  @override
  Future updateOrderStatus(orderId, status) async {
    String url = '$SUFFIX_ORDER/admin/update-status/$orderId/$status';
    final response = await HttpRequest.putReturnDynamic(url, null);
    return response;
  }

  @override
  Future getOrdersForAdmin(page, size) async {
    String url = '$SUFFIX_ORDER/admin/get?page=$page&&size=$size';
    final response = await HttpRequest.getReturnDynamic(url);
    return response;
  }
}