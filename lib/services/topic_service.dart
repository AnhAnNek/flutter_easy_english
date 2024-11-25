import 'dart:ffi';

import 'package:flutter_easy_english/services/i_topic_service.dart';
import 'package:flutter_easy_english/utils/http_request.dart';

class TopicService extends ITopicService {
  final String SUFFIX_CATE = '/v1/categories';

  @override
  Future createTopic(Map<String, dynamic> topic) async {
    final response = await HttpRequest.postReturnDynamic('$SUFFIX_CATE/add', topic);
    return response;
  }

  @override
  Future<Void> deleteTopic(topicId) async {
    final response = await HttpRequest.deleteReturnDynamic('$SUFFIX_CATE/delete/$topicId');
    return response;
  }

  @override
  Future fetchAllTopic() async {
    final response = await HttpRequest.getReturnDynamic('$SUFFIX_CATE/get-all');
    return response;
  }

  @override
  Future getTopicById(topicId) async {
    final response = await HttpRequest.getReturnDynamic('$SUFFIX_CATE/get-by-id/$topicId}');
    return response;
  }

  @override
  Future updateTopic(topicId, Map<String, dynamic> topic) async {
    final response = await HttpRequest.putReturnDynamic('$SUFFIX_CATE/update/$topicId', topic);
    return response;
  }

}