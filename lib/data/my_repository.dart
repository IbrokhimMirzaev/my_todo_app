import 'package:my_todo_app/data/local_data/storage.dart';
import 'package:my_todo_app/db/cached_category.dart';
import 'package:my_todo_app/db/cached_todo.dart';
import 'package:my_todo_app/db/local_database.dart';
import 'package:my_todo_app/models/profile_model.dart';

class MyRepository {
  static final MyRepository _instance = MyRepository._();

  factory MyRepository() {
    return _instance;
  }

  MyRepository._();

  // -------   Shared Preferences Side   -----------
  static getProfileImageUrl() => StorageRepository.getString("profile_image");

  static Future<ProfileModel> getProfileModel() async {
    await StorageRepository.getInstance();
    String imagePath = StorageRepository.getString("profile_image");
    String password = StorageRepository.getString("password");
    String username = StorageRepository.getString("name");

    ProfileModel userData = ProfileModel(
      imagePath: imagePath,
      password: password,
      username: username,
    );

    return userData;
  }

  //----- Local cache Categories ---------

  static Future<CachedCategory> insertCachedCategory({required CachedCategory cachedCategory}) async {
    return await LocalDatabase.insertCachedCategory(cachedCategory);
  }

  static Future<List<CachedCategory>> getAllCachedCategories() async {
    return await LocalDatabase.getAllCachedCategories();
  }

  static Future<CachedCategory> getCachedCategoryById({required int id}) async {
    return await LocalDatabase.getCachedCategoryById(id);
  }

  static Future<int> deleteCachedCategoryById({required int id}) async {
    return await LocalDatabase.deleteCachedCategoryById(id);
  }

  static Future<int> updateCachedCategory(
      {required CachedCategory cachedCategory}) async {
    return await LocalDatabase.updateCachedCategory(cachedCategory);
  }

  static Future<int> deleteAllCachedCategories() async {
    return await LocalDatabase.deleteAllCachedCategories();
  }

  //----------------   Local cache Todos  ---------------------

  static Future<CachedTodo> insertCachedTodo(
      {required CachedTodo cachedTodo}) async {
    return await LocalDatabase.insertCachedTodo(cachedTodo);
  }

  static Future<List<CachedTodo>> getAllCachedTodos() async {
    return await LocalDatabase.getAllCachedTodos();
  }

  static Future<List<CachedTodo>> getTodosByDone({required int isDone}) async {
    return await LocalDatabase.getTodosByDone(isDone);
  }

  static Future<int> deleteCachedTodoById({required int id}) async {
    return await LocalDatabase.deleteCachedTodoById(id);
  }

  static Future<int> updateCachedTodo(
      {required int id, required int status}) async {
    return await LocalDatabase.updateCachedTodoStatus(id, status);
  }

  static Future<int> updateAllCachedTodoFields({
    required int id,
    required String title,
    required String desc,
    required int categoryId,
    required int urgentLevel,
  }) async {
    return await LocalDatabase.updateCachedTodoAll(id, title, desc, categoryId, urgentLevel);
  }

  static Future<int> deleteAllCachedTodos() async {
    return await LocalDatabase.deleteAllCachedTodos();
  }
}
