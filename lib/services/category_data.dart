import 'package:recipe/model/category_model.dart';

List<CategoryModel> getCategories(){

  List<CategoryModel> category = [];
  CategoryModel categoryModel = CategoryModel();

  categoryModel.name="Biriyani";
  categoryModel.image="images/Biriyani.jpg";
  category.add(categoryModel);
  categoryModel = CategoryModel();

  categoryModel.name="Burger";
  categoryModel.image="images/Burger.jpg";
  category.add(categoryModel);
  categoryModel = CategoryModel();

  categoryModel.name="South-Indian";
  categoryModel.image="images/South-Indian.jpg";
  category.add(categoryModel);
  categoryModel = CategoryModel();

  categoryModel.name="North-Indian";
  categoryModel.image="images/North-Indian.jpg";
  category.add(categoryModel);
  categoryModel = CategoryModel();

  return category;
}