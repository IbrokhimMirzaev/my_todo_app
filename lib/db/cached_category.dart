const String categoryTable = "cached_categories";

class CachedCategoryFields {
  static const String id = "_id";
  static const String categoryIcon = "category_icon";
  static const String categoryName = "category_name";
  static const String categoryColor = "category_color";
}
class CachedCategory {
  final int? id;
  final String categoryIcon;
  final String categoryName;
  final int categoryColor;

  CachedCategory({
    this.id,
    required this.categoryIcon,
    required this.categoryName,
    required this.categoryColor,
  });

  CachedCategory copyWith({
    int? id,
    String? categoryIcon,
    int? categoryColor,
    String? categoryName,
  }) =>
      CachedCategory(
        id: id ?? this.id,
        categoryColor: categoryColor ?? this.categoryColor,
        categoryName: categoryName ?? this.categoryName,
        categoryIcon: categoryIcon ?? this.categoryIcon,
      );

  static CachedCategory fromJson(Map<String, Object?> json) => CachedCategory(
    id: json[CachedCategoryFields.id] as int?,
    categoryName: json[CachedCategoryFields.categoryName] as String,
    categoryIcon: json[CachedCategoryFields.categoryIcon] as String,
    categoryColor: json[CachedCategoryFields.categoryColor] as int,
  );

  Map<String, Object?> toJson() {
    return {
      CachedCategoryFields.id: id,
      CachedCategoryFields.categoryIcon: categoryIcon,
      CachedCategoryFields.categoryColor: categoryColor,
      CachedCategoryFields.categoryName: categoryName,
    };
  }

  @override
  String toString() => "id = $id;  categoryName = $categoryName;  color = $categoryColor;";
}
