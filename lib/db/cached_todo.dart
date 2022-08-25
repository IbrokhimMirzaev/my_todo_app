const String todoTable = "cached_todos";

class CachedTodoFields {
  static const String id = "_id";
  static const String categoryId = "category_id";
  static const String dateTime = "date_time";
  static const String isDone = "is_done";
  static const String todoDescription = "todo_description";
  static const String todoTitle = "todo_title";
  static const String urgentLevel = "urgent_level";
}
class CachedTodo {
  final int? id;
  final int categoryId;
  final String dateTime;
  int isDone;
  final String todoDescription;
  final String todoTitle;
  final int urgentLevel;

  CachedTodo({
    this.id,
    required this.categoryId,
    required this.dateTime,
    required this.isDone,
    required this.todoDescription,
    required this.todoTitle,
    required this.urgentLevel,
  });

  CachedTodo copyWith({
    int? id,
    int? categoryId,
    int? isDone,
    int? urgentLevel,
    String? dateTime,
    String? todoDescription,
    String? todoTitle,
  }) =>
      CachedTodo(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        dateTime: dateTime ?? this.dateTime,
        isDone: isDone ?? this.isDone,
        todoDescription: todoDescription ?? this.todoDescription,
        todoTitle: todoTitle ?? this.todoTitle,
        urgentLevel: urgentLevel ?? this.urgentLevel,
      );

  static CachedTodo fromJson(Map<String, Object?> json) => CachedTodo(
    id: json[CachedTodoFields.id] as int?,
    categoryId: json[CachedTodoFields.categoryId] as int,
    dateTime: json[CachedTodoFields.dateTime] as String,
    isDone: json[CachedTodoFields.isDone] as int,
    todoDescription: json[CachedTodoFields.todoDescription] as String,
    todoTitle: json[CachedTodoFields.todoTitle] as String,
    urgentLevel: json[CachedTodoFields.urgentLevel] as int,
  );

  Map<String, Object?> toJson() {
    return {
      CachedTodoFields.id: id,
      CachedTodoFields.categoryId: categoryId,
      CachedTodoFields.dateTime: dateTime,
      CachedTodoFields.isDone: isDone,
      CachedTodoFields.todoDescription: todoDescription,
      CachedTodoFields.todoTitle: todoTitle,
      CachedTodoFields.urgentLevel: urgentLevel,
    };
  }

  @override
  String toString() => "id = $id;  categoryId = $categoryId;  title = $todoTitle;";
}
