abstract class IOrderService {
  Future getOrdersByUsername(username, page, size);
  Future getOrderItemsByOrderId(orderId, page, size);
  Future updateOrderStatus(orderId, status);
  Future getOrdersForAdmin(page, size);
}