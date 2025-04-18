import 'package:recipe/model/burger_model.dart';


List<BurgerModel> getBurger() {
  List<BurgerModel> burger = [];

  BurgerModel burgerModel = BurgerModel();
  burgerModel.name = "CheeseBurger";
  burgerModel.image = "images/CheeseBurger.jpg";
  burgerModel.time = "25 mins";
  burger.add(burgerModel);

  burgerModel = BurgerModel();
  burgerModel.name = "Onion Burger";
  burgerModel.image = "images/OnionBurger.jpg";
  burgerModel.time = "30 mins";
  burger.add(burgerModel);

  burgerModel = BurgerModel();
  burgerModel.name = "Aloo Tikki Burger";
  burgerModel.image = "images/AlooTikkiBurger.jpg";
  burgerModel.time = "40 mins";
  burger.add(burgerModel);

  burgerModel = BurgerModel();
  burgerModel.name = "Veggie Burger";
  burgerModel.image = "images/VeggieBurger.jpg";
  burgerModel.time = "50 mins";
  burger.add(burgerModel);



  return burger;
}