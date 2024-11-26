abstract class ITopicService {
  Future<dynamic> fetchAllTopics();
  Future<dynamic> getTopicById(topicId);
  Future<dynamic> createTopic(Map<String, dynamic> topic);
  Future<dynamic> updateTopic(topicId, Map<String, dynamic> topic);
  Future<dynamic> deleteTopic(topicId);
}