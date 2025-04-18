import 'package:recipe/model/biriyani_model.dart';

List<BiriyaniModel> getBiriyani() {
  List<BiriyaniModel> biriyani = [];

  BiriyaniModel biriyaniModel = BiriyaniModel();
  biriyaniModel.name = "Hyderabadi Dum Biriyani";
  biriyaniModel.image = "images/HyderabadiBiriyani.jpg";
  biriyaniModel.time = "1 hr 20 mins";
  biriyani.add(biriyaniModel);

  biriyaniModel =  BiriyaniModel();
  biriyaniModel.name = "Kolkata Dum Biriyani";
  biriyaniModel.image = "images/KolkataBiriyani.jpg";
  biriyaniModel.time = "50 mins";
  biriyani.add(biriyaniModel);

  biriyaniModel = BiriyaniModel();
  biriyaniModel.name = "Lucknowi Dum Biriyani";
  biriyaniModel.image = "images/LucknowiBiriyani.jpg";
  biriyaniModel.time = "50 mins";
  biriyani.add(biriyaniModel);

  biriyaniModel = BiriyaniModel();
  biriyaniModel.name = "Chettinad Biriyani";
  biriyaniModel.image = "images/ChettinadBiriyani.jpg";
  biriyaniModel.time = "50 mins";
  biriyani.add(biriyaniModel);

  return biriyani;
}