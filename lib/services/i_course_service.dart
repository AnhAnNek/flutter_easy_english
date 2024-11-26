

abstract class ICourseService {
  Future<dynamic> fetchAllCourses();
  Future<Map<String, dynamic>?> createCourse(Map<String, dynamic> courseRequest);
  Future<Map<String, dynamic>?> updateCourse(Map<String, dynamic> courseRequest);
  Future<bool> deleteCourse(Map<String, dynamic> courseRequest);
  Future<dynamic> fetchAllCourseOfTeacher(Map<String, dynamic> courseRequest);
  Future<Map<String, dynamic>?> getCourseByFilter(Map<String, dynamic> courseRequest);
  Future<Map<String, dynamic>?> getCourseOfFavourite(Map<String, dynamic> courseRequest);
  Future<bool> deleteCourseOfFavourite(Map<String, dynamic> courseRequest);
  Future<Map<String, dynamic>?> getEnrollCourse(Map<String, dynamic> courseRequest);
  Future<Map<String, dynamic>?> fetchMainCourse(Map<String, dynamic> courseRequest);
  Future<bool> addCourseToFavourite(Map<String, dynamic> courseRequest);
  Future<dynamic> getAllCourseForAdmin(Map<String, dynamic> filterReq);
  Future<dynamic> updateCourseStatus(int courseId, String? status);
}
