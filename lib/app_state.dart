import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/api_requests/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  bool _searchisactive = false;
  bool get searchisactive => _searchisactive;
  set searchisactive(bool value) {
    _searchisactive = value;
  }

  List<String> _ingredientsList = [''];
  List<String> get ingredientsList => _ingredientsList;
  set ingredientsList(List<String> value) {
    _ingredientsList = value;
  }

  void addToIngredientsList(String value) {
    ingredientsList.add(value);
  }

  void removeFromIngredientsList(String value) {
    ingredientsList.remove(value);
  }

  void removeAtIndexFromIngredientsList(int index) {
    ingredientsList.removeAt(index);
  }

  void updateIngredientsListAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    ingredientsList[index] = updateFn(_ingredientsList[index]);
  }

  void insertAtIndexInIngredientsList(int index, String value) {
    ingredientsList.insert(index, value);
  }

  List<String> _preparationList = [''];
  List<String> get preparationList => _preparationList;
  set preparationList(List<String> value) {
    _preparationList = value;
  }

  void addToPreparationList(String value) {
    preparationList.add(value);
  }

  void removeFromPreparationList(String value) {
    preparationList.remove(value);
  }

  void removeAtIndexFromPreparationList(int index) {
    preparationList.removeAt(index);
  }

  void updatePreparationListAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    preparationList[index] = updateFn(_preparationList[index]);
  }

  void insertAtIndexInPreparationList(int index, String value) {
    preparationList.insert(index, value);
  }

  bool _hasRecipe = false;
  bool get hasRecipe => _hasRecipe;
  set hasRecipe(bool value) {
    _hasRecipe = value;
  }

  String _recipetitle = '';
  String get recipetitle => _recipetitle;
  set recipetitle(String value) {
    _recipetitle = value;
  }

  String _recipenotes = '';
  String get recipenotes => _recipenotes;
  set recipenotes(String value) {
    _recipenotes = value;
  }

  String _difficulty = '';
  String get difficulty => _difficulty;
  set difficulty(String value) {
    _difficulty = value;
  }

  String _cookingtime = '';
  String get cookingtime => _cookingtime;
  set cookingtime(String value) {
    _cookingtime = value;
  }

  String _servings = '';
  String get servings => _servings;
  set servings(String value) {
    _servings = value;
  }

  bool _editedRecipe = false;
  bool get editedRecipe => _editedRecipe;
  set editedRecipe(bool value) {
    _editedRecipe = value;
  }
}
