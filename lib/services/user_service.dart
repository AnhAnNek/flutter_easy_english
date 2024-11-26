import 'package:flutter_easy_english/services/i_user_service.dart';
import 'package:flutter_easy_english/utils/http_request.dart';

class UserService extends IUserService {
  final String SUFFIX_USER = '/v1/users';

  @override
  Future addUserForAdmin(userForAdmin) async {
    final response = await HttpRequest.postReturnDynamic('$SUFFIX_USER/admin/add', userForAdmin);
    return response;
  }

  @override
  Future deleteUserForAdmin(username) async {
    final response = await HttpRequest.putReturnDynamic('$SUFFIX_USER/admin/delete/$username', null);
    return response;
  }

  @override
  Future getUserByUsername(username) async {
    final response = await HttpRequest.getReturnDynamic('$SUFFIX_USER/get-by-id/$username}');
    return response;
  }

  @override
  Future getUsersWithoutAdmin(filterReq) async {
    final response = await HttpRequest.postReturnDynamic('$SUFFIX_USER/admin/get', filterReq);
    return response;
  }

  @override
  Future updateUserForAdmin(username, userForAdminReq) async {
    final response = await HttpRequest.putReturnDynamic('$SUFFIX_USER/admin/update/$username', userForAdminReq);
    return response;
  }

  @override
  Future updateAudioFileForAdmin(username, avatar) async {
    final response = await HttpRequest.putReturnDynamic('$SUFFIX_USER/admin/upload-avatar/$username', avatar);
    return response;
  }
}