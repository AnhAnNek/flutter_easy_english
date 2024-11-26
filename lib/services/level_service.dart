import 'package:flutter_easy_english/services/i_level_service.dart';
import 'package:flutter_easy_english/utils/http_request.dart';

class LevelService extends ILevelService {
  final String SUFFIX_LEVEL = '/v1/levels';

  @override
  Future createLevel(Map<String, dynamic> level) async {
    final response = await HttpRequest.postReturnDynamic('$SUFFIX_LEVEL/add', level);
    return response;
  }

  @override
  Future<dynamic> deleteLevel(levelId) async {
    return await HttpRequest.deleteReturnDynamic('$SUFFIX_LEVEL/delete/$levelId');
  }

  @override
  Future fetchAllLevelByTopic(level) async {
    final response = await HttpRequest.postReturnDynamic('$SUFFIX_LEVEL/get-all-level-by-topic', level);
    return response;
  }

  @override
  Future fetchAllLevels() async {
    final response = await HttpRequest.getReturnDynamic('$SUFFIX_LEVEL/get-all');
    return response;
  }

  @override
  Future getLevelById(levelId) async {
    final response = await HttpRequest.getReturnDynamic('$SUFFIX_LEVEL/get-by-id/$levelId}');
    return response;
  }

  @override
  Future updateLevel(levelId, Map<String, dynamic> level) async {
    final response = await HttpRequest.putReturnDynamic('$SUFFIX_LEVEL/update/$levelId', level);
    return response;
  }

}