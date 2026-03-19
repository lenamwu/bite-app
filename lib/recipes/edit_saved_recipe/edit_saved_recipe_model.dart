import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/recipes/ingredient_field/ingredient_field_widget.dart';
import '/recipes/preparation_field/preparation_field_widget.dart';
import 'edit_saved_recipe_widget.dart' show EditSavedRecipeWidget;
import 'package:flutter/material.dart';

class EditSavedRecipeModel extends FlutterFlowModel<EditSavedRecipeWidget> {
  final formKey = GlobalKey<FormState>();

  // Title
  FocusNode? titleFocusNode;
  TextEditingController? titleTextController;

  // Notes
  FocusNode? notesFocusNode;
  TextEditingController? notesTextController;

  // Dropdowns
  String? cookingtimeValue;
  FormFieldController<String>? cookingtimeValueController;
  String? difficultyValue;
  FormFieldController<String>? difficultyValueController;
  String? servingsValue;
  FormFieldController<String>? servingsValueController;

  // Dynamic ingredient/preparation fields
  late FlutterFlowDynamicModels<IngredientFieldModel> ingredientFieldModels;
  late FlutterFlowDynamicModels<PreparationFieldModel> preparationFieldModels;

  bool dataLoaded = false;

  // Original values for change detection
  String originalTitle = '';
  String originalNotes = '';
  String? originalCookingtime;
  String? originalDifficulty;
  String? originalServings;
  List<String> originalIngredients = [];
  List<String> originalPreparation = [];

  @override
  void initState(BuildContext context) {
    ingredientFieldModels =
        FlutterFlowDynamicModels(() => IngredientFieldModel());
    preparationFieldModels =
        FlutterFlowDynamicModels(() => PreparationFieldModel());
  }

  @override
  void dispose() {
    titleFocusNode?.dispose();
    titleTextController?.dispose();
    notesFocusNode?.dispose();
    notesTextController?.dispose();
    ingredientFieldModels.dispose();
    preparationFieldModels.dispose();
  }
}
