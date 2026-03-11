import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/recipes/ingredient_field/ingredient_field_widget.dart';
import '/recipes/preparation_field/preparation_field_widget.dart';
import 'dart:ui';
import 'recipe_form_widget.dart' show RecipeFormWidget;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RecipeFormModel extends FlutterFlowModel<RecipeFormWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for recipe_text widget.
  FocusNode? recipeTextFocusNode;
  TextEditingController? recipeTextTextController;
  String? Function(BuildContext, String?)? recipeTextTextControllerValidator;
  String? _recipeTextTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'recipe name is required';
    }

    if (val.length < 2) {
      return 'Requires at least 2 characters.';
    }
    if (val.length > 50) {
      return 'Maximum 50 characters allowed, currently ${val.length}.';
    }

    return null;
  }

  // State field(s) for notes_text widget.
  FocusNode? notesTextFocusNode;
  TextEditingController? notesTextTextController;
  String? Function(BuildContext, String?)? notesTextTextControllerValidator;
  // State field(s) for cookingtime widget.
  String? cookingtimeValue;
  FormFieldController<String>? cookingtimeValueController;
  // State field(s) for difficulty widget.
  String? difficultyValue;
  FormFieldController<String>? difficultyValueController;
  // State field(s) for servings widget.
  String? servingsValue;
  FormFieldController<String>? servingsValueController;
  // Models for ingredientField dynamic component.
  late FlutterFlowDynamicModels<IngredientFieldModel> ingredientFieldModels;
  // Models for preparationField dynamic component.
  late FlutterFlowDynamicModels<PreparationFieldModel> preparationFieldModels;
  // Stores action output result for [Validate Form] action in Button widget.
  bool? formValidation;

  @override
  void initState(BuildContext context) {
    recipeTextTextControllerValidator = _recipeTextTextControllerValidator;
    ingredientFieldModels =
        FlutterFlowDynamicModels(() => IngredientFieldModel());
    preparationFieldModels =
        FlutterFlowDynamicModels(() => PreparationFieldModel());
  }

  @override
  void dispose() {
    recipeTextFocusNode?.dispose();
    recipeTextTextController?.dispose();

    notesTextFocusNode?.dispose();
    notesTextTextController?.dispose();

    ingredientFieldModels.dispose();
    preparationFieldModels.dispose();
  }
}
