import 'package:recipe/model/category_model.dart';

List<CategoryModel> getCategories(){

  List<CategoryModel> category = [];
  CategoryModel categoryModel = CategoryModel();

  categoryModel.name="Breakfast";
  categoryModel.image="images/breakfast.jpg";
  category.add(categoryModel);
  categoryModel = CategoryModel();

  categoryModel.name="Lunch";
  categoryModel.image="images/Lunch.jpg";
  category.add(categoryModel);
  categoryModel = CategoryModel();

  categoryModel.name="Dinner";
  categoryModel.image="images/dinner.jpg";
  category.add(categoryModel);
  categoryModel = CategoryModel();

  categoryModel.name="Dessert";
  categoryModel.image="images/Dessert.jpg";
  category.add(categoryModel);
  categoryModel = CategoryModel();

  categoryModel.name="Drinks";
  categoryModel.image="images/drinks.jpg";
  category.add(categoryModel);
  categoryModel = CategoryModel();

  return category;
}