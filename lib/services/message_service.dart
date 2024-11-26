import 'package:flutter_easy_english/services/i_message_service.dart';
import 'package:flutter_easy_english/utils/http_request.dart';

class MessageService extends IMessageService {
  final String SUFFIX_MESSAGE = '/v1/messages';

  @override
  Future getAllMessages(senderUsername, recipientUsername, page, size) async {
    final response = await HttpRequest
        .getReturnDynamic('$SUFFIX_MESSAGE/${senderUsername}/${recipientUsername}?page=${page}&&size=${size}');
    return response;
  }

  @override
  Future getRecentChats(page, size) async {
    final response = await HttpRequest
        .getReturnDynamic('$SUFFIX_MESSAGE/get-recent-chats?page=${page}&&size=${size}');
    return response;
  }
}