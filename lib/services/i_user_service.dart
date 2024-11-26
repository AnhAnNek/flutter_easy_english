abstract class IUserService {
  Future getUserByUsername(username);
  Future getUsersWithoutAdmin(filterReq);
  Future updateUserForAdmin(username, userForAdminReq);
  Future deleteUserForAdmin(username);
  Future addUserForAdmin(userForAdmin);
  Future updateAudioFileForAdmin(username, avatar);
}