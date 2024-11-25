import 'dart:ffi';

abstract class ITopicService {
  Future<dynamic> fetchAllTopic();
  Future<dynamic> getTopicById(topicId);
  Future<dynamic> createTopic(Map<String, dynamic> topic);
  Future<dynamic> updateTopic(topicId, Map<String, dynamic> topic);
  Future<Void> deleteTopic(topicId);
}