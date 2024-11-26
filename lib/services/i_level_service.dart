abstract class ILevelService {
  Future<dynamic> fetchAllLevels();
  Future<dynamic> getLevelById(dynamic levelId);
  Future<dynamic> createLevel(Map<String, dynamic> level);
  Future<dynamic> updateLevel(levelId, Map<String, dynamic> level);
  Future<dynamic> deleteLevel(dynamic levelId);
  Future<dynamic> fetchAllLevelByTopic(dynamic level);
}